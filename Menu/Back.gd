extends Button

onready var monologue = owner
export var code = "next"


func _ready():
	connect("pressed", self, "_on_button_press")


func _on_button_press():
	monologue.emit_signal(code)
