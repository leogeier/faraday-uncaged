extends Node2D

signal start_game

func _on_start():
	emit_signal("start_game", self)


func _on_quit():
	get_tree().quit()
