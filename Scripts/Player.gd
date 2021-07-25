extends KinematicBody2D

const shadow_class = preload("res://Actors/Shadow.tscn")

const gameOver = "res://Menu/GameOverMenu.tscn"

const is_darkness = true
export var shadow_cost = 20
export var adapt_regen = 5
export var speed = 2
export var max_adapt = 100
var adapt = max_adapt

onready var adapt_bar = $AdaptBar
onready var sprite = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	adapt_bar.set_max_adapt(max_adapt)
	sprite.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	regen_adapt(delta)
	update_adapt_bar_state()
	if Input.is_action_just_pressed("ui_select"):
		summon_shadow()
	if Input.is_action_just_pressed("ui_shift"):
		Global.emit_signal("summon_minions", self, "is_darkness")
	if Input.is_action_just_released("ui_shift"):
		Global.emit_signal("release_minions", "is_darkness")
	if Input.is_action_just_pressed("ui_control"):
		multiply_minions()
	if Input.is_action_just_pressed("ui_end"):
		speed *= 2
	# move minions
	if Input.is_action_just_released("wasd_d") or \
	Input.is_action_just_released("wasd_a") or \
	Input.is_action_just_released("wasd_s") or \
	Input.is_action_just_released("wasd_d"):
		Global.emit_signal("move_minions", null, "is_darkness")
	var minion_control_dir = Vector2()
	if Input.is_action_just_pressed("wasd_w"):
		minion_control_dir += Vector2.UP
	if Input.is_action_just_pressed("wasd_a"):
		minion_control_dir += Vector2.LEFT
	if Input.is_action_just_pressed("wasd_s"):
		minion_control_dir += Vector2.DOWN
	if Input.is_action_just_pressed("wasd_d"):
		minion_control_dir += Vector2.RIGHT
	if minion_control_dir != Vector2.ZERO:
		Global.emit_signal("move_minions", minion_control_dir.normalized(), 
		"is_darkness")
	


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
	if move_vec.length() > 0:
		sprite.play("walking")
	else:
		sprite.play("idle")
	


func summon_shadow():
	if not $ShadowCooldown.is_stopped():
		return
	if lose_adapt(shadow_cost):
		return
	var shadow = shadow_class.instance()
	shadow.set_player(self)
	shadow.position = position
	shadow.z_index = z_index - 1
	get_tree().get_root().add_child(shadow)
	$ShadowCooldown.start()
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

func update_adapt_bar_state():
	adapt_bar.invert((not $ShadowCooldown.is_stopped()) or adapt <= shadow_cost)

func take_damage(damage):
	var dead = lose_adapt(damage)
	if dead:
		queue_free()
		Global.goto_scene(gameOver)

func multiply_minions():
	if lose_adapt(max_adapt * 0.99):
		return
	Global.emit_signal("multiply_minions", "is_darkness")
