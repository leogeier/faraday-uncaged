extends Camera2D


var shake_timer = 0
var shake_time = 1

func shake(time):
	shake_timer = 1
	shake_time = time
	
func _process(delta):
	global_position = Vector2(0, 0)
	if shake_timer > 0:
		global_position += get_shake_offset(OS.get_ticks_msec())
	
	shake_timer = max(0, shake_timer - delta / shake_time)

func get_shake_offset(time):
	return 10 * shake_timer * Vector2(
		OpenSimplexNoise.new().get_noise_2d(0, time * 10),
		OpenSimplexNoise.new().get_noise_2d(time * 10, 1))
	
