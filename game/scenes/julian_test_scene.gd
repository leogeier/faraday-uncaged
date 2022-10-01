extends Node2D


var rules = []
var rule_book

func _ready():
	$Cable.vertex_a = $DeviceA
	$Cable.vertex_b = $DeviceB
	
	$DeviceA.edges.push_back($Cable)
	$DeviceB.edges.push_back($Cable)
	
	
	var devices = []
	for i in range(10):
		var device = preload("res://scenes/device/device.tscn").instance()
		add_child(device)
		device.display_name = "D" + str(i)
		devices.push_back(device)
		
	var hubs = []
	for i in range(3):
		var hub = preload("res://scenes/hub/hub3.tscn").instance()
		add_child(hub)
		hub.display_name = "H" + str(i)
		hubs.push_back(hub)
		
	var cables = []
	for i in range(12):
		var cable = preload("res://scenes/cable/cable.tscn").instance()
		add_child(cable)
		cables.push_back(cable)
	
	
	for i in range(1):
		var t_before = OS.get_ticks_msec()
		var gen_ruleset = RuleSolver.new().generate_ruleset(devices, hubs, cables, 10, 4)
		var t_after = OS.get_ticks_msec()
		
		for rule in gen_ruleset:
			print(rule.get_description())
		print(str(t_after - t_before) + "ms")
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
