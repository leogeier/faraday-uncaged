extends Node2D



func _on_Button_pressed():
#	print($Hub4.get_neighbors())

	var r = Game.bfs($Device)
	print(r.size(), " ", r)
