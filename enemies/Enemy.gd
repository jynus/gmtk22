extends KinematicBody2D


export var max_velocity = 50
export var hurt_acceleration = 500
enum states {IDLE, PERSUING, HURT}
export var status = states.IDLE
export var friction = 10
export var detection_range = 300
var velocity = Vector2.ZERO
var hero
export var max_life = 10
var current_life = max_life
var minion_type = "white_pawn"

# Called when the node enters the scene tree for the first time.
func _ready():
	hero = get_parent().get_node("hero")
	change_type(minion_type)


func _physics_process(delta):
	match status:
		states.PERSUING:
			velocity += global_position.direction_to(hero.global_position) * max_velocity
			velocity = velocity.limit_length(max_velocity)
			velocity = move_and_slide(velocity)
			if global_position.distance_to(hero.global_position) > detection_range:
				status = states.IDLE
		states.IDLE:
			if velocity != Vector2.ZERO:
				velocity = lerp(velocity, Vector2.ZERO, friction * delta)
			velocity = move_and_slide(velocity)
			if global_position.distance_to(hero.global_position) <= detection_range:
				status = states.PERSUING
		states.HURT:
			velocity = lerp(velocity, Vector2.ZERO, friction * delta)
			velocity = move_and_slide(velocity)

func change_type(minion_skin):
	if minion_skin == "black_pawn":
		minion_type = "black_pawn"
		$sprite.animation = "walking_black"
	else:
		minion_type = "white_pawn"
		$sprite.animation = "walking_white"

func update_lifebar():
	$lifeBar.update()

func damage(amount, from):
	$hurt_sfx.play()
	current_life -= amount
	status = states.HURT
	$hurtTimer.start()
	velocity += from.global_position.direction_to(global_position).normalized() * hurt_acceleration
	update_lifebar()
	if current_life <= 0:
		current_life = 0
		die()

func die():
	$die_sfx.play()


func _on_hurtbox_area_entered(area):
	if area.is_in_group("dice"):
		var dice = area.get_parent()
		if dice.is_shot():
			dice.take_action(self)
	elif area.is_in_group("explosion"):
		var dice = area.get_parent()
		if dice.is_exploding():
			damage(dice.current_damage, dice)
	elif area.is_in_group("hero"):
		var hero = area.get_parent()
		hero.damage(3)

func _on_hurtTimer_timeout():
	status = states.IDLE


func _on_die_sfx_finished():
	queue_free()
