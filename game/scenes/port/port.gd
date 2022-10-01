extends Node2D

var plug

func on_area_entered(area):
	if !is_used() and area.is_in_group("plug"):
		modulate = Color.green

func on_area_exited(area):
	print(area)

func is_used():
	return plug != null
