extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var growth_speed = 15;
export var max_size = 10

var player = null

func set_player(obj):
	player = obj

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		position = player.position
	if(scale.x >= max_size):
		queue_free()
	else:
		print(scale)
		scale += Vector2(growth_speed, growth_speed) * delta
	pass


func _on_Shadow_area_entered(area):
	if area.has_method("darken"):
		area.darken()
	pass # Replace with function body.
