extends Node2D


var current_rules = []
var rule_solver

var started = false
var rounds = 0
var difficulty = 1
var health = 2

signal game_lost

func _ready():
	rule_solver = RuleSolver.new()
	$ToolBox.add_cable_short()
	$ToolBox.add_cable_long()
	$ToolBox.add_cable_long()
	$ToolBox.add_hub_3()
	
	#$Viewport/LightningCanvas.draw_lightning($ToolBox.get_cables(), 10000.0)
		
	
#	var vt = ViewportTexture.new()
#	vt.viewport_path = $Viewport.get_path()
#	$ColorRect.material.set_shader_param("lightning_buffer", vt)
	
	create_new_rules()

func set_rules(rules):
	current_rules = rules
	$RuleDisplay.update_rules(rules)

func check_rules(rules):
	for rule in rules:
		if not rule.check():
			return false
			
	return true
	
func start_cycle():
	started = true
	$MusicLoop.stop()
	$MusicIngame.play()
	$SurgeTimer.start()
	create_new_rules()

func die():
	emit_signal("game_lost", self)
	
func damage():
	health -= 1
	$FuseBox.set_state(health)
	$Camera.shake(0.5)

func on_power_surge():
	print("surge event!")
	if not check_rules(current_rules):
		if health > 0:
			damage()
		else:
			die()
		
	$Viewport/LightningCanvas.draw_lightning(get_electrified_cables(), 1.0)
	
	rounds += 1
	difficulty = ceil(rounds / 3.0)
	
	if rounds == 10:
		$ToolBox.add_cable_short()
		$ToolBox.add_hub_3()
		
	if rounds == 15:
		$ToolBox.add_cable_long()
		
	create_new_rules()
	
func get_electrified_cables():
	var electrified_nodes = []
	for device in $FuseBox.get_devices():
		var bfs_result = Rule.run_bfs(device)
		for node in bfs_result:
			if not electrified_nodes.has(node):
				electrified_nodes.push_back(node)
				
	print(electrified_nodes)
	
	var electrified_cables = []
	for cable in $ToolBox.get_cables():
		if (electrified_nodes.has(cable.get_vertex_a())
			or electrified_nodes.has(cable.get_vertex_b())):
				electrified_cables.append(cable)
				
	
	print(electrified_cables)
				
	return electrified_cables
		
	
func create_new_rules():
	var new_rules = current_rules
	for i in range(5):
		new_rules = rule_solver.generate_ruleset($FuseBox.get_devices(), $ToolBox.get_hubs(), $ToolBox.get_cables(), difficulty, ceil(difficulty * 0.5))
		if not check_rules(new_rules):
			break
		
	set_rules(new_rules)

func _process(delta):
	if not started and check_rules(current_rules):
		start_cycle()
	$RuleDisplay.set_progress(1 - $SurgeTimer.time_left / $SurgeTimer.wait_time)
