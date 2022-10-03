extends Node

const difficulty_factor = 1#0

var score = 0

signal score_update

func increase_score(difficulty):
	var incr = pow(2, difficulty) * difficulty_factor
	score += incr
	emit_signal("score_update")
	return incr

func reset_score():
	score = 0
	emit_signal("score_update")
	
