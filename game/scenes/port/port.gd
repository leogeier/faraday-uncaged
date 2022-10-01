extends Node2D

func hover_with_plug(_plug):
	modulate = Color.green

func unhover_with_plug(_plug):
	modulate = Color.white

func insert_plug(plug):
	modulate = Color.blue
	$RemoteTransform2D.remote_path = plug.get_path()

func remove_plug(_plug):
	modulate = Color.green
	$RemoteTransform2D.remote_path = ""
