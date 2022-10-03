extends Node2D


var cable_pos = 0
var hub_pos = 0

func add_cable_short():
	var cable = preload("res://scenes/cable/cable.tscn").instance()
	cable.cable_length = 50
	cable.regenerate()
	cable.freeze()
	cable.position.y = cable_pos
	cable_pos += 20
	$Cables.add_child(cable)
	
func add_cable_long():
	var cable = preload("res://scenes/cable/cable.tscn").instance()
	cable.cable_length = 80
	cable.regenerate()
	cable.freeze()
	cable.position.y = cable_pos
	cable_pos += 20
	$Cables.add_child(cable)
	
func add_hub_2():
	var hub = preload("res://scenes/hub/hub2.tscn").instance()
	hub.position.y = hub_pos
	hub.position.x = 20
	hub_pos += 20
	$Hubs.add_child(hub)
	
func add_hub_3():
	var hub = preload("res://scenes/hub/hub3.tscn").instance()
	hub.position.y = hub_pos
	hub.position.x = 20
	hub_pos += 20
	$Hubs.add_child(hub)
	
func add_hub_4():
	var hub = preload("res://scenes/hub/hub4.tscn").instance()
	hub.position.y = hub_pos
	hub.position.x = 20
	hub_pos += 20
	$Hubs.add_child(hub)
	
	
func get_cables():
	var cables = []
	for child in $Cables.get_children():
		cables.push_back(child)
			
	return cables
	
func get_hubs():
	var hubs = []
	for child in $Hubs.get_children():
		hubs.push_back(child)
			
	return hubs

func on_plug_stopped_dragging(plug):
	plug.set_is_frozen(true)

func on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if !body.is_in_group("plug") and !body.is_in_group("freeze_shape"):
		return
	
	body.connect("stopped_dragging", self, "on_plug_stopped_dragging", [body])

func on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if !body.is_in_group("plug") and !body.is_in_group("freeze_shape"):
		return
	
	body.disconnect("stopped_dragging", self, "on_plug_stopped_dragging")
