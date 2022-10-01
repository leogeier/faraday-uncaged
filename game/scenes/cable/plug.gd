extends StaticBody2D

var is_dragging = false

func _input(event):
	if event is InputEventMouseMotion:
		if is_dragging:
			position += event.relative

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		is_dragging = event.pressed
