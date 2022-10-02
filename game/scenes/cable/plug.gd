extends RigidBody2D

var counterpart setget set_counterpart
var cable_length
var debug_viz
var cable_radius_viz_enabled = false setget set_cable_radius_viz_enabled
var cable

var is_dragging = false
var desired_position
var dragged_over_port
var current_port
var can_signal_reached_max_distance = true

var drag_priority setget , get_drag_priority
var vertex setget , get_vertex

signal started_dragging
signal stopped_dragging

signal reached_max_distance
signal away_from_max_distance

func set_counterpart(value):
	counterpart = value
	counterpart.connect("started_dragging", self, "counterpart_started_dragging")
	counterpart.connect("stopped_dragging", self, "counterpart_stopped_dragging")

func set_cable_radius_viz_enabled(value):
	cable_radius_viz_enabled = value
	update()

func get_drag_priority():
	return 10 if is_plugging_in() else 20

func get_vertex():
	if is_plugging_in():
		return current_port.vertex
	return null

func get_start_position():
	return position

func get_end_position():
	return get_start_position()

func is_plugging_in():
	return current_port != null

func distance_to(point):
	return position.distance_to(point)

func counterpart_started_dragging():
	set_cable_radius_viz_enabled(true)
	
func counterpart_stopped_dragging():
	set_cable_radius_viz_enabled(false)

func insert_into_port(port):
	position = port.position

func on_area_entered(area):
	if !area.is_in_group("port"):
		return

func on_area_exited(area):
	if !area.is_in_group("port"):
		return

func can_connect_to_port(port):
	return port.can_accept_plug() and counterpart.global_position.distance_to(port.global_position) <= cable_length

func signal_reached_max_distance():
	if can_signal_reached_max_distance:
		can_signal_reached_max_distance = false
		emit_signal("reached_max_distance")

func enable_signal_reached_max_distance():
	if !can_signal_reached_max_distance:
		can_signal_reached_max_distance = true
		emit_signal("away_from_max_distance")

func start_dragging():
	is_dragging = true
	mode = RigidBody2D.MODE_KINEMATIC
	desired_position = position
	if is_plugging_in():
		current_port.remove_plug(self)
		current_port = null
	emit_signal("started_dragging")

func stop_dragging():
	is_dragging = false
	if dragged_over_port != null:
		current_port = dragged_over_port 
		mode = RigidBody2D.MODE_STATIC
		# need to wait a frame because the remote transform doesn't apply at first sometimes otherwise
		yield(get_tree(), "idle_frame")
		current_port.insert_plug(self)
	else:
		mode = RigidBody2D.MODE_RIGID
	emit_signal("stopped_dragging")

func _draw():
	if debug_viz and cable_radius_viz_enabled and is_plugging_in():
		draw_arc(Vector2.ZERO, cable_length, 0, TAU, 30, Color.red)

func _input(event):
	if event is InputEventMouseMotion:
		if is_dragging:
			desired_position += event.relative
			if counterpart.is_plugging_in() and desired_position.distance_to(counterpart.position) > cable_length:
				position = counterpart.position + counterpart.position.direction_to(desired_position) * cable_length
#				signal_reached_max_distance()
			else:
				position = desired_position
#				if position.distance_to(counterpart.position) < cable_length * 0.9:
#					enable_signal_reached_max_distance()
			position = position.floor()
	
	if event is InputEventMouseButton and !event.pressed and is_dragging:
		stop_dragging()

func _process(_delta):
	if is_dragging:
		var closest_port
		var closest_area_distance = INF
		for area in $Area2D.get_overlapping_areas():
			if !area.is_in_group("port"):
				continue
			var port = area.get_port()
			if !can_connect_to_port(port):
				continue
			
			var distance = global_position.distance_squared_to(port.global_position)
			if distance < closest_area_distance:
				closest_port = port
				closest_area_distance = distance
			
		if closest_port != dragged_over_port and dragged_over_port != null:
			dragged_over_port.unhover_with_plug(self)
		dragged_over_port = closest_port
		if dragged_over_port != null:
			dragged_over_port.hover_with_plug(self)
