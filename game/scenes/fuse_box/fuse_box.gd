extends Node2D

export(Texture) var state_2_sprite = null
export(Texture) var state_1_sprite = null
export(Texture) var state_0_sprite = null

func get_devices():
	var devices = []
	for child in get_children():
		if child.is_in_group("device"):
			devices.push_back(child)
			
	return devices

func set_state(state):
	if state == 2:
		$Background.texture = state_2_sprite
	elif state == 1:
		$Background.texture = state_1_sprite
	elif state == 0:
		$Background.texture = state_0_sprite
	else:
		assert(false, "invalid state")
	
