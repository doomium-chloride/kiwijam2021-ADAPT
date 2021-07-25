extends Node2D


const bush_class = preload("res://Environment/Bush.tscn")

export var length = 30
var half = length / 2

export var top = 20
export var bottom = 20
export var right = 20
export var left = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	for column in range(-left, right + 1):
		make_bush(-top, column)
		make_bush(bottom, column)
	for row in range(-top, bottom + 1):
		make_bush(row, -left)
		make_bush(row, right)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func make_bush(row, column):
	var bush = bush_class.instance()
	var y = row * length + half
	var x = column * length + half
	bush.position = Vector2(x, y)
	bush.z_index = -5
	add_child(bush)
