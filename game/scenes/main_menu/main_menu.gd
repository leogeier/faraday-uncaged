extends Node2D

signal start_game

func _on_start():
	emit_signal("start_game", self)


func _on_quit():
	get_tree().quit()

func _ready():
	if OS.has_feature("HTML5"):
		$ButtonQuit.visible = false
		$Title/LightningViewport/LabelQuit.visible = false
