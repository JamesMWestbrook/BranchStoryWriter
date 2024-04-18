extends Resource
class_name SaveData

@export var file_name:String
@export var export_folder:String
@export var chapters:Array[Dictionary]
@export var characters:Array[Dictionary]
@export var GoalHistory:Dictionary
@export var CurrentDailyGoal:int
@export var conversions:Dictionary
func save(path):
	file_name = path.get_file()
	ResourceSaver.save(self,path)
	
	
static func load(path):
	if ResourceLoader.exists(path):
		Globals.file_name = path
		Settings.configdata.last_save_path = path
		return load(path)
	else:
		return null
	
