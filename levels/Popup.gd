extends CenterContainer

onready var primary_dice_ui = $horizontal_container/selection/selection1/Panel/vertical_panel/primary_dice_selection
onready var secondary_dice_ui = $horizontal_container/selection/selection2/Panel2/vertical_panel2/secondary_dice_selection
onready var new_dice_ui = $horizontal_container/selection/selection3/Panel3/vertical_panel3/new_dice_selection
var hover = ""
var game_primary_dice = null
var game_secondary_dice = null
var game_new_dice = null
var hero = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(_delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			unpause()
		if Input.is_action_just_pressed("ui_fire_primary"):
			if hover != "":
				change_dice(hover)

func unpause():
	visible = false
	hover = ""
	game_primary_dice = null
	game_secondary_dice = null
	game_new_dice = null
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_STOP

func change_dice(which):
	if which == "new":
		unpause()
	elif which == "primary":
		var original_position = hero.primary_dice.global_position
		var new_parent = hero.get_parent()
		hero.remove_child(hero.primary_dice)
		new_parent.add_child(hero.primary_dice)
		hero.primary_dice.global_position = original_position
		hero.primary_dice.set_idle()
		hero.primary_dice.get_node("trigger/collision").set_deferred("disabled", true)
		hero.primary_dice.get_node("reenableCollisionTimer").start()
		hero.primary_dice.hero = null
		hero.primary_dice = null
		game_new_dice.die_ui = get_node("/root/game/container/interface/primary_dice")
		game_new_dice.spawn_point = hero.get_node("weaponRespawn")
		hero.pickup_new_dice(game_new_dice)
		hero.primary_dice = game_new_dice
		hero.primary_dice.update_dice_interface()
		unpause()
	elif which == "secondary":
		var original_position = hero.secondary_dice.global_position
		var new_parent = hero.get_parent()
		hero.remove_child(hero.secondary_dice)
		new_parent.add_child(hero.secondary_dice)
		hero.secondary_dice.global_position = original_position
		hero.secondary_dice.set_idle()
		hero.secondary_dice.get_node("trigger/collision").set_deferred("disabled", true)
		hero.secondary_dice.get_node("reenableCollisionTimer").start()
		hero.secondary_dice.hero = null
		hero.secondary_dice = null
		game_new_dice.die_ui = get_node("/root/game/container/interface/secondary_dice")
		game_new_dice.spawn_point = hero.get_node("weaponRespawn2")
		hero.pickup_new_dice(game_new_dice)
		hero.secondary_dice = game_new_dice
		hero.secondary_dice.update_dice_interface()
		unpause()

func show_dice(dice, dice_ui):
	if dice == null or dice.faces == null:
		return
	var faces = dice.faces
	dice_ui.visible = false
	var ui_faces = dice_ui.get_children()
	for i in range(6):
		if not i+1 in faces:
			continue
		print(faces[i+1].effect)
		ui_faces[i].animation = HeroGlobals.effect_to_animation[faces[i+1].effect]
		ui_faces[i].set_frame(faces[i+1].damage)
	dice_ui.visible = true

func select_dice(primary_dice, secondary_dice, new_dice):
	visible = true
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true

	game_primary_dice = primary_dice
	show_dice(primary_dice, primary_dice_ui)
	game_secondary_dice = secondary_dice
	show_dice(secondary_dice, secondary_dice_ui)
	game_new_dice = new_dice
	show_dice(new_dice, new_dice_ui)
	hero = get_node("/root/game/floor/hero")
	

func _on_Panel_mouse_entered():
	hover = "primary"
	$horizontal_container/selection/selection1/Panel.modulate = Color(1, 0.5, 0.5, 1)

func _on_Panel_mouse_exited():
	hover = ""
	$horizontal_container/selection/selection1/Panel.modulate = Color(1, 1, 1, 1)

func _on_Panel3_mouse_entered():
	hover = "new"
	$horizontal_container/selection/selection3/Panel3.modulate = Color(1, 0.5, 0.5, 1)

func _on_Panel3_mouse_exited():
	hover = ""
	$horizontal_container/selection/selection3/Panel3.modulate = Color(1, 1, 1, 1)

func _on_Panel2_mouse_entered():
	hover = "secondary"
	$horizontal_container/selection/selection2/Panel2.modulate = Color(1, 0.5, 0.5, 1)

func _on_Panel2_mouse_exited():
	hover = ""
	$horizontal_container/selection/selection2/Panel2.modulate = Color(1, 1, 1, 1)
