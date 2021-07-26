extends Button

func _ready():
	connect("pressed", self, "_on_button_press")

func _on_button_press():
	get_tree().quit()
