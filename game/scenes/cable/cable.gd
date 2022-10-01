extends Node2D

var vertexA
var vertexB

func get_other_vertex(vertex):
	if vertex == vertexA:
		return vertexB
	if vertex == vertexB:
		return vertexA
	assert(false)
