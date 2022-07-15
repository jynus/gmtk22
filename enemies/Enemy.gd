extends KinematicBody2D


export var max_velocity = 50
var velocity = Vector2.ZERO
var hero
export var life = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	hero = get_parent().get_node("hero")


func _physics_process(delta):
	velocity = global_position.direction_to(hero.global_position).normalized() * max_velocity
	velocity = move_and_slide(velocity)

func damage(amount):
	life -= amount
	if life <= 0:
		die()
	$lifeLabel.text = str(life)

func die():
	queue_free()


func _on_hurtbox_body_entered(body):
	if body.is_in_group("hero"):
		body.damage(3)
