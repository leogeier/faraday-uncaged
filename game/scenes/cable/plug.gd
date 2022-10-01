extends StaticBody2D

var counterpart setget set_counterpart
var cable_length
var debug_viz

var is_dragging = false
var desired_position
var cable_radius_viz_enabled = false
var dragged_over_port
var current_port

signal started_dragging
signal stopped_dragging

func set_counterpart(value):
	counterpart = value
	counterpart.connect("started_dragging", self, "counterpart_started_dragging")
	counterpart.connect("stopped_dragging", self, "counterpart_stopped_dragging")

func get_start_position():
	return position

func get_end_position():
	return get_start_position()

func counterpart_started_dragging():
	cable_radius_viz_enabled = true
	update()
	
func counterpart_stopped_dragging():
	cable_radius_viz_enabled = false
	update()

func insert_into_port(port):
	position = port.position

func on_area_entered(area):
	if !area.is_in_group("port"):
		return
	
	dragged_over_port = area.get_port()
	dragged_over_port.hover_with_plug(self)

func on_area_exited(area):
	if !area.is_in_group("port"):
		return
	
	dragged_over_port.unhover_with_plug(self)
	dragged_over_port = null

func _draw():
	if debug_viz and cable_radius_viz_enabled:
		draw_arc(Vector2.ZERO, cable_length, 0, TAU, 30, Color.red)

func _input(event):
	if event is InputEventMouseMotion:
		if is_dragging:
			desired_position += event.relative
			if desired_position.distance_to(counterpart.position) > cable_length:
				position = counterpart.position + counterpart.position.direction_to(desired_position) * cable_length
			else:
				position = desired_position
			position = position.floor()
	
	if event is InputEventMouseButton and !event.pressed:
		is_dragging = false
		emit_signal("stopped_dragging")
		if dragged_over_port != null:
			current_port = dragged_over_port
			current_port.insert_plug(self)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		is_dragging = true
		desired_position = position
		emit_signal("started_dragging")
		if current_port != null:
			current_port.remove_plug(self)
			current_port = null
