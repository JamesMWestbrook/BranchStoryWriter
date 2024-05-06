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
@onready var DeleteConfirmation = $ConfirmationDialog
var connected_scenes:Array
var word_count:int
signal update_word_count()
func _ready():
	var popup:PopupMenu = $BoxContainer/Row1Container/Options .get_popup()
	if !popup.id_pressed.is_connected(_option_chosen):
		popup.id_pressed.connect(_option_chosen)


func _on_write_button_down():
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
	
func _update_scene(new_scene:Array[Dictionary]):
	scene = new_scene.duplicate()
	_set_word_count()
	Globals.WritingPanel._set_word_count(word_count)
	update_word_count.emit()
	
		
func _set_word_count():
	word_count = 0
	for i in scene:
		if i.comment:
			continue
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
	

func _export_scene():
	var full_scene:String = title_edit.text + "\n"
	for d in scene:
		full_scene += d.speaker + "\n"
		if d.comment:
			full_scene += "*******"
		full_scene += d.dialog
		if d.comment:
			full_scene += "*******"
		full_scene += "\n"
	full_scene += "------------------\n"
	return full_scene

func _on_file_dialog_file_selected(path):
	var file = FileAccess.open(path,FileAccess.WRITE)
	var string = _export_scene()
	file.store_string(string)
	OS.shell_open(path.get_base_dir())
	Globals.new_export_path(path)

func _on_export_scene_button_down():
	if Globals.export_folder.is_empty():
		Globals.set_my_documents()
	$FileDialog.current_dir = Globals.export_folder
	$FileDialog.current_file = title_edit.text
	$FileDialog.show()
func _option_chosen(id:int):
	match id:
		0: #delete scene
			DeleteConfirmation.show()
