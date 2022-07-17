extends KinematicBody2D


var velocity: = Vector2.ZERO
export var acceleration:float = 500
export var max_velocity = 100
export var friction = 10
export var max_life = 100
var current_life = max_life
var dice_scene = preload("res://hero/Dice.tscn")
var facing = "down"
var primary_dice = null
var secondary_dice = null


func _ready():
	pass
	# secondary weapon
	#secondary_dice = dice_scene.instance()
	#add_child(secondary_dice)
	#secondary_dice.set_primary(false)
	#secondary_dice.set_faces({
	#	1: {'effect': HeroGlobals.Effect.AREA, 'damage': 1},
	#	2: {'effect': HeroGlobals.Effect.AREA, 'damage': 2},
	#	3: {'effect': HeroGlobals.Effect.AREA, 'damage': 1},
	#	4: {'effect': HeroGlobals.Effect.AREA, 'damage': 1},
	#	5: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0},
	#	6: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0}
	#})
	#secondary_dice.respawn()
	# primary weapon
	#primary_dice = dice_scene.instance()
	#add_child(primary_dice)
	#primary_dice.set_primary(true)
	#primary_dice.set_faces({
	#	1: {'effect': HeroGlobals.Effect.BASIC, 'damage': 1},
	#	2: {'effect': HeroGlobals.Effect.BASIC, 'damage': 2},
	#	3: {'effect': HeroGlobals.Effect.BASIC, 'damage': 3},
	#	4: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0},
	#	5: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0},
	#	6: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0}
	#})
	#primary_dice.respawn()

func update_lifebar():
	$lifeBar.update()

func set_animation(direction):
	# idle animations
	if direction == Vector2.ZERO:
		if facing == "up":
			$sprite.play("idle_up")
		else:
			$sprite.play("idle_down")
	else:
		if direction.y >= 0:
			$sprite.play("walk_down")
		else:
			$sprite.play("walk_up")

func _physics_process(delta):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input == Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
	velocity += input * acceleration * delta
	velocity = velocity.limit_length(max_velocity)
	velocity = move_and_slide(velocity)
	if velocity.y >= 0:
		facing = "down"
	elif velocity.y < 0:
		facing = "up"
	set_animation(input)

func damage(amount):
	current_life -= amount
	if current_life <= 0:
		die()
	update_lifebar()

func die():
	get_tree().reload_current_scene()


func _on_trigger_body_entered(body):
	if body.is_in_group("enemy"):
		damage(3)  # FIXME


func _on_trigger_area_entered(area):
	if area.is_in_group("dice"):
		var dice = area.get_parent()
		if dice.is_idle():
			if dice.hero == self:
				dice.respawn()
			else:
				pickup_new_dice(dice)
	elif area.is_in_group("explosion"):
		var dice = area.get_parent()
		if dice.is_exploding():
			damage(dice.current_damage)
	else:
		print("something else collisioned")


func pickup_new_dice(dice):
	if primary_dice == null:
		print("new primary dice")
		primary_dice = dice
		dice.set_primary(true)
		dice.hero = self
		dice.spawn_point = $weaponRespawn
		dice.die_ui = get_node("/root/game/container/interface/primary_dice")
		dice.respawn()
	elif secondary_dice == null:
		print("new secondary dice")
		secondary_dice = dice
		dice.set_primary(false)
		dice.hero = self
		dice.spawn_point = $weaponRespawn2
		dice.die_ui = get_node("/root/game/container/interface/secondary_dice")
		dice.respawn()
	else:
		new_dice_selection(primary_dice, secondary_dice, dice)

func new_dice_selection(primary_dice, secondary_dice, dice):
	var popup = get_node("/root/game/container/interface/popup")
	popup.select_dice(primary_dice, secondary_dice, dice)
