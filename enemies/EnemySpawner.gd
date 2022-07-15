extends Position2D

onready var enemy = preload("res://enemies/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_spawnTimer_timeout():
	var e = enemy.instance()
	get_parent().add_child(e)
	e.position = global_position
