extends GraphNode

var scene:Array
var active_window
@export var WritingWindowScene:PackedScene

var connected_scenes:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_write_button_down():
	if is_instance_valid(active_window):
		active_window.show()
	else:
		active_window = WritingWindowScene.instantiate()
		add_child(active_window)
		active_window.updated_dialog.connect(_update_scene)
		active_window.position = get_viewport().get_mouse_position()
		active_window._create_dialog(null,true)
func _update_scene():
	scene = active_window.all_dialog
