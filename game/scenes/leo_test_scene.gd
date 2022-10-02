extends Node2D



func _on_Button_pressed():
	print($Cable.get_other_vertex($Hub3))
