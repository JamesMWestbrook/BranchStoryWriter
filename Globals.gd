extends Node
class_name Globals

static var main:Main
static var WritingPanel
static var Loading:bool
static var export_path:String



static func new_export_path(path:String):
	Globals.export_path = path.get_base_dir()
