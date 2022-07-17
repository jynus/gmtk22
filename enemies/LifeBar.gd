extends TextureProgress

var max_life

# Called when the node enters the scene tree for the first time.
func _ready():
	max_life = get_parent().max_life
	update()

func update():
	max_value = max_life
	value = get_parent().current_life
