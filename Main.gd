extends Panel

@export var scene_header: PackedScene
var dragging:bool
# will hold all scenes in an array
var scenes:Array
var speed: int = 15
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if dragging:
			if event.relative.x > 0:
				position.x -= 1 * speed
			elif event.relative.x < 0:
				position.x += 1 * speed
			if event.relative.y > 0:
				position.y -= 1 * speed
			elif event.relative.y < 0:
				position.y += 1 * speed
	if event is InputEventMouseButton:
		if event.button_index == 3:
			print("Pressed")
			if event.pressed:
				dragging = true
			elif event.is_released():
				dragging = false
					
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			if LineUser.has_line:
				var textedit = _spawn_scene(event.position)
				var line_finish_pos = textedit.get_node("Left").global_position
				LineUser._finish_node(line_finish_pos,textedit)
			else:
				_spawn_scene(event.position)
			
		


func _spawn_scene(pos:Vector2):
	var textedit = scene_header.instantiate()
	add_child(textedit)
	scenes.append(textedit)
	textedit.position = pos
	return textedit

func _on_area_2d_input_event(viewport, event, shape_idx):
	print(event.position)
