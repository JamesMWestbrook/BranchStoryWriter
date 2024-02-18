extends Resource
class_name ConfigData
const config_path:String = "user://Config.tres"
@export var test:int
@export var testTwo:String
@export var TestThree:bool

@export var autoOpen:bool

#when copying, what format to put it in
@export var export:String
@export var theme:int

@export var folder_path:String
@export var save_path:String:
	get:
		return save_path
	set(value):
		save_path = value
@export var autosave:bool
@export var interval:int


@export var popout:bool
@export var layout:String = "Horizontal"

func _save():
	ResourceSaver.save(self,config_path)
	
static func _load():
	if ResourceLoader.exists(config_path):
		return load(config_path)
	else:
		return null
