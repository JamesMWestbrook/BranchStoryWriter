extends Node2D

var dragging:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += get_viewport().get_mouse_position()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 3:
			print("Pressed")
			if event.pressed:
			# Check if the mouse is over the node
				if event.is_released():
					dragging = false
				else:
					dragging = true
					
