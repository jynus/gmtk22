extends KinematicBody2D

enum State {HELD, SHOT, IDLE, EXPLODING}
var current_status = State.HELD
var velocity = Vector2.ZERO
export var max_velocity = 200
var hero
var primary
var die_ui
var spawn_point
var faces = null
var primary_texture = preload("res://sprites/dice_weapon.png")
var secondary_texture = preload("res://sprites/dice_weapon_secondary.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	hero = get_parent()
	set_primary(true)
	respawn()

func set_primary(is_primary:bool):
	primary = is_primary
	if primary:
		die_ui = get_node("/root/game/container/interface/primary_dice")
		spawn_point = hero.get_node("weaponRespawn")
		$sprite.animation = "idle_primary"
	else:
		die_ui = get_node("/root/game/container/interface/secondary_dice")
		spawn_point = hero.get_node("weaponRespawn2")
		$sprite.animation = "idle_secondary"

func set_faces(f):
	print(f)
	faces = f
	update_dice_interface()

func shoot():
	current_status = State.SHOT
	hero.set_collision_mask_bit(3, true)
	velocity = global_position.direction_to(get_global_mouse_position()).normalized() * max_velocity
	var original_position = global_position
	var new_parent = get_parent().get_parent()
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = original_position
	$animation.play("roll")
	$throwTimer.start()

func _physics_process(delta):
	match current_status:
		State.HELD:
			if primary and Input.is_action_just_pressed("ui_fire_primary"):
				shoot()
			if not primary and Input.is_action_just_pressed("ui_fire_secondary"):
				shoot()

		State.SHOT:
			velocity = move_and_slide(velocity)


func respawn():
	print("disable pickup")
	hero.set_collision_mask_bit(2, false)
	hero.set_collision_mask_bit(3, false)
	current_status = State.HELD
	get_parent().remove_child(self)
	hero.add_child(self)
	global_position = spawn_point.global_position
	if primary:
		z_index = 10
	else:
		z_index = 1
	$animation.play("RESET")

func update_dice_interface():
	if faces == null:
		return
	die_ui.visible = false
	var die_faces = die_ui.get_children()
	for i in range(6):
		print(faces[i+1].effect)
		die_faces[i].animation = HeroGlobals.effect_to_animation[faces[i+1].effect]
		die_faces[i].set_frame(faces[i+1].damage)
	die_ui.visible = true

func set_idle():
	current_status = State.IDLE
	print("enable pickup")
	hero.set_collision_mask_bit(2, true)
	hero.set_collision_mask_bit(3, false)
	$animation.stop()
	$animation.play("RESET")
	$idleTimer.start()

func set_exploding(damage):
	current_status = State.EXPLODING
	$animation.play("explode")
	var bodies = $explosionCollision.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("enemy") or b.is_in_group("hero"):
			b.damage(damage)
			print("You make damage for %s points" % damage)

func take_action(body):
	if faces == null:
		return
	var face_selected = randi() % 6 + 1
	print('You rolled face #%s' % face_selected)
	if faces[face_selected].effect == HeroGlobals.Effect.BASIC:
		body.damage(faces[face_selected].damage)
		print("You make damage for %s points" % faces[face_selected].damage)
	elif faces[face_selected].effect == HeroGlobals.Effect.AREA:
		set_exploding(faces[face_selected].damage)
	respawn()

func _on_trigger_body_entered(body):
	if body.is_in_group("hero"):
		respawn()
	elif current_status == State.SHOT:
		take_action(body)
	


func _on_idleTimer_timeout():
	respawn()


func _on_throwTimer_timeout():
	set_idle()
	

