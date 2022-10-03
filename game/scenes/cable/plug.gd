extends RigidBody2D

var counterpart setget set_counterpart
var cable_length setget , get_cable_length
var debug_viz
var cable_radius_viz_enabled = false setget set_cable_radius_viz_enabled
var cable

var is_dragging = false
var desired_position
var dragged_over_port
var current_port
var can_signal_reached_max_distance = true
onready var prev_position = position

var drag_priority setget , get_drag_priority
var vertex setget , get_vertex
var overextended_radius

onready var trail_shapes = [$Trail1, $Trail2, $Trail3]

signal started_dragging
signal stopped_dragging

signal reached_max_distance
signal away_from_max_distance

func get_cable_length():
	return overextended_radius if is_overextended() else cable_length

func set_counterpart(value):
	counterpart = value
	counterpart.connect("started_dragging", self, "counterpart_started_dragging")
	counterpart.connect("stopped_dragging", self, "counterpart_stopped_dragging")

func set_cable_radius_viz_enabled(value):
	cable_radius_viz_enabled = value
#	update()

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

func set_is_frozen(is_frozen):
	if !is_plugging_in():
		mode = RigidBody2D.MODE_STATIC if is_frozen else RigidBody2D.MODE_RIGID

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
	return port.can_accept_plug()

func is_overextended():
	return counterpart.global_position.distance_to(global_position) > cable_length + 2

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
	position = transform.xform(get_local_mouse_position())
	desired_position = position
	if is_plugging_in():
		current_port.remove_plug(self)
		current_port = null
	if !counterpart.is_plugging_in():
		counterpart.set_is_frozen(false)
		set_cable_radius_viz_enabled(true)
	emit_signal("started_dragging")

func stop_dragging():
	set_cable_radius_viz_enabled(false)
	is_dragging = false
	if dragged_over_port != null:
		current_port = dragged_over_port 
		mode = RigidBody2D.MODE_STATIC
		# need to wait a frame because the remote transform doesn't apply at first sometimes otherwise
		yield(get_tree(), "idle_frame")
		current_port.insert_plug(self)
		if is_overextended():
			overextended_radius = current_port.global_position.distance_to(counterpart.global_position)
			counterpart.overextended_radius = overextended_radius
	else:
		mode = RigidBody2D.MODE_RIGID
	emit_signal("stopped_dragging")

func _draw():
	if debug_viz and cable_radius_viz_enabled and (is_plugging_in() or is_dragging):
		draw_arc(Vector2.ZERO, cable_length, 0, TAU, 30, Color.red)

func _input(event):
	if is_dragging and event is InputEventMouseMotion:
		desired_position += event.relative
		if counterpart.is_plugging_in() and desired_position.distance_to(counterpart.position) > cable_length:
			position = counterpart.position + counterpart.position.direction_to(desired_position) * cable_length
		else:
			position = desired_position
		position = position.floor()
	
	if event is InputEventMouseButton and !event.pressed and is_dragging:
		stop_dragging()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("click ", Time.get_ticks_msec())
		DraggingService._input(event)
		yield(get_tree().create_timer(0.1), "timeout")
		if !is_dragging:
			print("boooh")

func _physics_process(_delta):
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
	
	var trail_pos = prev_position - position
	var trail_scale = $CollisionShape2D.scale
	for trail in trail_shapes:
		var new_trail_pos = trail_pos + trail.position
		var new_trail_scale = trail.scale
		trail.position = trail_pos
		trail.scale = trail_scale
		trail_pos = new_trail_pos
		trail_scale = new_trail_scale
	
	var area_scale = 1 + min(3, linear_velocity.length() * 0.01)
	$CollisionShape2D.scale = Vector2.ONE * area_scale
	
	prev_position = position

func _process(_delta):
	update()

func _integrate_forces(state):
	if (counterpart.is_dragging or counterpart.is_plugging_in()) and counterpart.position.distance_to(position) > cable_length:
		position = counterpart.position + counterpart.position.direction_to(position) * cable_length

func _ready():
	for trail in trail_shapes:
		trail.shape = $CollisionShape2D.shape.duplicate()
