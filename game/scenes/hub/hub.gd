extends Area2D

class_name Hub

export(String) var display_name = "Unnamed hub"

var is_dragging = false
var desired_position
var drag_priority = -1

func get_edges():
	var edges = []
	for port in $Ports.get_children():
		if port.current_plug != null:
			edges.push_back(port.current_plug.cable)
	return edges

# code dup with device
func get_neighbors():
	var neighbors = []
	for edge in get_edges():
		var other_vertex = edge.get_other_vertex(self)
		if other_vertex != null:
			neighbors.append(other_vertex)
	return dedup(neighbors)

static func dedup(arr):
	if arr.empty():
		return arr
	arr.sort()
	var new_arr = [arr[0]]
	for i in range(1, arr.size()):
		if new_arr.back() != arr[i]:
			new_arr.push_back(arr[i])
	return new_arr

func get_display_name():
	return display_name

func get_port_count():
	return $Ports.get_child_count()

func get_connected_plugs():
	var plugs = []
	for port in $Ports.get_children():
		if port.current_plug != null:
			plugs.push_back(port.current_plug)
	return plugs

func distance_to(point):
	return INF

func _ready():
	add_to_group("draggable")
	add_to_group("hub")
	for port in $Ports.get_children():
		port.vertex = self

func _input(event):
	if event is InputEventMouseMotion:
		if is_dragging:
			desired_position += event.relative
			
			var adjusted_desired_position = desired_position
			# repeat this process multiple times to approach a correct solution
			for i in range(5):
				for plug in get_connected_plugs():
					if !plug.counterpart.is_plugging_in():
						continue
					
					var plug_desired_position = adjusted_desired_position + plug.global_position - global_position
					if plug_desired_position.distance_to(plug.counterpart.global_position) > plug.cable_length:
						var new_plug_desired_position = plug.counterpart.global_position + plug.counterpart.global_position.direction_to(plug_desired_position) * plug.cable_length
						var offset = new_plug_desired_position - plug_desired_position
						adjusted_desired_position += offset
			global_position = adjusted_desired_position.floor()
	
	if event is InputEventMouseButton and !event.pressed:
		is_dragging = false
#		emit_signal("stopped_dragging")
		for plug in get_connected_plugs():
			plug.counterpart.cable_radius_viz_enabled = false

func start_dragging():
	is_dragging = true
	desired_position = global_position
#		emit_signal("started_dragging")
	for plug in get_connected_plugs():
		plug.counterpart.cable_radius_viz_enabled = true
				

