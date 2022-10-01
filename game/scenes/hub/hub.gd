extends Area2D

export(String) var display_name = "Unnamed hub"

var is_dragging = false
var desired_position

func get_port_count():
	return $Ports.get_child_count()

func get_display_name():
	return display_name

func get_connected_plugs():
	var plugs = []
	for port in $Ports.get_children():
		if port.current_plug != null:
			plugs.push_back(port.current_plug)
	return plugs

func _input(event):
	if event is InputEventMouseMotion:
		if is_dragging:
			desired_position += event.relative
			
			var adjusted_desired_position = desired_position
			for plug in get_connected_plugs():
				var plug_desired_position = adjusted_desired_position + plug.global_position - global_position
				if plug_desired_position.distance_to(plug.counterpart.global_position) > plug.cable_length:
					var new_plug_desired_position = plug.counterpart.global_position + plug.counterpart.global_position.direction_to(plug_desired_position) * plug.cable_length
					var offset = new_plug_desired_position - plug_desired_position
					adjusted_desired_position += offset
#			else:
#				position = desired_position
			global_position = adjusted_desired_position.floor()
	
	if event is InputEventMouseButton and !event.pressed:
		is_dragging = false
		emit_signal("stopped_dragging")
		for plug in get_connected_plugs():
				plug.cable_radius_viz_enabled = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		is_dragging = true
		desired_position = global_position
		emit_signal("started_dragging")
		for plug in get_connected_plugs():
				plug.counterpart.cable_radius_viz_enabled = true
				

