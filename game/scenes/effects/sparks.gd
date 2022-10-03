extends Particles2D

func spark():
	emitting = true
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
