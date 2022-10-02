extends Node

func _input(event):
	if !(event is InputEventMouseButton and event.pressed):
		return
	
	var mouse_position = event.position
	var space_state = get_tree().get_root().get_viewport().get_world_2d().direct_space_state
	var intersects = space_state.intersect_point(mouse_position, 32, [], 0x7FFFFFFF, true, true)
	if intersects.empty():
		return
	
	var best
	var best_distance = INF
	for intersect in intersects:
		var collider = intersect["collider"]
		if collider.is_in_group("draggable"):
			var distance = collider.distance_to(mouse_position)
			if best == null or (collider.drag_priority > best.drag_priority and distance < best_distance):
				best = collider
				best_distance = distance
	
	if best == null:
		return
	
	best.start_dragging()
