extends Node

var town_path: String = "res://locations/town.tscn"
var dungeon_normal_path: String = "res://locations/dungeon_normal.tscn"
var dungeon_water_path: String
var dungeon_earth_path: String
var dungeon_fire_path: String
var dungeon_wind_path: String
var dungeon_final_path: String

var final: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	final = final_check()
	if not final:
		$dungeon_final/button.disabled = true
	
	if player.orb_normal:
		$crista/normal.visible = true
	if player.orb_fire:
		$crista/fire.visible = true
	if player.orb_water:
		$crista/water.visible = true
	if player.orb_earth:
		$crista/earth.visible = true
	if player.orb_wind:
		$crista/wind.visible = true

func move_town():
	move(town_path)

func move_dungeon_normal():
	move(dungeon_normal_path)

func move_dungeon_water():
	move(dungeon_water_path)
	
func move_dungeon_fire():
	move(dungeon_fire_path)

func move_dungeon_wind():
	move(dungeon_fire_path)

func move_dungeon_earth():
	move(dungeon_earth_path)

func move_dungeon_final():
	print("You can't get in yet'")

func final_check():
	return player.orb_normal and player.orb_fire and player.orb_water and player.orb_earth and player.orb_wind

func move(location):
	var error = get_tree().change_scene(location)
	
	# Handling Errors
	if error != OK:
		if not has_node("warning"):
			var message = load("res://ui/ui_warning.tscn")
			add_child(message.instance())
		get_node("warning").visible = true
		
		match error:
			ERR_CANT_OPEN:
				get_node("warning/message").text = "Can't find the map"
			ERR_CANT_CREATE:
				get_node("warning/message").text = "Can't enter the map"
