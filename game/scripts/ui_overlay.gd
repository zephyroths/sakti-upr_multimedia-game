extends Control

func _ready():
	pass # Replace with function body.

func fade_out():
	$fade_color.visible = true
	$tween.interpolate_property($fade_color, "color", Color(0,0,0,0), Color(0,0,0,1), 0.7, Tween.TRANS_LINEAR)
	$tween.start()
