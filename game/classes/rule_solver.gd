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
		
	func copy():
		return Vert.new(connections.duplicate(), connection_limit, associated_node)
		
class Edge:
	var a
	var b
	
	func _init(a, b):
		self.a = a
		self.b = b
		
# TODO: dont generate rules twice
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
		if ruleset.size() >= dont_connect_limit:
			break
			
		var candidate = ruleset.duplicate()
		candidate.push_back(rule)
		
		if solve(devices, hubs, cables, candidate):
			ruleset.push_back(rule)
			possible_rules.erase(rule)
			
	
	for rule in possible_rules:
		if ruleset.size() >= difficulty:
			break
			
		var candidate = ruleset.duplicate()
		candidate.push_back(rule)
		
		if solve(devices, hubs, cables, candidate):
			ruleset.push_back(rule)
	
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
		
	var valid_configs = get_valid_configs(verts, cables.size(), rules)
	
	for config in valid_configs:
		if solve_spacially(config, cables):
			return true
	
	return false
	
func solve_spacially(config, cables):
	var remaining_connections = config.duplicate()
	var remaining_cables = cables.duplicate()
	
	if not filter_direct_connections(remaining_connections, remaining_cables):
		return false
		
	return true
	
class CableSorter:
	func compare(q1, q2):
		return q1.cable_length < q2.cable_length

func filter_direct_connections(connections, cables):
	var connections_copy = connections.duplicate()
	cables.sort_custom(CableSorter.new(), "compare")
	
	for connection in connections_copy:
		var pos_a = connection.a.associated_node.global_position
		var pos_b = connection.b.associated_node.global_position
		
		var length = pos_a.distance_to(pos_b)
		
		var matching_cable = null
		for cable in cables:
			if cable.cable_length >= length:
				matching_cable = cable
				break
		
		if matching_cable == null:
			return false
			
		cables.erase(matching_cable)
		connections.erase(connection)
		
	return true
	
	
class BeamSearchQuery:
	var verts
	var current_connections
	var score
	
	func _init(verts, current_connections, score):
		self.verts = verts
		self.current_connections = current_connections
		self.score = score
		
class QuerySorter:
	func compare(q1, q2):
		return q1.score < q2.score

func get_valid_configs(verts, remaining_connections, rules):
	var valid_configs = []
	var beam_width = 1
	
	var states_explored = 0
	
	var next_queries = [BeamSearchQuery.new(verts, [], 0)]
	
	for depth in range(remaining_connections):
		var current_queries = next_queries.duplicate()
		current_queries.sort_custom(QuerySorter.new(), "compare")
		current_queries = current_queries.slice(0, beam_width)
		next_queries = []
		
		for q in current_queries:
			if q.score > rules.size():
				break
				
			for i in range(q.verts.size()):
				var vert_a = q.verts[i]
				
				if vert_a.connections.size() == vert_a.connection_limit:
					continue
					
				for j in range(i+1, q.verts.size()):
						
					var vert_b = q.verts[j]
					
					if vert_b.connections.size() == vert_b.connection_limit:
						continue
						
					var new_verts = q.verts.duplicate()
					var new_vert_a = vert_a.copy()
					var new_vert_b = vert_b.copy()
					
					new_vert_a.connections.push_back(new_vert_b)
					new_vert_b.connections.push_back(new_vert_a)
					
					new_verts[i] = new_vert_a
					new_verts[j] = new_vert_b
					
					var new_current_connections = q.current_connections.duplicate()
					new_current_connections.push_back(Edge.new(new_vert_a, new_vert_b))
					
					var score = score_rules(new_verts, rules)
					
					if score == 0:
						valid_configs.push_back(new_current_connections)
					else:
						var p1 = two_connector_penalty(new_current_connections)
						var r1 = good_hub_reward(rules, new_verts)
							
						next_queries.push_back(BeamSearchQuery.new(new_verts, new_current_connections, score + p1 - r1))
						
					states_explored += 1
	
		print(states_explored)
					
	return valid_configs


func reconstruct_verts(old_verts):
	var new_verts = {}
	
	for old_v in old_verts:
		new_verts[old_v.associated_node] = old_v.copy()
		
	for vert in new_verts.values():
		var connections = []
		
		for old_connection in vert.connections:
			connections.push_back(new_verts[old_connection.associated_node])
			
		vert.connections = connections
		
	return new_verts
		

func check_rules(verts, rules):
	var fixed_verts = reconstruct_verts(verts)
	for rule in rules:
		if not rule.check_on_verts(fixed_verts):
			return false
			
	return true

func score_rules(verts, rules):
	var fixed_verts = reconstruct_verts(verts)
	var score = 0
	
	for rule in rules:
		if not rule.check_on_verts(fixed_verts):
			score += rule.get_penalty()
				
	return score
	
func two_connector_penalty(edges):
	var penalty = 0
	for edge in edges:
		if edge.a.associated_node.is_in_group("device") and edge.a.associated_node.is_in_group("device"):
			penalty += 2
			
	return penalty
	
func good_hub_reward(rules, verts):
	var reward = 0
	var verts_dict = {}
	for vert in verts:
		verts_dict[vert.associated_node] = vert
	
	for rule in rules:
		if not verts_dict[rule.portA].connections.empty():
			if not verts_dict[rule.portA].connections[0].associated_node.is_in_group("device"):
				reward += 5
			
		if not verts_dict[rule.portB].connections.empty():
			if not verts_dict[rule.portB].connections[0].associated_node.is_in_group("device"):
				reward += 5
#
#	for vert in verts:
#		if not vert.associated_node.is_in_group("device"):
#			for neighbor in vert.connections:
#				if not neighbor.associated_node.is_in_group("device"):
#					reward += 1.5
			
	return reward
