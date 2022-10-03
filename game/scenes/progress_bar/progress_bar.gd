extends Node2D

var value setget set_value

func set_value(v):
	value = v
	$LightningViewport/ProgressBar.value = value
