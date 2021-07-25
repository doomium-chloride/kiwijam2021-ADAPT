extends KinematicBody2D

const drone_class = preload("res://Enemies/Enemy.tscn")
const is_light = true

const victory = "res://Menu/VictoryMenu.tscn"

export var speed = 1
export var max_hp = 100
var hp = max_hp
var move_dir = Global.random_direction()

# Called when the node enters the scene tree for the first time.
func _ready():
	$BossHp.set_max_adapt(max_hp)
	if move_dir.length_squared() > 0:
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_and_slide(move_dir * speed)


func _on_WalkTimer_timeout():
	move_dir = Global.random_direction()
	if move_dir.length_squared() > 0:
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("idle")

func spawn_drone():
	var drone = drone_class.instance()
	drone.position = get_position()
	get_tree().get_root().add_child(drone)

func _on_SpawnTimer_timeout():
	spawn_drone()

func take_damage(damage):
	hp -= damage
	$BossHp.update_adapt(hp)
	if hp <= 0:
		queue_free()
		Global.goto_scene(victory)
