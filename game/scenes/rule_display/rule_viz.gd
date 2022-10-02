extends Control

class_name RuleViz

func create_from(rule):
	match rule.get_rule_name():
		"ConnectedRule", "NotConnectedRule":
			$Left.modulate = rule.get_color_a()
			$Right.modulate = rule.get_color_b()
			$Operator.texture = rule.get_operator_texture()
			$Operator.modulate = rule.get_operator_color()
		_:
			assert(false, "unknown rule")
