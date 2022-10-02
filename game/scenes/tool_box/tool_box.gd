extends Node2D


func add_cable():
	var cable = preload("res://scenes/cable/cable.tscn").instance()
	add_child(cable)
	
