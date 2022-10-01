extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rules = []
var rule_book

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	$Cable.vertex_a = $DeviceA
	$Cable.vertex_b = $DeviceB
	
	$DeviceA.edges.push_back($Cable)
	$DeviceB.edges.push_back($Cable)
	
	rules.push_back(ConnectedRule.new($DeviceA, $DeviceB))
	rules.push_back(NotConnectedRule.new($DeviceB, $DeviceC))
	update_text()
	
	for i in range(3):
		var gen_ruleset = RuleSolver.new().generate_ruleset([$DeviceA, $DeviceB, $DeviceC, $DeviceD], [], [$Cable, $Cable], 3, 2)
		for rule in gen_ruleset:
			print(rule.get_description())
		print("")
	
#	print(check_satisfied())

func update_text():
	var text = ""
	for rule in rules:
		text += rule.get_description() + "\n"
		
	$Rulebook.text = text
	
func check_satisfied():
	for rule in rules:
		if not rule.check():
			return false
			
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
