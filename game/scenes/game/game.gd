extends Node2D


var current_rules = []
var rule_solver

var started = false

signal game_lost

# Called when the node enters the scene tree for the first time.
func _ready():
	rule_solver = RuleSolver.new()
	$ToolBox.add_cable_short()
	$ToolBox.add_cable_short()
	$ToolBox.add_cable_short()
	$ToolBox.add_hub_3()
	create_new_rules()


func set_rules(rules):
	current_rules = rules
	$RuleDisplay.update_rules(rules)
	
	
func check_rules():
	for rule in current_rules:
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
	if not check_rules():
		die()
		
	create_new_rules()
	
func create_new_rules():
	var new_rules = rule_solver.generate_ruleset($FuseBox.get_devices(), $ToolBox.get_hubs(), $ToolBox.get_cables(), 4, 1)
	set_rules(new_rules)

func _process(delta):
	if not started and check_rules():
		start_cycle()
