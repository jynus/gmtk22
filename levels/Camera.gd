extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func count_enemies():
	var total = 0
	for i in $floor.get_children():
		if i.is_in_group("enemy"):
			total += 1
	return total

func won_level():
	get_tree().paused = true
	$container/interface/won.visible = true
	$container/interface/won.pause_mode = PAUSE_MODE_PROCESS

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_reload"):
		get_tree().reload_current_scene()
	if count_enemies() == 0:
		won_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$camera.position = $floor/hero.global_position
