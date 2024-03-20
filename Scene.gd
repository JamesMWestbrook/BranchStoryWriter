extends PanelContainer
class_name Scene
var scene: Array[Dictionary]:
	set(value):
		scene = value
		pass

var writing_in_this_scene:bool
@onready var title_edit = $BoxContainer/Row1Container/TitleEdit
@onready var scene_desc_edit:TextEdit = $BoxContainer/TextEdit
@onready var WordCount:Label = $BoxContainer/Row1Container/WordCount
@onready var AddSceneRight:Button = $BoxContainer/Row1Container/AddSceneRight
var connected_scenes:Array
var word_count:int
signal update_word_count()
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
	Globals.WritingPanel._set_title(title_edit.text)
	Globals.WritingPanel._set_word_count(word_count)
	Globals.main._set_window()
	
	self_modulate = "ff0000"
	writing_in_this_scene = true
		#active_window.position = get_viewport().get_mouse_position()
		#if !loading:
			#active_window._create_dialog(null,true)
		#active_window.scene_title = title
	pass
		
func _update_scene(new_scene:Array[Dictionary]):
	scene = new_scene.duplicate()
	_set_word_count()
	Globals.WritingPanel._set_word_count(word_count)
	update_word_count.emit()
	
		
func _set_word_count():
	word_count = 0
	for i in scene:
		var dialog:String = i.dialog.replacen(".","")
		word_count += dialog.split(" ", false).size()
	WordCount.text = str(word_count) + " Words"
	
func _on_text_edit_text_changed(new_text):
	if writing_in_this_scene:
		Globals.WritingPanel._set_title(new_text)
	

func _reset_modulate():
	writing_in_this_scene = false
	self_modulate = "ffffff"
	
	
func _on_confirmation_delete_dialog_confirmed():
	pass
	pass # Replace with function body.


func save():
	var new_scene:Dictionary = {
		"title":title_edit.text,
		"description":scene_desc_edit.text,
		"scenes":scene
	}
	
	return new_scene
	
