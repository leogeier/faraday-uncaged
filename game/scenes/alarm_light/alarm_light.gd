extends Node2D

enum DIRECTION {
	Clockwise = 1,
	Counterclockwise = -1
}

export(float) var speed = 1
export(DIRECTION) var direction = DIRECTION.Clockwise
export(bool) var on = false setget set_on

func set_on(value):
	on = value
	$Cast.visible = on

func _ready():
	set_on(on)

func _process(delta):
	$Cast.rotation += delta * speed * direction
