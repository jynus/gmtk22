extends KinematicBody2D


var velocity: = Vector2.ZERO
export var acceleration:float = 500
export var max_velocity = 100
export var friction = 10
export var life = 100

func _ready():
	update_lifebar()

func update_lifebar():
	$lifeLabel.text = str(life)

func _physics_process(delta):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input == Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
	velocity += input * acceleration * delta
	velocity = velocity.limit_length(max_velocity)
	velocity = move_and_slide(velocity)

func damage(amount):
	life -= amount
	if life <= 0:
		die()
	update_lifebar()

func die():
	pass

