extends Node2D

export(String) var display_name = "Unnamed device"

var edges = []

func get_edges():
	return edges

func get_neighbors():
	var neighbors = []
	for edge in get_edges():
		neighbors.append(edge.get_other_vertex(self))
	return neighbors

func get_display_name():
	return display_name
	
