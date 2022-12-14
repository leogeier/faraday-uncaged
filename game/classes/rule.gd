extends Reference

class_name Rule

func get_rule_name():
	assert(false, "implement in subclass")

func get_description():
	return ""
	
func check():
	assert(false, "implement in subclass")
	
func check_on_verts(verts):
	assert(false, "implement in subclass")
	
func find_vert(node, verts):
	for vert in verts:
		if vert.associated_node == node:
			return vert
	
	assert(false)


static func run_bfs(from, previous_edge_dict = null):
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
				if previous_edge_dict != null:
					previous_edge_dict
				
	return processed
