extends Node2D

export(String) var display_name = "Unnamed device"

var edges = []

func get_edges():
	if $Port.current_plug != null:
		return [$Port.current_plug.cable]
	return []

func get_neighbors():
	var neighbors = []
	for edge in get_edges():
		neighbors.append(edge.get_other_vertex(self))
	return neighbors

func get_display_name():
	return display_name
	
func _ready():
	$Port.vertex = self
