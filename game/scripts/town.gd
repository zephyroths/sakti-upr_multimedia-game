extends Node

var map_path = "res://locations/world_map.tscn"

onready var game_saver = $"save_game"

onready var weapon_upgrade = $"ui_upgrade/ui_upgrade_weapon"
onready var armor_upgrade = $"ui_upgrade/ui_upgrade_armor"
onready var potion_upgrade = $"ui_upgrade/ui_upgrade_potion"

func _ready():
	update_gold(player.gold)
	update_weapon_price(player.weapon_price)
	update_armor_price(player.armor_price)
	update_potion_price(player.potion_price)

func update_gold(value):
	$"ui_gold/text_gold".set_text(str(value))

func update_weapon_price(value):
	weapon_upgrade.get_node("texture_price/text_price").set_text(str(value))

func update_armor_price(value):
	armor_upgrade.get_node("texture_price/text_price").set_text(str(value))

func update_potion_price(value):
	potion_upgrade.get_node("texture_price/text_price").set_text(str(value))

func _upgrade_weapon():
	if player.gold >= player.weapon_price:
		player.gold -= player.weapon_price
		player.attack_power += 5
		player.weapon_price += 5
		weapon_upgrade.get_node("icon_upgrade").play("play")
		$"audio/audio_buy".play()
		update_gold(player.gold)
		update_weapon_price(player.weapon_price)
		yield(weapon_upgrade.get_node("icon_upgrade"), "animation_finished")
		weapon_upgrade.get_node("icon_upgrade").set_animation("default")
	else:
		$"audio/audio_buy_failed".play()

func _upgrade_armor():
	if player.gold >= player.armor_price:
		player.gold -= player.armor_price
		player.health += 5
		player.armor_price += 5
		armor_upgrade.get_node("icon_upgrade").play("play")
		$"audio/audio_buy".play()
		update_gold(player.gold)
		update_armor_price(player.armor_price)
		yield(armor_upgrade.get_node("icon_upgrade"), "animation_finished")
		armor_upgrade.get_node("icon_upgrade").set_animation("default")
	else:
		$"audio/audio_buy_failed".play()

func _upgrade_potion():
	if player.gold >= player.potion_price:
		player.gold -= player.potion_price
		player.potion_power += 5
		player.potion_price += 5
		potion_upgrade.get_node("icon_upgrade").play("play")
		$"audio/audio_buy".play()
		update_gold(player.gold)
		update_potion_price(player.potion_price)
		yield(potion_upgrade.get_node("icon_upgrade"), "animation_finished")
		potion_upgrade.get_node("icon_upgrade").set_animation("default")
	else:
		$"audio/audio_buy_failed".play()

func _exit_game():
	# Save and then close the game.
	game_saver.save(1)
	get_tree().quit()

func _go_outside():
	$overlay.fade_out()
	yield($overlay/tween, "tween_completed")
	get_tree().change_scene(map_path)

func _mouse_hover():
	$button_world/sprite.play()

func _mouse_exit():
	$button_world/sprite.stop()
	$button_world/sprite.frame = 0
