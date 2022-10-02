extends Rule

class_name ConnectedRule

var portA
var portB

func _init(portA, portB):
	self.portA = portA
	self.portB = portB

func get_rule_name():
	return "ConnectedRule"

func get_color_a():
	return portA.color

func get_color_b():
	return portB.color
	
func get_operator_texture():
	return preload("res://scenes/rule_display/connect.png")

func get_operator_color():
	return Color.black

func check():
	var bfs_result = self.run_bfs(portA)
	
	return bfs_result.has(self.portB)
	
func get_penalty():
	return 1

func check_on_verts(verts):
	var bfs_result = self.run_bfs(verts[portA])
	
	return bfs_result.has(verts[portB])


func get_description():
	return "Connect " + self.portA.get_display_name() + " and " + self.portB.get_display_name() + "."
