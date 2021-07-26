extends Button

const play = "res://Levels/BossLevel.tscn"

export var code = "next"

func _ready():
	connect("pressed", self, "_on_button_press")

func _on_button_press():
	Global.goto_scene(play)
