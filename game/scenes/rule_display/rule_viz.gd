extends Control

class_name RuleViz

var rule

func create_from(rule):
	self.rule = rule
	match rule.get_rule_name():
		"ConnectedRule", "NotConnectedRule":
			$Left.modulate = rule.get_color_a()
			$Right.modulate = rule.get_color_b()
			$Operator.texture = rule.get_operator_texture()
			$Operator.modulate = rule.get_operator_color()
		_:
			assert(false, "unknown rule")

func highlight(val):
	$ColorRect.color = Color("#1d8484") if val else Color("#424a4a")
