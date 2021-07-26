extends Control


onready var selector_one = $Button
onready var instructionSFX = $InstructionSFX

const play_scene = "res://Menu/HomeMenu.tscn"

var current_selection = 0

func _ready():
	instructionSFX.play()
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 0:
		current_selection += 0
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 0
		set_current_selection(current_selection)
	if Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		Global.goto_scene(play_scene)
	elif _current_selection == 1:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	if _current_selection == 0:
		selector_one.text = "Back"

