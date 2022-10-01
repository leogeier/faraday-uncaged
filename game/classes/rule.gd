extends Reference

class_name Rule



func get_description():
	return ""
	
func check():
	assert(false)
	
func check_on_verts(verts):
	assert(false)
	
func find_vert(node, verts):
	for vert in verts:
		if vert.associated_node == node:
			return vert
	
	assert(false)

func run_bfs(from):
	var discovered = [from]
	var processed = []
	
	while (discovered.size() > 0):
		var current_neighbors = []
		
		for elem in discovered:
			current_neighbors.append_array(elem.get_neighbors())
			
		processed.append_array(discovered)
		
		discovered = []
		for elem in current_neighbors:
			if (not processed.has(elem)):
				discovered.append(elem)
				
	return processed
