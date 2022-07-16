extends Position2D

onready var enemy = preload("res://enemies/Enemy.tscn")
export var enemy_type = "white_pawn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_spawnTimer_timeout():
	var e = enemy.instance()
	e.change_type(enemy_type)
	get_parent().add_child(e)
	e.position = global_position
