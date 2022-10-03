extends Node2D

var vertex

var current_plug

var may_connect = true

signal start_dragging
signal stopped_dragging

export(Color) var normal_col
export(Color) var hover_col
export(Color) var connected_col

func hover_with_plug(_plug):
	if may_connect:
		modulate = hover_col

func unhover_with_plug(_plug):
	modulate = normal_col

func insert_plug(plug):
	if may_connect:
		modulate = connected_col
		$RemoteTransform2D.remote_path = plug.get_path()
		current_plug = plug
		$PlugInsert.play()
		var game = Game.get_instance(self)
		game.spawn_sparks(global_position)
		game.on_connection_made()

func remove_plug(_plug):
	if may_connect:
		modulate = hover_col
		$RemoteTransform2D.remote_path = ""
		current_plug = null
		$PlugInsert.play()
		var game = Game.get_instance(self)
		game.on_connection_made()

func can_accept_plug():
	return current_plug == null

func set_may_connect(val):
	may_connect = val
