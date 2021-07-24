extends KinematicBody2D

const shadow_class = preload("res://Actors/Shadow.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var shadow_cooldown = 1
export var shadow_cost = 20
export var adapt_regen = 5
export var speed = 2
export var max_adapt = 100
var adapt = max_adapt

var shadow_cooling_down = false
var shadow_cooldown_timer = 0

onready var adapt_bar = $AdaptBar


# Called when the node enters the scene tree for the first time.
func _ready():
	adapt_bar.set_max_adapt(max_adapt)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cool_down_shadow(delta)
	regen_adapt(delta)
	update_adapt_bar_state()
	if Input.is_action_just_pressed("ui_select"):
		summon_shadow()
		pass
	pass


func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1
	if Input.is_action_pressed("ui_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_vec.y += 1
	move_and_collide(move_vec.normalized() * speed)

func summon_shadow():
	if shadow_cooling_down:
		return
	if lose_adapt(shadow_cost):
		return
	var shadow = shadow_class.instance()
	shadow.set_player(self)
	shadow.position = position
	shadow.z_index = z_index - 1
	get_tree().get_root().add_child(shadow)
	shadow_cooling_down = true
	update_adapt_bar_state()

func lose_adapt(value):
	var newValue = adapt - value
	if newValue < 0:
		return true
	else:
		update_adapt(newValue)
		return false

func update_adapt(new):
	new = min(max_adapt, new)
	adapt = new
	adapt_bar.update_adapt(new)

func regen_adapt(delta):
	update_adapt(adapt + adapt_regen * delta)

func cool_down_shadow(delta):
	if not shadow_cooling_down:
		shadow_cooldown_timer = 0
		return
	if shadow_cooldown_timer >= shadow_cooldown:
		shadow_cooling_down = false
		return
	shadow_cooldown_timer += delta

func update_adapt_bar_state():
	adapt_bar.invert(shadow_cooling_down or adapt <= shadow_cost)
