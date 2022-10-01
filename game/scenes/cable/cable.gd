extends Node2D

export(int) var segment_length = 5
export(int) var cable_length = 50
export(bool) var debug_viz = false setget set_debug_viz

var vertex_a
var vertex_b

var last_segment
#var cable_width = 2
export(float) var current_cable_width = 2.5
var segments = []

func set_debug_viz(value):
	debug_viz = value
	$PlugA.debug_viz = debug_viz
	$PlugB.debug_viz = debug_viz

func get_other_vertex(vertex):
	if vertex == vertex_a:
		return vertex_b
	if vertex == vertex_b:
		return vertex_a
	assert(false, "given vertex is not connected to edge")

func on_plug_reached_max_distance():
	$AnimationPlayer.play("to_stretched_width")

func on_plug_away_from_max_distance():
	$AnimationPlayer.play("to_unstretched_width")

func _ready():
	assert(cable_length % segment_length == 0, "cable_length is not a multiple of segment_length")
	var previous_segment = $PlugA
	for _i in range(cable_length / segment_length):
		var segment = preload("res://scenes/cable/cable_segment.tscn").instance()
		segment.segment_length = segment_length / 2
		segment.position = previous_segment.get_end_position()
		segment.set_other_joined_body(previous_segment)
		segment.cable_width = current_cable_width
		add_child(segment)
		segments.push_back(segment)
		previous_segment = segment
	last_segment = previous_segment
	$PlugB.position = last_segment.get_end_position()
	$PlugB/PinJoint2D.node_b = last_segment.get_path()
	
	$PlugA.counterpart = $PlugB
	$PlugB.counterpart = $PlugA
	$PlugA.cable_length = cable_length
	$PlugB.cable_length = cable_length

func _process(_delta):
	for segment in segments:
		segment.cable_width = current_cable_width
	update()

func _draw():
	draw_line($PlugB.position, last_segment.get_end_position(), Color.black, current_cable_width)
