extends BoxContainer
class_name Chapter
@onready var menu_button = $HBoxContainer3/MenuButton
@onready var scene_file = load("res://Scene.tscn")
@onready var SceneContainer = $Scenes/Panel/BoxContainer/SceneContainer
@onready var TitleEdit = $HBoxContainer3/TitleEdit
@onready var WordCount = $HBoxContainer3/WordCount
@onready var fileDialog = $FileDialog
@onready var AddChapterBefore:Button = $AddChapterBefore
@onready var AddChapterAfter:Button = $AddChapterAfter
@onready var DeleteConfirmation:ConfirmationDialog = $ConfirmationDialog

var word_count:int
signal update_word_count()
signal add_above()
signal add_below()


func _ready():
	var popup:PopupMenu = menu_button.get_popup()
	if !popup.id_pressed.is_connected(_option_chosen):
		popup.id_pressed.connect(_option_chosen)
		
		
func _on_add_scene_right_button_down(prev_scene, data,start:bool = false): #false data = brand new
	var new_scene:Scene = scene_file.instantiate()
	if is_instance_valid(prev_scene):
		prev_scene.add_sibling(new_scene)
	else:
		SceneContainer.add_child(new_scene)
		
	new_scene.AddSceneRight.button_down.connect(_on_add_scene_right_button_down.bind(new_scene,false))
	new_scene.update_word_count.connect(_get_word_count)
	
#on load
	if data:
		new_scene.title_edit.text = data.title
		new_scene.scene_desc_edit.text = data.description
		new_scene.scene = data.scenes
		new_scene._set_word_count()
	if start:
		SceneContainer.move_child(new_scene,0)
	
func save():
	var chapter: Dictionary = {
		"title": TitleEdit.text,
		"scenes": []
	}
	for scene in SceneContainer.get_children():
		if scene is Scene:
			chapter.scenes.append(scene.save())
	return chapter


func _on_add_start_button_down():
	_on_add_scene_right_button_down(null,null,true)

func _get_word_count():
	var new_word_count = 0
	for scene in SceneContainer.get_children():
		if scene is Scene:
			new_word_count += scene.word_count
	word_count = new_word_count
	WordCount.text = str(new_word_count) + " words"
	update_word_count.emit()


func _on_export_button_down():
	if Globals.export_folder.is_empty():
		Globals.set_export_path()
	var path = Globals.export_folder
	fileDialog.current_dir = path
	fileDialog.current_file = TitleEdit.text
	fileDialog.show()

func _export_chapter():
	var export:String = "---    " + TitleEdit.text.to_upper() + "    ---\n"
	for scene:Scene in SceneContainer.get_children():
		export += scene._export_scene()
	export += "\n"
	return export
	
func _export_chapter_html():
	var export:String = "<h1>" + TitleEdit.text + "</h1><br>\n"
	for scene:Scene in SceneContainer.get_children():
		export += scene._export_scene_html()
	return export
func _on_file_dialog_file_selected(path):
	var file = FileAccess.open(path,FileAccess.WRITE)
	var string = _export_chapter()
	file.store_string(string)
	OS.shell_open(path.get_base_dir())
	Globals.new_export_path(path)




func _on_menu_button_button_down():
	pass

func _option_chosen(id:int):
	print(id)
	match id:
		0: #export
			_on_export_button_down()
		1: #add chapter above
			add_above.emit()
		2: #add chapter below:
			add_below.emit()
		3: #delete
			DeleteConfirmation.show()
func _medium():
	pass
func _slim():
	pass
