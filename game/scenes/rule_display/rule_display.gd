extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_rules(new_rules):
	var text = ""
	for rule in new_rules:
		text += rule.get_description() + "\n\n"
		
	$Text.text = text
