extends Button

onready var monologue = owner
export var code = "next"

const learn = "res://Menu/Learn.tscn"

func _ready():
	connect("pressed", self, "_on_button_press")


func _on_button_press():
	Global.goto_scene(learn)
