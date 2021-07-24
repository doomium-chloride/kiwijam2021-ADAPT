extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
var velocity = Vector2.ZERO

var enemy_class = load("res://Enemies/Enemy.tscn")
onready var spawn_pos = get_position() + Vector2(0,-100)


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() 
		
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("FlyRight")
		else:
			animationPlayer.play("FlyLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = Vector2.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide(velocity);

func _process(delta):
	if Input.is_action_just_pressed("ui_home"):
		spawn_enemy()
		pass

func spawn_enemy():
	var enemy = enemy_class.instance()
	enemy.position = spawn_pos
	add_child(enemy)

func _on_Timer_timeout():
	spawn_enemy()
