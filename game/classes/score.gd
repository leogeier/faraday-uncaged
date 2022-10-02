extends Node

const difficulty_factor = 10

var score = 0

func increase_score(difficulty):
	var incr = difficulty * difficulty_factor
	score += incr
	return incr

func reset_score():
	score = 0
