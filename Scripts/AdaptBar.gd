extends Control


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
