extends Node
class_name Globals

static var main:Main
static var WritingPanel
static var Loading:bool
static var file_name:String
static var backup_folder:String
static var export_folder:String
static var backups:Array[String]
static func new_export_path(path:String):
	Globals.export_folder = path.get_base_dir()

static var spell_checker = SpellChecker.new()

static func set_export_path():
	Globals.export_folder = set_my_documents()

static func set_save_path():
	Settings.configdata.default_folder_path = set_my_documents()
	
static func _check_documents():
	var dir = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	if !dir.dir_exists("BranchWriter"):
		dir.make_dir(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/BranchWriter")
static func _check_backup_folder():
	_check_documents()
	var documents = set_my_documents()
	var dir = DirAccess.open(documents)
	if !is_instance_valid(dir):
		printerr("Folder " + documents + " is invalid")
	if !dir.dir_exists("Backups"):
		dir.make_dir(documents + "/Backups")
	Globals.backup_folder = documents + "/Backups"
	
static func set_my_documents():
	var path:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/BranchWriter"
	_check_documents()
	return path

static func clear():
	file_name = ""
	Globals.main.clear()
	backups.clear()


static func spell_check(sentence:String):
		var comma_removed:String = sentence
		var symbols = [",",".","!","?","\"",":"]
		for i in symbols:
			comma_removed = comma_removed.replace(i,"")
		
		var sentence_array:Array = comma_removed.split(" ")
		sentence_array.erase("")
		
		var suggestions:Array
		for word in sentence_array:
			if spell_checker.spell(word):
				pass
				#suggestions.append({"correct":true, "word": word,"suggestion":""})
			else:
				suggestions.append({"correct":false, "word" : word, "suggestion": spell_checker.suggest(word)})
		return suggestions
