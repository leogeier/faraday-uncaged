extends Node2D


var rules = []
var rule_book

func _ready():
	$Cable.vertex_a = $DeviceA
	$Cable.vertex_b = $DeviceB
	
	$DeviceA.edges.push_back($Cable)
	$DeviceB.edges.push_back($Cable)
	
	rules.push_back(ConnectedRule.new($DeviceA, $DeviceB))
	rules.push_back(NotConnectedRule.new($DeviceB, $DeviceC))
	update_text()
	
	print("Port count: ", $Hub.get_port_count())
	
	for i in range(3):
		var gen_ruleset = RuleSolver.new().generate_ruleset([$DeviceA, $DeviceB, $DeviceC], [$Hub], [$Cable, $Cable, $Cable], 3, 2)
		for rule in gen_ruleset:
			print(rule.get_description())
		print("")
	

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
