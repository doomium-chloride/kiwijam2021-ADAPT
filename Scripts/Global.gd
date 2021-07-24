extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gravity = 100

var bullet_speed = 1000

var bullet_damage = 1

var base_bullet_spread = PI / 100

var trident_dmg = 1

const main_menu = "res://Scenes/Menus/Home.tscn"

const left_dir = Vector2(-1, 0)
const right_dir = Vector2(1, 0)

signal update_hp(hp)
signal set_max_hp(hp)

signal update_ammo(ammo)
signal set_max_ammo(ammo)
signal set_ammo_spacing(spacing)

var drop_chance = 0.2

var current_scene = null

const low_ammo = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func wobble(t, freq):
	return sin(t * freq) * PI / 32

func flip_coin():
	var coin = randi() % 2
	return coin == 0

func chance(proc_chance):
	if proc_chance >= 1:
		return true
	return randf() < proc_chance

func bullet_spread(left):
	var angle = randf() * base_bullet_spread
	var dir = -1 if left else 1
	var up = -1 if flip_coin() else 1
	return Vector2(dir * cos(angle) * bullet_speed, up * sin(angle) * bullet_speed)

func random_direction():
	var x = (randi() % 3) - 1
	var y = (randi() % 3) - 1
	var vector = Vector2(x, y)
	return vector.normalized()

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# Clear and reset some stuff

	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func scale2(scale):
	return Vector2(scale, scale)
