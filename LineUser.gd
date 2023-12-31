extends Node

var has_node:bool
var current_node: Line2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _assign_node(line:Line2D):
	current_node = line
	line.add_point(Vector2())
	has_node = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_node:
		current_node.set_point_position(1, current_node.get_global_mouse_position())
		
