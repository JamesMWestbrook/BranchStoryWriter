extends GraphNode

var scene:Array
var active_window
@export var WritingWindowScene:PackedScene

var connected_scenes:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_write_button_down(loading: bool = false):
	if is_instance_valid(active_window):
		active_window.show()
	else:
		active_window = WritingWindowScene.instantiate()
		add_child(active_window)
		active_window.updated_dialog.connect(_update_scene)
		active_window.position = get_viewport().get_mouse_position()
		if !loading:
			active_window._create_dialog(null,true)
		active_window.scene_title = title
func _update_scene():
	scene = active_window.all_dialog


func _on_text_edit_text_changed(new_text):
	title = new_text
	if is_instance_valid(active_window):
		active_window.scene_title = title
		active_window._update_scene_data()
