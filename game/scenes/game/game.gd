extends Node2D


var current_rules = []
var rule_solver


# Called when the node enters the scene tree for the first time.
func _ready():
	rule_solver = RuleSolver.new()
	$ToolBox.add_cable()
	yield(get_tree().create_timer(5.0), "timeout")
	start_cycle()


func set_rules(rules):
	current_rules = rules
	$RuleDisplay.update_rules(rules)
	
	
func check_rules():
	for rule in current_rules:
		if not rule.check():
			return false
			
	return true
	
func start_cycle():
	$MusicLoop.stop()
	$MusicIngame.play()
	$SurgeTimer.start()

func die():
	print("you are dead!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_power_surge():
	print("surge event!")
	if not check_rules():
		die()
		
	create_new_rules()
	
func create_new_rules():
	var new_rules = rule_solver.generate_ruleset($FuseBox.get_devices(), [], [], 1, 1)
	set_rules(new_rules)

