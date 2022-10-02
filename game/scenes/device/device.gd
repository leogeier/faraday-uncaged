extends Node2D

export(String) var display_name = "Unnamed device" setget , get_display_name
export(Color, RGB) var color = Color.white setget set_color

var color_name

var edges = []

var color_dict = {Color.red: 1}

func get_display_name():
	if color_name != null:
		return color_name
	return display_name

func set_color(value):
	color = value
	$SpriteColor.modulate = color
	
	for c in color_dict.keys():
		if color.is_equal_approx(c):
			color_name = color_dict[c]
			return
	color_name = null

func get_edges():
	if $Port.current_plug != null:
		return [$Port.current_plug.cable]
	return []

func get_neighbors():
	var neighbors = []
	for edge in get_edges():
		var other_vertex = edge.get_other_vertex(self)
		if other_vertex != null:
			neighbors.append(other_vertex)
	return neighbors
	
func _ready():
	color_dict[Color.red] = "red"
	color_dict[Color.blue] = "blue"
	color_dict[Color.green] = "green"
	color_dict[Color.yellow] = "yellow"
	color_dict[Color.orange] = "orange"
	color_dict[Color.cyan] = "cyan"
	color_dict[Color.magenta] = "magenta"
#	color_dict[Color.white] = "white"
	color_dict[Color.black] = "black"
	color_dict[Color.gray] = "gray"
	color_dict[Color.pink] = "pink"
	
	$Port.vertex = self
	set_color(color)
