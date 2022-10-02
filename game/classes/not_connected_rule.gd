extends Rule

class_name NotConnectedRule

var portA
var portB

func _init(portA, portB):
	self.portA = portA
	self.portB = portB


func check():
	var bfs_result = Rule.run_bfs(portA)
	
	return not bfs_result.has(self.portB)
	

func check_on_verts(verts):
	var bfs_result = Rule.run_bfs(verts[portA])
	
	return not bfs_result.has(verts[portB])

func get_penalty():
	return INF

func get_description():
	return "Don't connect " + self.portA.get_display_name() + " and " + self.portB.get_display_name() + "."
