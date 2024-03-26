extends Resource
class_name SaveData

@export var file_name:String
@export var chapters:Array[Dictionary]
@export var characters:Array[Dictionary]
@export var GoalHistory:Dictionary
@export var CurrentDailyGoal:int
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
	
