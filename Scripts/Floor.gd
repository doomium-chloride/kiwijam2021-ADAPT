extends Node2D


const tile_class = preload("res://Environment/Tile.tscn")

export var rows = 50
export var columns = 50
export var tile_scale = 0.5

var length = 64
var half = length / 2


# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(-rows, rows):
		for column in range(-columns, columns):
			make_tile(row, column)


func make_tile(row, column):
	var tile = tile_class.instance()
	tile.scale = Global.scale2(tile_scale)
	var y = row * length + half
	var x = column * length + half
	tile.position = Vector2(x, y) * tile_scale
	tile.z_index = -10
	add_child(tile)
