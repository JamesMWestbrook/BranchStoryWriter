extends ScrollContainer

@onready var child = $Panel
var margin = 10
func _ready():
	fit_content()
	child.resized.connect(fit_content)
	pass

func _process(delta):
	pass

func fit_content():
	custom_minimum_size.y = child.size.y + margin
