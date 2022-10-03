extends Label

func _ready():
	Score.connect("score_update", self, "on_score_update")

func on_score_update():
	text = str(Score.score)
