extends Node2D

var vertex_a
var vertex_b

func get_other_vertex(vertex):
	if vertex == vertex_a:
		return vertex_b
	if vertex == vertex_b:
		return vertex_a
	assert(false, "given vertex is not connected to edge")

func _ready():
	$PlugB.position.x
