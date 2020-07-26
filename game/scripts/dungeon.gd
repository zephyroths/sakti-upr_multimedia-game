extends Node

onready var btn_run = $button_run
onready var btn_attack = $ui_player/sprite/btn_attack
onready var btn_guard = $ui_player/button_guard
onready var btn_pot = $ui_player/button_potion
onready var btn_boss = $button_boss

onready var mc = $ui_player/sprite
onready var text_gold = $ui_gold/text_gold
onready var text_stats = $stats/text_stats

onready var hp_bar = $ui_player/hp_bar/hp
onready var hp_bar_anim = $ui_player/hp_bar/tween

var town: String = "res://locations/town.tscn"
var escape_counter: int = 0

const ESCAPE_TRESHOLD = 60

export (String) var dungeon_id
export (PackedScene) onready var boss
export (Array, PackedScene) onready var enemies
export (int) var boss_treshold = 10

var cur_gold: int = player.gold
var cur_hp: int = player.health
var atk_pwr: int = player.attack_power
var pot_pwr: int = player.potion_power
var pot_amt: int = player.max_potion
var attacking: bool = false

var boss_counter: int
var boss_time: bool = false
var anim: String = "idle"

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_bar.max_value = cur_hp
	hp_bar.value = cur_hp
	update_stats(atk_pwr)
	update_gold(cur_gold)
	boss_counter = 0
	
	# Needs a better code to check if the boss in certain area is defeated.
	if has_orb():
		btn_boss.visible = false

# Can possibly be improved on.
func _process(_delta):
	# Adds enemy if none exists
	if not has_node("enemy"):
		var enemy = boss if boss_time else enemies[randi() % enemies.size()]
		update_enemy(enemy)
		if not has_orb():
			if boss_counter > boss_treshold:
				btn_boss.disabled = false
	
	# Used for escaping the dungeon
	# Can use some improvement by using time instead of counter
	if btn_run.is_pressed():
		escape_counter += 1
		if escape_counter >= ESCAPE_TRESHOLD:
			exit_dungeon()
	
	# Player Actions
	if not attacking:
		if btn_guard.is_pressed():
			anim = "guard"
			btn_attack.disabled = true
			
			mc.play(anim)
			mc.frame = 0
			yield(mc, "animation_finished")
			
			btn_attack.disabled = false
		elif btn_attack.is_pressed():
			attacking = true
			anim = "attack"
			btn_guard.disabled = true
			
			mc.play(anim)
			mc.frame = 0
			yield(mc, "animation_finished")
			attack()
			
			get_node("enemy").add_child(player.attack_animation.instance())
			get_node("enemy/attack_animation").play()
			yield(get_node("enemy/attack_animation"), "animation_finished")
			get_node("enemy/attack_animation").queue_free()
			
			attacking = false
			btn_guard.disabled = false
		else:
			anim = "idle"
			mc.play(anim)

# Resets escape_counter if running button isn't pressed anymore
func _escape_cancel():
	escape_counter = 0

# Mechanism to update HP.
func update_hp(val):
	hp_bar_anim.interpolate_property(hp_bar, "value", cur_hp, val, 1.0, Tween.TRANS_LINEAR)
	hp_bar_anim.start()
	yield(hp_bar_anim, "tween_completed")
	cur_hp = hp_bar.value
	
	if cur_hp < 1:
		cur_gold -= (cur_gold / 4)
		exit_dungeon()

# Displaying Attack Power.
func update_stats(value):
	text_stats.text = str(value)

# Mechanism for getting golds.
func update_gold(value):
	cur_gold = value
	text_gold.text = str(value)

# Add enemy to the screen.
func update_enemy(enemy):
	var new_enemy = enemy.instance()
	add_child(new_enemy)
	target = get_node("enemy")

# Mechanism for using potion
func update_potion():
	if pot_amt > 0:
		pot_amt -= 1
		update_hp(cur_hp + pot_pwr)
		
		if pot_amt == 0:
			btn_pot.disabled = true

# Mechanism for attacking.
func attack():
	if target.hp > 0:
		target.hp -= atk_pwr

		if target.hp < 1:
			btn_attack.disabled = true
			update_gold(cur_gold + target.drop)
			target.audio_dead.play()
			target.animation.play("dead")
			
			if is_in_group("boss"):
				match target.id:
					"slime_queen":
						player.orb_normal = true
					"dragon":
						pass
					"":
						pass
					"titan":
						pass
					"":
						pass
					"demon_king":
						pass
			
			yield(target.animation, "animation_finished")
			target.queue_free()
			btn_attack.disabled = false

# Check if you have the orb for specific dungeon.
# The code might be able to be improved.
func has_orb():
	match dungeon_id:
		"normal":
			return player.orb_normal
		"fire":
			return player.orb_fire
		"water":
			return player.orb_water
		"earth":
			return player.orb_earth
		"wind":
			return player.orb_wind

# Call the dungeon boss.
func call_boss():
	boss_time = true
	get_node("enemy").queue_free()

# Exit Dungeon
func exit_dungeon():
	player.gold = cur_gold
	$overlay.fade_out()
	yield($overlay/tween, "tween_completed")
	get_tree().change_scene(town)
