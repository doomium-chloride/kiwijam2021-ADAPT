extends Button

const back = "res://Menu/HomeMenu.tscn"

export var code = "next"


func _ready():
	connect("pressed", self, "_on_button_press")


func _on_button_press():
	Global.goto_scene(back)
