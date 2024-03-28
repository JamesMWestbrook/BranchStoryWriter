extends Node
class_name Globals

static var main:Main
static var WritingPanel
static var Loading:bool
static var export_path:String

static func new_export_path(path:String):
	Globals.export_path = path.get_base_dir()

static func set_my_documents():
	var path:String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/BranchWriter"
	var dir = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	if !dir.dir_exists("BranchWriter"):
		dir.make_dir(path)
	else:
		pass
	Globals.export_path = path

