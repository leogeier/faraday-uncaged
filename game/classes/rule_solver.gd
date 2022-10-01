extends Reference

class_name RuleSolver

class Vert:
	var connections
	var connection_limit
	var associated_node
	
	func get_neighbors():
		return connections
	
	func _init(connections, connection_limit, associated_node):
		self.connections = connections
		self.connection_limit = connection_limit
		self.associated_node = associated_node
		
class Edge:
	var a
	var b
	
	func _init(a, b):
		self.a = a
		self.b = b
		

func generate_ruleset(devices, hubs, cables, difficulty, dont_connect_limit):
	var possible_rules = []
	var possible_connect_rules = []
	for i in range(devices.size()):
		for j in range(i + 1, devices.size()):
			var device_a
			var device_b
			
			if randi() % 2 == 0:
				device_a = devices[i]
				device_b = devices[j]
			else:
				device_a = devices[j]
				device_b = devices[i]
				
			var connected_rule = ConnectedRule.new(device_a, device_b)
			var not_connected_rule = NotConnectedRule.new(device_a, device_b)
				
			possible_connect_rules.push_back(connected_rule)
			possible_rules.push_back(connected_rule)
			possible_rules.push_back(not_connected_rule)
	
	possible_connect_rules.shuffle()
	possible_rules.shuffle()
	
	
	var ruleset = []
	
	for rule in possible_connect_rules:
		var candidate = ruleset.duplicate()
		candidate.push_back(rule)
		
		var solutions = solve(devices, hubs, cables, candidate)
		
		if solutions.size() > 0:
			ruleset.push_back(rule)
			possible_rules.erase(rule)
			
		if ruleset.size() == dont_connect_limit:
			break
	
	for rule in possible_rules:
		var candidate = ruleset.duplicate()
		candidate.push_back(rule)
		
		var solutions = solve(devices, hubs, cables, candidate)
		
		if solutions.size() > 0:
			ruleset.push_back(rule)
			
		if ruleset.size() == difficulty:
			for connection in solutions[0]:
				print(
					connection.a.associated_node.get_display_name()
					+ "|" + connection.b.associated_node.get_display_name()
				)
			break
	
	return ruleset

	
func rule_taken(device_a, device_b, ruleset):
	for rule in ruleset:
		if rule.portA == device_a and rule.portB == device_b:
			return true
		
		if rule.portA == device_b and rule.portB == device_a:
			return true
			
	return false

func solve(devices, hubs, cables, rules):
	var verts = []
	var vert_rules = []
	
	for device in devices:
		verts.push_back(Vert.new([], 1, device))
		
	for hub in hubs:
		verts.push_back(Vert.new([], hub.get_port_count(), hub))
		
	var valid_configs = get_valid_configs(verts, [], cables.size(), rules)
	
	return valid_configs
	
func get_valid_configs(verts, current_connections, remaining_connections, rules):
	if remaining_connections == 0:
		return []
		
	var valid_configs = []
		
	for i in range(verts.size()):
		var vert_a = verts[i]
		
		if vert_a.connections.size() == vert_a.connection_limit:
			continue
			
		for j in range(verts.size()):
			if i == j:
				continue
				
			var vert_b = verts[j]
			
			if vert_b.connections.size() == vert_b.connection_limit:
				continue
				
			var new_verts = verts.duplicate()
			var new_vert_a = Vert.new(vert_a.connections.duplicate(), vert_a.connection_limit, vert_a.associated_node)
			var new_vert_b = Vert.new(vert_b.connections.duplicate(), vert_b.connection_limit, vert_b.associated_node)
			
			new_vert_a.connections.push_back(new_vert_b)
			new_vert_b.connections.push_back(new_vert_a)
			
			new_verts[i] = new_vert_a
			new_verts[j] = new_vert_b
			
			var new_current_connections = current_connections.duplicate()
			new_current_connections.push_back(Edge.new(new_vert_a, new_vert_b))
			
			if check_rules(new_verts, rules):
				valid_configs.push_back(new_current_connections)
				
			valid_configs.append_array(get_valid_configs(new_verts, new_current_connections, remaining_connections - 1, rules))
	
	return valid_configs
	
			
func check_rules(verts, rules):
	for rule in rules:
		if not rule.check_on_verts(verts):
			return false
			
	return true
