extends Resource
class_name SaveData


const Save_Path := "user://Save.tres"


@export var node_connections:Array[Dictionary]
@export var all_nodes:Array[Dictionary]
	
func _create_scene(node):
	var scene: Dictionary
	scene.name = node.name
	scene.title = node.get_node("TextEdit").text
	scene.dialogs = node.scene
	all_nodes.append(scene)

func save():
	ResourceSaver.save(self,Save_Path)

	
	
static func load():
	if ResourceLoader.exists(Save_Path):
		return load(Save_Path)
	else:
		return null
	
