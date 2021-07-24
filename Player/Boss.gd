extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
var velocity = Vector2.ZERO
var move_dir = Global.random_direction()

var enemy_class = load("res://Enemies/Enemy.tscn")
const bullet_class = preload("res://Actors/Bullet.tscn")

var is_darkness = false
var is_light = true

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var adapted = false
var targets = []

export var max_hp = 10
var hp = max_hp

func _physics_process(delta):
#	var input_vector = Vector2.ZERO
#	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
#	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	input_vector = input_vector.normalized() 

	if is_chasing():
		move_dir = get_chase_dir()
		
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
		pass

func spawn_enemy():
	var enemy = enemy_class.instance()
	enemy.position = get_position()
	get_tree().get_root().add_child(enemy)

func _on_Timer_timeout():
	spawn_enemy()


func _on_WalkTimer_timeout():
	if not is_chasing():
		move_dir = Global.random_direction()


func _on_Sight_body_entered(body):
	if adapted:
		if body.get("is_light") == true:
			targets.append(body)
			pass
	else:
		if body.get("is_darkness") == true:
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

func get_chase_dir():
	if targets == null:
		return
	var target_pos = targets[0].position as Vector2
	var direction = target_pos - get_position()
	return direction.normalized()

func damage_adapt(dmg):
	adapted = true
	is_darkness = adapted
	is_light = not adapted
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

func take_damage(damage):
	hp -= damage
	if hp <=  0:
		queue_free()
