extends Resource
class_name SaveData

@export var node_connections:Array[Dictionary]
@export var all_nodes:Array[Dictionary]
	
func _create_scene(node):
	var scene: Dictionary = {}
	scene.name = node.name
	scene.title = node.get_node("TextEdit").text
	scene.dialogs = node.scene
	all_nodes.append(scene)

func save(path):
	ResourceSaver.save(self,path)

	
	
static func load(path):
	if ResourceLoader.exists(path):
		Settings.configdata.save_path = path
		return load(path)
	else:
		return null
	
