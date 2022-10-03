extends Node2D

var vertex

var current_plug

signal start_dragging
signal stopped_dragging

func hover_with_plug(_plug):
	modulate = Color.green

func unhover_with_plug(_plug):
	modulate = Color.white

func insert_plug(plug):
	modulate = Color.blue
	$RemoteTransform2D.remote_path = plug.get_path()
	current_plug = plug
	$PlugInsert.play()
	Game.get_instance(self).spawn_sparks(global_position)

func remove_plug(_plug):
	modulate = Color.green
	$RemoteTransform2D.remote_path = ""
	current_plug = null
	$PlugInsert.play()

func can_accept_plug():
	return current_plug == null
