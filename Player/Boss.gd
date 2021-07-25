extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
var velocity = Vector2.ZERO
var move_dir = Global.random_direction()

var enemy_class = load("res://Enemies/Enemy.tscn")
const bullet_class = preload("res://Actors/Bullet.tscn")
const dark_texture = preload("res://Assets/Drone/BlackDrone.png")

var is_darkness = false
var is_light = true

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var convertedSFX = $ConvertedSFX

var adapted = false
var targets = []
var far_target = null
var command_dir = null

export var max_hp = 10
var hp = max_hp

func _ready():
	Global.connect("summon_minions", self, "_on_summon_minion")
	Global.connect("release_minions", self, "_on_release_minion")
	Global.connect("multiply_minions", self, "_on_multiply_minion")
	Global.connect("move_minions", self, "_on_move_minion")
	Global.connect("free_self", self, "_free_self")

func _physics_process(delta):
	if is_chasing():
		move_dir = get_chase_dir()
	elif far_target != null:
		move_dir = get_dir_from_self(far_target.position)
	elif command_dir != null:
		move_dir = command_dir
		
	if move_dir != Vector2.ZERO:
		if move_dir.x > 0:
			animationPlayer.play("FlyRight")
		else:
			animationPlayer.play("FlyLeft")
		velocity = velocity.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = Vector2.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide(velocity);

func _process(delta):
	shoot()
	if Input.is_action_just_pressed("ui_home"):
		spawn_enemy()
	if Input.is_action_just_pressed("cheat"):
		to_darkness()

func spawn_enemy():
	var enemy = enemy_class.instance()
	enemy.position = get_position()
	get_tree().get_root().add_child(enemy)

func _on_WalkTimer_timeout():
	if not is_chasing() and command_dir == null:
		move_dir = Global.random_direction()


func _on_Sight_body_entered(body):
	if adapted:
		if body.get("is_light") == true:
			if not targets.has(body):
				targets.append(body)
			pass
	else:
		if body.get("is_darkness") == true:
			if not targets.has(body):
				targets.append(body)
			pass

func _on_Sight_body_exited(body):
	if adapted:
		if body.get("is_light") == true:
			if targets.has(body):
				targets.erase(body)
			pass
	else:
		if body.get("is_darkness") == true:
			if targets.has(body):
				targets.erase(body)
			pass

func is_chasing():
	return not targets.empty()

func get_dir_from_self(pos):
	var direction = pos - get_position()
	return direction.normalized()
	
func check_target_is_valid(target):
	if adapted:
		return target.get("is_light") == true
	else:
		return target.get("is_darkness") == true

func get_chase_dir():
	if not is_chasing():
		return
	var target = targets[0]
	if check_target_is_valid(target):
		var target_pos = target.position as Vector2
		return get_dir_from_self(target_pos)
	else:
		targets.remove(0)
		return move_dir

func damage_adapt(dmg):
	if adapted:
		return
	to_darkness()
	convertedSFX.play()
	$ShootCooldown.stop()
	var to_erase = []
	for target in targets:
		if target.get("is_darkness") == true:
			to_erase.append(target)
	for target in to_erase:
		targets.erase(target)

func shoot():
	if not $ShootCooldown.is_stopped():
		return
	if not is_chasing():
		return
	$ShootCooldown.start()
	var bullet = bullet_class.instance()
	bullet.position = get_position()
	bullet.set_adapted(adapted)
	bullet.direction = move_dir
	get_tree().get_root().add_child(bullet)

func to_darkness():
	adapted = true
	is_darkness = true
	is_light = false
	$Sprite.texture = dark_texture

func take_damage(damage):
	hp -= damage
	if hp <=  0:
		queue_free()

func _on_summon_minion(obj, tag):
	if self.get(tag) == true:
		far_target = obj

func _on_release_minion(tag):
	if self.get(tag) == true:
		far_target = null

func _on_multiply_minion(tag):
	if self.get(tag) == true:
		if tag == "is_darkness":
			var enemy = enemy_class.instance()
			enemy.position = get_position()
			enemy.to_darkness()
			get_tree().get_root().add_child(enemy)

func _on_move_minion(direction, tag):
	if self.get(tag) == true:
		command_dir = direction

func _free_self():
	queue_free()
