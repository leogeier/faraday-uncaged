extends Node2D

func get_devices():
	var devices = []
	for child in get_children():
		if child.is_in_group("device"):
			devices.push_back(child)
			
	return devices
