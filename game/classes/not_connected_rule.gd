extends Rule

class_name NotConnectedRule

var portA
var portB

func _init(portA, portB):
	self.portA = portA
	self.portB = portB

func get_rule_name():
	return "NotConnectedRule"

func get_color_a():
	return portA.color

func get_color_b():
	return portB.color

func get_operator_texture():
	return preload("res://scenes/rule_display/not_connect.png")

func get_operator_color():
	return Color.red

func check():
	var bfs_result = self.run_bfs(portA)
	
	return not bfs_result.has(self.portB)
	

func check_on_verts(verts):
	var bfs_result = self.run_bfs(verts[portA])
	
	return not bfs_result.has(verts[portB])

func get_penalty():
	return INF

func get_description():
	return "Don't connect " + self.portA.get_display_name() + " and " + self.portB.get_display_name() + "."
