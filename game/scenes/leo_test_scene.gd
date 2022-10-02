extends Node2D



func _on_Button_pressed():
#	print($Hub4.get_neighbors())

	var r = Rule.new().run_bfs($Hub4)
	print(r.size(), " ", r)
