extends Area2D

export(String) var id = ""
export(int) var hp = 5
export(int) var drop = 10
export(int) var attack_power = 5
export(int) var attack_speed = 3
export(int) var action_point = 1000

export(Array, String) var actions = []
var current_ap = 0

onready var animation = $sprite
onready var audio_hit = $audio/hit
onready var audio_dead = $audio/dead

func _ready():
	var x = get_viewport().size.x / 2
	var y = get_viewport().size.y / 2
	set_position(Vector2(x, y))
	
func _process(_delta):
	if hp > 0:
		current_ap += attack_speed
	
	if current_ap >= action_point:
		action()
		current_ap = 0

func action():
	var act = actions[randi() % actions.size()]
	$sprite.play(act)
	yield($sprite, "animation_finished")

func animation_finished():
	if not (($sprite.animation == "idle") or ($sprite.animation == "dead")):
		$audio/hit.play()
		var damage = int(attack_power/2) if get_parent().btn_guard.is_pressed() else attack_power
		get_parent().update_hp(get_parent().cur_hp - damage)
		$sprite.play("idle")

# A Constructor, using tree_entered() signal
func added():
	if not is_in_group("boss"):
		get_parent().boss_counter += 1
	else:
		get_parent().btn_boss.visible = false

# A Destructor, using tree_exiting() signal
# A better code is appreciated
func removed():
	if is_in_group("boss") and hp < 1:
		match id:
			"slime_queen":
				player.orb_normal = true
			"dragon":
				player.orb_fire = true
			"water_boss":
				player.orb_water = true
			"titan":
				player.orb_earth = true
			"wind_boss":
				player.orb_wind = true
			"demon_king":
				pass
		get_parent().boss_time = false
