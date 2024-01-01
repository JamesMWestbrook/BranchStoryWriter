extends Node

var has_line:bool
var current_node: Line2D
var current_parent




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _assign_node(line:Line2D, parent):
	current_node = line
	current_parent = parent
	line.add_point(Vector2())
	has_line = true
	
func _finish_node(pos:Vector2,new_scene):
	
	current_parent.connected_scenes.append(new_scene)
	LineUser.current_node.set_point_position(1, pos)
	LineUser.has_line = false
	
func _process(delta):
	if has_line:
		var pos =  get_viewport().get_mouse_position()
		current_node.set_point_position(1, pos)
		
