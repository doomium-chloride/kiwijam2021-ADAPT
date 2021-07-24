extends Control

const normal_texture = preload("res://Assets/HealthBar/border.png")
const invert_texture = preload("res://Assets/HealthBar/border-invert.png")

onready var bar = $TextureProgress
export var max_adapt = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	bar.max_value = max_adapt


func update_adapt(adapt):
	bar.value = adapt

func set_max_adapt(adapt):
	max_adapt = adapt
	bar.max_value = max_adapt

func invert(value):
	if value:
		bar.texture_over = invert_texture
	else:
		bar.texture_over = normal_texture
