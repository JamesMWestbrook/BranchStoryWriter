extends GraphNode

var scene: Array[Dictionary]:
	set(value):
		scene = value
		pass

@onready var title_edit = $TitleEdit
@onready var scene_desc_edit:TextEdit = $DescEdit
@onready var WordCount:Label = $WordCount
var connected_scenes:Array

func _ready():
	pass


func _on_write_button_down():
	#if is_instance_valid(active_window):
		#active_window.show()
	#else:
		#active_window = WritingWindowScene.instantiate()
		#add_child(active_window)
	Globals.WritingPanel.updated_dialog.emit(Globals.WritingPanel.all_dialog)
	Globals.WritingPanel._clear()
	Globals.WritingPanel.reassigned.connect(_reset_modulate)
	Globals.WritingPanel.updated_dialog.connect(_update_scene)
	Globals.WritingPanel._load_dialog(scene)
	self_modulate = "ff0000"
		#active_window.position = get_viewport().get_mouse_position()
		#if !loading:
			#active_window._create_dialog(null,true)
		#active_window.scene_title = title
	pass
		
func _update_scene(new_scene:Array[Dictionary]):
	scene = new_scene.duplicate()
	WordCount.text = "Word Count: " 
	if is_instance_valid(Globals.WritingPanel.word_count):
		WordCount.text += str(Globals.WritingPanel.word_count)

func _on_text_edit_text_changed(new_text):
	title = new_text
	#if is_instance_valid(active_window):
		#active_window.scene_title = title
		#active_window._update_scene_data()


func _reset_modulate():
	self_modulate = "ffffff"
func _on_confirmation_delete_dialog_confirmed():
	pass
	pass # Replace with function body.
