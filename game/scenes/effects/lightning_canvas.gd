extends Node2D

var active = true
var cables = []
var current_brighntess = 1.0

func _draw():
	for cable in cables:
		var last_point = null
		
		for point in cable.get_point_sequence():
			if last_point != null:
				draw_line(last_point, point, Color(current_brighntess, current_brighntess, current_brighntess))
				
			last_point = point
	
func draw_lightning(cables, duration):
	self.cables = cables
	current_brighntess = 1.0

func spawn_sparks(point):
	var sparks = preload("res://scenes/effects/sparks.tscn").instance()
	add_child(sparks)
	sparks.position = point
	sparks.spark()

func _process(_delta):
	if active:
		update()
		current_brighntess = max(current_brighntess - _delta, 0)
