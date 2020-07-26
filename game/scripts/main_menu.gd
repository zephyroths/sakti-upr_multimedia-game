extends Node

onready var game_saver = $"save_game"

func _ready():
	$tween.interpolate_property($main_menu_tap, "visible", true, false, 1.0, Tween.TRANS_LINEAR)
	$tween.start()

func _input(event):
	if event is InputEventScreenTouch:
		game_saver.load(1)
		get_tree().change_scene("res://locations/town.tscn")
