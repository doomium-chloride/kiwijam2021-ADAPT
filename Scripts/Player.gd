extends KinematicBody2D

const shadow_class = preload("res://Actors/Shadow.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	var shadow = shadow_class.instance()
	shadow.set_player(self)
	shadow.position = position
	shadow.z_index = z_index - 1
	get_tree().get_root().add_child(shadow)
