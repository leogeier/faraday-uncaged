extends Node2D

export(String) var display_name = "Unnamed hub"

func get_port_count():
	return $Ports.get_child_count()

func get_display_name():
	return display_name
