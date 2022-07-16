extends KinematicBody2D


var velocity: = Vector2.ZERO
export var acceleration:float = 500
export var max_velocity = 100
export var friction = 10
export var life = 100
var dice = preload("res://hero/Dice.tscn")
var facing = "down"

func _ready():
	update_lifebar()
	# primary weapon
	var d = dice.instance()
	add_child(d)
	d.set_primary(false)
	d.set_faces({
		1: {'effect': HeroGlobals.Effect.AREA, 'damage': 1},
		2: {'effect': HeroGlobals.Effect.AREA, 'damage': 2},
		3: {'effect': HeroGlobals.Effect.AREA, 'damage': 3},
		4: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0},
		5: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0},
		6: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0}
	})
	d.respawn()
	# secondary weapon
	d = dice.instance()
	add_child(d)
	d.set_primary(true)
	d.set_faces({
		1: {'effect': HeroGlobals.Effect.BASIC, 'damage': 2},
		2: {'effect': HeroGlobals.Effect.BASIC, 'damage': 3},
		3: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 4},
		4: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 5},
		5: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0},
		6: {'effect': HeroGlobals.Effect.NO_EFFECT, 'damage': 0}
	})
	d.respawn()

func update_lifebar():
	$lifeLabel.text = str(life)

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
	life -= amount
	if life <= 0:
		die()
	update_lifebar()

func die():
	pass

