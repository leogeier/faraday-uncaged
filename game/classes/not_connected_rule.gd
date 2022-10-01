extends Rule

class_name NotConnectedRule

var portA
var portB

func _init(portA, portB):
	self.portA = portA
	self.portB = portB


func check():
	var bfs_result = self.run_bfs(portA)
	
	return not bfs_result.has(self.portB)


func get_description():
	return "Don't connect" + self.portA.get_display_name() + "and" + self.portB.get_display_name() + "."
