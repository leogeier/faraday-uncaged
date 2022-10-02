extends Node2D


func add_cable():
	var cable = preload("res://scenes/cable/cable.tscn").instance()
	cable.cable_length = 100
	add_child(cable)
	
func get_cables():
	var cables = []
	for child in get_children():
		if child.is_in_group("cable"):
			cables.push_back(child)
			
	return cables
	
func get_hubs():
	var hubs = []
	for child in get_children():
		if child.is_in_group("hub"):
			hubs.push_back(child)
			
	return hubs

