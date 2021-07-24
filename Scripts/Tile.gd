extends Area2D

const normal_texture = preload("res://World/GrassBackground.png")
const invert_texture = preload("res://Assets/Tile/DarkGrassBackground.png")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var inverted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if inverted:
		$Sprite.texture = invert_texture
	else:
		$Sprite.texture = normal_texture
	pass # Replace with function body.

func darken():
	$Sprite.texture = invert_texture

