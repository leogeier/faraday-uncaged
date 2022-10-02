extends Node2D


func add_cable_short():
	var cable = preload("res://scenes/cable/cable.tscn").instance()
	cable.cable_length = 80
	cable.regenerate()
	$Cables.add_child(cable)
	
func add_cable_long():
	var cable = preload("res://scenes/cable/cable.tscn").instance()
	cable.cable_length = 150
	cable.regenerate()
	$Cables.add_child(cable)
	
func add_hub_2():
	var hub = preload("res://scenes/hub/hub2.tscn").instance()
	$Hubs.add_child(hub)
	
func add_hub_3():
	var hub = preload("res://scenes/hub/hub3.tscn").instance()
	$Hubs.add_child(hub)
	
func add_hub_4():
	var hub = preload("res://scenes/hub/hub4.tscn").instance()
	$Hubs.add_child(hub)
	
	
func get_cables():
	var cables = []
	for child in $Cables.get_children():
		cables.push_back(child)
			
	return cables
	
func get_hubs():
	var hubs = []
	for child in $Hubs.get_children():
		hubs.push_back(child)
			
	return hubs

