extends RigidBody2D

var segment_length setget set_segment_length
var previous_segment
var cable_width

func set_segment_length(value):
	segment_length = value
	$CollisionShape2D.position.x = segment_length / 2
	$CollisionShape2D.shape.extents.x = segment_length / 2 
	$EndPosition.position.x = segment_length

func get_start_position():
	return transform.xform($StartPosition.position)

func get_end_position():
#	return position + $EndPosition.position
	return transform.xform($EndPosition.position)

func set_other_joined_body(body):
	$PinJoint2D.node_b = body.get_path()
	previous_segment = body

func _process(_delta):
	update()

func _draw():
	draw_line($StartPosition.position, $EndPosition.position, Color.black, cable_width)
	draw_line($StartPosition.position, transform.xform_inv(previous_segment.get_end_position()), Color.black, cable_width)
