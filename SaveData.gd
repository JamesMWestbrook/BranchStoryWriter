extends Resource
class_name SaveData

@export var file_name:String
@export var node_connections:Array[Dictionary]
@export var all_nodes:Array[Dictionary]
@export var characters:Array[String]



func _create_scene(node):
	var scene: Dictionary = {}
	scene.name = node.name
	scene.title = node.title_edit.text
	scene.description = node.scene_desc_edit.text
	scene.dialogs = node.scene
	scene.position_offset = node.position_offset
	all_nodes.append(scene)

func save(path):
	if file_name == "":
		file_name = path.get_file()
		
	ResourceSaver.save(self,path)

	
	
static func load(path):
	if ResourceLoader.exists(path):
		Settings.configdata.save_path = path
		return load(path)
	else:
		return null
	
