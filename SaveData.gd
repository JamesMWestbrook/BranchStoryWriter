extends Resource
class_name SaveData

@export var file_name:String
@export var export_folder:String
@export var chapters:Array[Dictionary]
@export var characters:Array[Dictionary]
@export var GoalHistory:Dictionary
@export var CurrentDailyGoal:int
@export var conversions:Dictionary
@export var backups:Array[String]
@export var notes:String
func save(path):
	file_name = path.get_file()
	ResourceSaver.save(self,path)

func save_backup(path:String):
	print("Making backup")	
	Globals._check_backup_folder()
	if Globals.backups.size() >= 50:
		printt("Removing backup",Globals.backups[49])
		if ResourceLoader.exists(Globals.backups[49]):
			var dir = DirAccess.open(Globals.backup_folder)
			dir.remove_absolute(Globals.backups[49])
		Globals.backups.remove_at(49)
	#save
	printt("saving backup at", path)
	var filename:String = path.get_file()
	Globals.backups.insert(0,path)
	ResourceSaver.save(self,path)
	
	
static func load(path):
	if ResourceLoader.exists(path):
		Globals.file_name = path
		Settings.configdata.last_save_path = path
		return load(path)
	else:
		return null
	
