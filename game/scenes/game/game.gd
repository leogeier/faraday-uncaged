extends Node2D

class_name Game

var current_rules = []
var rule_solver

var started = false
var rounds = 0
var difficulty = 1
var health = 2
var difficulty_reduction = 0
var surging = false

onready var musics = [$Music1, $Music2, $Music3, $Music4]
var music_idx = 0

signal game_lost

static func get_instance(node):
	return node.get_tree().get_nodes_in_group("game")[0]

func _ready():
	Score.reset_score()
	rule_solver = RuleSolver.new()
	$ToolBox.add_cable_short()
	$ToolBox.add_cable_long()
	$ToolBox.add_cable_long()
	$ToolBox.add_hub_3()
	
	#$Viewport/LightningCanvas.draw_lightning($ToolBox.get_cables(), 10000.0)
		
	
#	var vt = ViewportTexture.new()
#	vt.viewport_path = $Viewport.get_path()
#	$ColorRect.material.set_shader_param("lightning_buffer", vt)
	
	create_new_rules(false)

func spawn_sparks(point, sound = true):
	$Viewport/LightningCanvas.spawn_sparks(point)
	if sound:
		var player = AudioStreamPlayer.new()
		player.stream = AudioStreamRandomPitch.new()
		player.stream.audio_stream = $Crackle.stream
		player.play()
		add_child(player)
		yield(get_tree().create_timer(0.1), "timeout")
		player.stop()
		player.queue_free()

func get_adjusted_difficulty():
	return max(1, difficulty - difficulty_reduction)

func set_rules(rules, dramatic):
	if dramatic:
		current_rules = []
		$RuleDisplay.update_rules(current_rules)
		yield(get_tree().create_timer(0.4), "timeout")
		for rule in rules:
			yield(get_tree().create_timer(.4), "timeout")
			current_rules.push_back(rule)
			$RuleDisplay.update_rules(current_rules)
			$RuleAdd.play()
		yield(get_tree().create_timer(.4), "timeout")
	else:
		current_rules = rules
		$RuleDisplay.update_rules(rules)

func check_rules(rules):
	for rule in rules:
		if not rule.check():
			return false
			
	return true

func stop_music():
	for music in musics:
		music.stop()

func play_next_music():
	musics[music_idx].play()
	music_idx = (music_idx + 1) % musics.size()

func start_cycle():
	started = true
	$MusicLoop.stop()
#	play_next_music()
	$SurgeTimer.start()
	get_tree().create_tween().tween_property($TutorialText, "modulate", Color.transparent, 0.2)
	on_power_surge()

func die():
	emit_signal("game_lost", self)
	
func damage():
	health -= 1
	$FuseBox.set_state(health)
	$Camera.shake(0.5)
	$Explosion.play()

func on_power_surge():
	surging = true
	print("surge event!")
	var failed = false
	get_tree().call_group("port", "set_may_connect", false)
	if check_rules(current_rules):
		Score.increase_score(get_adjusted_difficulty())
		print("new score ", Score.score)
	else:
		if health > 0:
			damage()
			failed = true
			difficulty_reduction += 1
			if health == 0:
				$AlarmLight.on = true
				$AlarmLight.modulate = Color("#ff1111")
			var sound = true
			for _i in range(20):
				spawn_sparks(Vector2(100, 0) + Vector2(randf(), randf()) * 200)
				sound = false
		else:
			die()
	
	stop_music()
	
	var lightning_duration = 1.0
#	var electrified_cables = get_electrified_cables()
#	$Viewport/LightningCanvas.draw_lightning(get_electrified_cables(), lightning_duration)
#	var electrified
	for rule in current_rules:
		if rule.get_rule_name() == "NotConnectedRule" and !failed:
			continue
		
		$RuleDisplay.highlight(rule, true)
		var electrified_cables = []
		var bfs_result = bfs(rule.portA)
		if rule.portB in bfs_result.keys():
			var vertex = rule.portB
			while bfs_result[vertex] != null:
				electrified_cables.push_back(bfs_result[vertex])
				vertex = bfs_result[vertex].get_other_vertex(vertex)
		
		$Crackle.play()
		$Viewport/LightningCanvas.draw_lightning(electrified_cables, lightning_duration)
		yield(get_tree().create_timer(lightning_duration), "timeout")
		$Crackle.stop()
		$RuleDisplay.highlight(rule, false)
		yield(get_tree().create_timer(0.4), "timeout")
	
	rounds += 1
	difficulty = ceil(rounds / 3.0)
	
	if rounds == 10:
		$ToolBox.add_cable_short()
		$ToolBox.add_hub_3()
		
	if rounds == 15:
		$ToolBox.add_cable_long()
	
	yield(create_new_rules(), "completed")
	
	play_next_music()
	
	surging = false
	get_tree().call_group("port", "set_may_connect", true)
	$SurgeTimer.start()
	
#	if !electrified_cables.empty():
#		$Crackle.play()
#		yield(get_tree().create_timer(lightning_duration), "timeout")
#		$Crackle.stop()
	
func get_electrified_cables():
	var electrified_cables = []
	
	for rule in current_rules:
		var bfs_result = bfs(rule.portA)
		if rule.portB in bfs_result.keys():
			var vertex = rule.portB
			while bfs_result[vertex] != null:
				electrified_cables.push_back(bfs_result[vertex])
				vertex = bfs_result[vertex].get_other_vertex(vertex)
	
	return Hub.dedup(electrified_cables)
		
	
func create_new_rules(dramatic=true):
	var new_rules = current_rules
	for i in range(5):
		var adjusted_difficulty = get_adjusted_difficulty()
		new_rules = rule_solver.generate_ruleset($FuseBox.get_devices(), $ToolBox.get_hubs(), $ToolBox.get_cables(), adjusted_difficulty, ceil(adjusted_difficulty * 0.5))
		if not check_rules(new_rules):
			break
	
	if dramatic:
		yield(set_rules(new_rules, dramatic), "completed")
	else:
		set_rules(new_rules, dramatic)

static func bfs(from):
	var previous_edge_dict = {from: null}
	var border = [from]
	
	while !border.empty():
		var new_border = []
		for vertex in border:
			for edge in vertex.get_edges():
				var other_vertex = edge.get_other_vertex(vertex)
				if other_vertex != null and !(other_vertex in previous_edge_dict.keys()):
					previous_edge_dict[other_vertex] = edge
					new_border.push_back(other_vertex)
		border = new_border
	
	return previous_edge_dict

func on_connection_made():
	if surging:
		return
	
	if check_rules(current_rules):
		if not started:
			start_cycle()
		else:
			on_power_surge()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		current_rules = []
		if not started:
			start_cycle()
		else:
			on_power_surge()
	$RuleDisplay.set_progress(1 - $SurgeTimer.time_left / $SurgeTimer.wait_time)
