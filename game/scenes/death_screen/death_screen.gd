extends Node2D

signal close

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LightningViewport/ScoreLabel.text = "Score:\n%d" % Score.score


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_accept():
	emit_signal("close", self)
