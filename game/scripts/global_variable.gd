extends Node


var health = 10
var attack_power = 1
var potion_power = 2

var max_potion = 3
var gold = 0

var weapon_price = 10
var armor_price = 10
var potion_price = 10

var orb_normal
var orb_fire
var orb_water
var orb_earth
var orb_wind

onready var attack_animation = preload("res://system/attack/attack_animation.tscn")
onready var SAVE_KEY = name

func _ready():
	add_to_group("save")

func save(save_game: Resource):
	save_game.data[SAVE_KEY] = {
		"gold": gold,
		"health": health,
		"attack_power": attack_power,
		"potion_power": potion_power,
		"weapon_price": weapon_price,
		"armor_price": armor_price,
		"potion_price": potion_price,
		"orb_normal": orb_normal,
		"orb_fire": orb_fire,
		"orb_water": orb_water,
		"orb_earth": orb_earth,
		"orb_wind": orb_wind
	}

func load(save_game: Resource):
	var data : Dictionary = save_game.data[SAVE_KEY]
	gold = data["gold"]
	health = data["health"]
	attack_power = data["attack_power"]
	potion_power = data["potion_power"]
	weapon_price = data["weapon_price"]
	armor_price = data["armor_price"]
	potion_price = data["potion_price"]
	orb_normal = data["orb_normal"]
	orb_fire = data["orb_fire"]
	orb_water = data["orb_water"]
	orb_earth = data["orb_earth"]
	orb_wind = data["orb_wind"]
