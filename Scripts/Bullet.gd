extends Area2D


const white_texture = preload("res://Assets/Bullet/whitebullet.png")
const black_texture = preload("res://Assets/Bullet/blackbullet.png")

export var adapted = false
export var damage = 10
export var speed = 100
var direction = Vector2.ZERO

func _process(delta):
	if not Global.is_connected("free_self", self, "_free_self"):
		Global.connect("free_self", self, "_free_self")
	if not $VisibilityNotifier2D.is_on_screen():
		queue_free()

func _physics_process(delta):
	translate(direction * speed * delta)

func set_adapted(dark):
	adapted = dark
	if dark:
		$Sprite.texture = black_texture
	else:
		$Sprite.texture = white_texture


func _on_Bullet_body_entered(body):
	if adapted:
		if body.get("is_light") == true:
			if body.has_method("take_damage"):
				body.take_damage(damage)
				queue_free()
	else:
		if body.get("is_darkness") == true:
			if body.has_method("take_damage"):
				body.take_damage(damage)
				queue_free()
func _free_self():
	queue_free()
