extends KinematicBody2D

enum State {HELD, SHOT, IDLE, EXPLODING}
var current_status = State.HELD
var velocity = Vector2.ZERO
export var max_velocity = 200
var hero

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	hero = get_parent()
	respawn()


func shoot():
	current_status = State.SHOT
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
			if Input.is_action_just_pressed("ui_fire_secondary"):
				shoot()
		State.SHOT:
			velocity = move_and_slide(velocity)


func respawn():
	visible = false
	current_status = State.HELD
	hero.set_collision_mask_bit(4, false)
	$animation.stop(true)
	$animation.play("RESET")
	get_parent().remove_child(self)
	hero.add_child(self)
	global_position = hero.get_node("weaponRespawn2").global_position
	visible = true

	
func set_exploding():
	current_status = State.EXPLODING
	$sprite.visible = false
	$animation.stop()
	$animation.play("explosion")
	var bodies = $explosionCollision.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("enemy") or b.is_in_group("hero"):
			b.damage(randi() % 6 + 1)

func take_action(body):
	set_exploding()

func _on_trigger_body_entered(body):
	if body.is_in_group("hero"):
		respawn()
	elif current_status == State.SHOT:
		take_action(body)
	


func _on_idleTimer_timeout():
	respawn()


func _on_throwTimer_timeout():
	if current_status == State.IDLE:
		set_exploding()
	

func _on_animation_animation_finished(anim_name):
	if anim_name == "explosion":
		set_idle()

func set_idle():
	$sprite.visible = true
	current_status = State.IDLE
	$animation.stop()
	$animation.play("RESET")
	hero.set_collision_mask_bit(4, true)
	$idleTimer.start()
