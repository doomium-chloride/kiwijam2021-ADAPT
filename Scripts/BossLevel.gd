extends Node2D


const boss_class = preload("res://Actors/Boss.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var bushes = $AutoBorder.get_children()
	var bush_count = $AutoBorder.get_child_count()
	var boss = boss_class.instance()
	
	var bush_index = randi() % bush_count
	var bush = bushes[bush_index]
	var x = 0
	var y = 0
	if bush.position.x > 0:
		x = -100
	else:
		x = 100
	if bush.position.y > 0:
		y = -100
	else:
		y = 100
	boss.position = bush.position + Vector2(x, y)
	
	add_child(boss)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
