extends KinematicBody2D

enum State {HELD, SHOT, IDLE, EXPLODING}
var current_status = State.IDLE
var current_damage = 0
var velocity = Vector2.ZERO
export var max_velocity = 200
var hero = null
var primary = true
var die_ui
var spawn_point
export var faces = {
	1: {'effect': HeroGlobals.Effect.BASIC, 'damage': 1},
	2: {'effect': HeroGlobals.Effect.BASIC, 'damage': 2},
	3: {'effect': HeroGlobals.Effect.BASIC, 'damage': 3},
	4: {'effect': HeroGlobals.Effect.BASIC, 'damage': 4},
	5: {'effect': HeroGlobals.Effect.BASIC, 'damage': 5},
	6: {'effect': HeroGlobals.Effect.BASIC, 'damage': 6}
}
export var texture = "idle_primary"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if hero != null:
		hero = get_parent()
		set_primary(true)
		respawn()
	else:
		$idleTimer.disconnect("timeout", self, "_on_idleTimer_timeout")
		set_primary(true)
		set_idle()

func is_idle():
	return current_status == State.IDLE

func is_shot():
	return current_status == State.SHOT

func is_exploding():
	return current_status == State.EXPLODING

func set_primary(is_primary:bool):
	primary = is_primary
	$sprite.animation = texture
	if primary:
		if hero != null:
			die_ui = get_node("/root/game/container/interface/primary_dice")
			spawn_point = hero.get_node("weaponRespawn")
			z_index = 10
	else:
		if hero != null:
			die_ui = get_node("/root/game/container/interface/secondary_dice")
			spawn_point = hero.get_node("weaponRespawn2")
			z_index = 1

func set_faces(f):
	print(f)
	faces = f
	update_dice_interface()

func shoot():
	print("shoot")
	current_status = State.SHOT
	$statusLabel.text = "SHOT"
	$collision.set_deferred("disabled", false)
	$trigger/collision.set_deferred("disabled", false)
	update_dice_interface()
	velocity = global_position.direction_to(get_global_mouse_position()).normalized() * max_velocity
	var original_position = global_position
	var new_parent = get_parent().get_parent()
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = original_position
	$animation.play("roll")
	$throwTimer.start()

func _physics_process(_delta):
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
	$statusLabel.text = "HELD"
	$sprite.play()
	$collision.set_deferred("disabled", true)
	$trigger/collision.set_deferred("disabled", true)
	current_status = State.HELD
	if get_parent() != hero:
		hero = get_node("/root/game/floor/hero")
		get_parent().remove_child(self)
		hero.add_child(self)
	global_position = spawn_point.global_position
	if primary:
		set_primary(true)
	else:
		set_primary(false)
	update_dice_interface()
	var _return = $idleTimer.connect("timeout", self, "_on_idleTimer_timeout")
	$animation.play("RESET")

func update_dice_interface():
	if faces == null:
		return
	die_ui.visible = false
	var die_faces = die_ui.get_children()
	for i in range(6):
		if not i+1 in faces:
			continue
		print(faces[i+1].effect)
		die_faces[i].animation = HeroGlobals.effect_to_animation[faces[i+1].effect]
		die_faces[i].set_frame(faces[i+1].damage)
		if current_status != State.HELD:
			die_faces[i].modulate = Color(0.5,0.5,0.5,0.5)
		else:
			die_faces[i].modulate = Color(1,1,1,1)
	die_ui.visible = true

func set_idle():
	current_status = State.IDLE
	$sprite.stop()
	$statusLabel.text = "IDLE"
	$collision.set_deferred("disabled", true)
	$trigger/collision.set_deferred("disabled", false)
	$explosionCollision/collision.set_deferred("disabled", true)
	print("enable pickup")	
	$animation.stop()
	$animation.play("RESET")
	if hero != null:
		$idleTimer.start()

func set_exploding():
	current_status = State.EXPLODING
	$statusLabel.text = "EXPLODING"
	$animation.play("explode")
	$explosionCollision/collision.set_deferred("disabled", false)

func take_action(body):
	if faces == null:
		return
	var face_selected = randi() % 6 + 1
	print('You rolled face #%s' % face_selected)
	var effect = HeroGlobals.Effect.NO_EFFECT
	if not face_selected in faces:
		current_damage = 0
	else:
		current_damage = faces[face_selected].damage
		effect = faces[face_selected].effect
	if effect == HeroGlobals.Effect.BASIC:
		body.damage(current_damage, self)
		$damageLabel.set("custom_colors/font_color", Color(1,0.3,0))
		$damageLabel.text = str(current_damage)
		$animation.play("damage")
		print("You make damage for %s points" % current_damage)
		yield(get_node("animation"), "animation_finished")
	elif effect == HeroGlobals.Effect.AREA:
		print("Explosion in an area with %s damage" % current_damage)
		set_exploding()
	else:
		$damageLabel.set("custom_colors/font_color", Color(1, 0.945, 0.91))
		$damageLabel.text = '0'
		$animation.play("damage")
		print("It has no effect :-(")

#func _on_trigger_body_entered(body):
#	if current_status == State.IDLE and body.is_in_group("hero"):
#		respawn()
#	elif current_status == State.SHOT and body.is_in_group("enemy"):
#		take_action(body)
	

func _on_idleTimer_timeout():
	if current_status == State.IDLE and hero != null:
		respawn()

func _on_throwTimer_timeout():
	if current_status == State.SHOT:
		set_idle()


func _on_reenableCollisionTimer_timeout():
	$trigger/collision.set_deferred("disabled", false)
