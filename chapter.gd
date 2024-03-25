extends BoxContainer
class_name Chapter

var title:String
@onready var scene_file = load("res://Scene.tscn")
@onready var SceneContainer = $Scenes/Panel/BoxContainer/SceneContainer
@onready var TitleEdit = $TitleEdit
@onready var WordCount = $WordCount
var word_count:int
signal update_word_count()


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
	pass
	var chapter: Dictionary = {
		"title": title,
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
