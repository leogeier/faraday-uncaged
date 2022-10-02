															   extends Node2D


var current_rules = []
var rule_solver

var started = false
var rounds = 0
var difficulty = 1

signal game_lost

func _ready():
	rule_solver = RuleSolver.new()
	$ToolBox.add_cable_short()
	$ToolBox.add_cable_long()
	$ToolBox.add_cable_long()
	$ToolBox.add_hub_3()
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

func on_power_surge():
	print("surge event!")
	if not check_rules(current_rules):
		die()
		
	rounds += 1
	difficulty = ceil(sqrt(rounds))
		
	create_new_rules()
	
func create_new_rules():
	var new_rules = current_rules
	while check_rules(new_rules):
		new_rules = rule_solver.generate_ruleset($FuseBox.get_devices(), $ToolBox.get_hubs(), $ToolBox.get_cables(), difficulty, ceil(difficulty * 0.5))
	
	set_rules(new_rules)

func _process(delta):
	if not started and check_rules(current_rules):
		start_cycle()
