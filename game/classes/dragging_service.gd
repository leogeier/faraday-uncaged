extends Node

var events = []

func process_event(event):
	var mouse_position = event.position
	var space_state = get_tree().get_root().get_viewport().get_world_2d().direct_space_state
	var intersects = space_state.intersect_point(mouse_position, 32, [], 0x7FFFFFFF, true, true)
#	for i in intersects:
#		if i["collider"].is_in_group("draggable"):
#			print(i["collider"].owner)
#	print("-------")
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

func _input(event):
	if !(event is InputEventMouseButton and event.pressed):
		return
	events.push_back(event)

func _physics_process(delta):
	for event in events:
		process_event(event)
	events = []

func _ready():
	process_priority = 100
