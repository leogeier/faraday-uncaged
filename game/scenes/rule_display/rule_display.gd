extends Node2D


func update_rules(new_rules):
	for child in $RuleVizContainer.get_children():
		remove_child(child)
		child.queue_free()
	for rule in new_rules:
		var viz = preload("res://scenes/rule_display/rule_viz.tscn").instance()
		viz.create_from(rule)
		$RuleVizContainer.add_child(viz)

func set_progress(value):
	$ProgressBar.value = value * 100
	$Label.text = "%05.2f" % (10 - floor(value * 1000) / 100)

func highlight(rule, val):
	for child in $RuleVizContainer.get_children():
		if child.rule == rule:
			child.highlight(val)
