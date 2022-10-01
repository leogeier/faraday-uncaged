extends Rule

class_name ConnectedRule

var portA
var portB

func _init(portA, portB):
	self.portA = portA
	self.portB = portB


func check():
	var bfs_result = self.run_bfs(portA)
	
	return bfs_result.has(self.portB)
	

func check_on_verts(verts):
	var bfs_result = self.run_bfs(self.find_vert(portA, verts))
	
	return bfs_result.has(self.find_vert(portB, verts))


func get_description():
	return "Connect " + self.portA.get_display_name() + " and " + self.portB.get_display_name() + "."
