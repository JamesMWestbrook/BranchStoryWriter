extends Control

var following = false
var dragging_start_position = Vector2()


signal save
signal save_as
signal save_and_quit
signal quit_no_save
signal open_file
@onready var ExportDialog = $ExportFileDialog
@onready var ExportHtmlDialog = $ExportHTMLFileDialog
@onready var export_csv_file_dialog: FileDialog = $ExportCSVFileDialog

func _process(_delta):
	#if following:
		#DisplayServer.window_set_position(
			#Vector2(DisplayServer.window_get_position()) + get_global_mouse_position()
			#- dragging_start_position
		#)
	pass


func _on_close_button_down():
	get_tree().quit()


func _on_settings_button_down():
	Settings.show()


func _on_menu_button_button_down():
	var popup:PopupMenu = $HBoxContainer/MenuButton.get_popup()
	if !popup.id_pressed.is_connected(_file_option_chosen):
		popup.id_pressed.connect(_file_option_chosen)

func _file_option_chosen(id:int):
	match id:
		0: #save
			save.emit()
		1: #save as
			save_as.emit()
		2: #Save and Quit
			save_and_quit.emit()
		3: #save without quitting
			quit_no_save.emit()
		4:
			open_file.emit()
		5:#new file
			clear()
			LUtil.ClearChildren(%GraphEdit)
			LUtil.ClearChildren($HBoxContainer/Characters/Window.CharacterList)
			#each object needs its own clear method for clarity/ease sake
			#word count
			#title
		6:#export txt
			print(Globals.export_folder.get_file())
			
			if Globals.export_folder.is_empty():
				Globals.set_export_path()
			var file_name:String = Globals.file_name.get_file()
			#var file_name:String = Globals.export_folder.get_file()
			file_name = file_name.replace(".tres","")
			ExportDialog.current_dir = Globals.export_folder
			ExportDialog.current_file = file_name
			ExportDialog.show()
		7:#export html
			if Globals.export_folder.is_empty():
				Globals.set_export_path()
			var file_name:String = Globals.file_name.get_file()
			file_name = file_name.replace(".tres","")
			ExportHtmlDialog.current_dir = Globals.export_folder
			ExportHtmlDialog.current_file = file_name
			ExportHtmlDialog.show()
		8: #export csv
			if Globals.export_folder.is_empty():
				Globals.set_export_path()
			var file_name:String = Globals.file_name.get_file()
			file_name = file_name.replace(".tres","")
			export_csv_file_dialog.current_dir = Globals.export_folder
			export_csv_file_dialog.current_file = file_name
			export_csv_file_dialog.show()
			
			
func clear():
	Globals.clear()
	Settings.configdata.last_save_path = ""
	
	
func _export_project():
	var file_name = Settings.configdata.last_save_path.get_file()
	file_name = file_name.replace(".tres","")
	var export:String = file_name + "\n"
	
	if Settings.configdata.export_char_with_story:
		export += Main._characters_to_text()
	for chapter:Chapter in $"../SplitContainer/ChapterScroll/ChapterSection/ChapterContainer".get_children():
		export += chapter._export_chapter()
	
	return export
func _export_html():
	var file_name = Settings.configdata.last_save_path.get_file()
	file_name = file_name.replace(".tres","")
	var export:String = "<!DOCTYPE html><body>"
	
	#export each chapter
	for chapter:Chapter in $"../SplitContainer/ChapterScroll/ChapterSection/ChapterContainer".get_children():
		export += chapter._export_chapter_html()
	#export characters 
	if Settings.configdata.export_char_with_story:
		export += Main._characters_to_text_html()
	export += "</body></html>"
	return export
func _on_export_file_dialog_file_selected(path):
	Globals.export_folder = path.get_base_dir()
	var export:String = _export_project()
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(export)
	OS.shell_open(path.get_base_dir())
	Globals.new_export_path(path)

func _on_export_file_html_selected(path):
	Globals.export_folder = path.get_base_dir()
	var export:String = _export_html()
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(export)
	OS.shell_open(path.get_base_dir())
	Globals.new_export_path(path)
	
	
func _on_clear_debug_button_down():
	Globals.export_folder = ""
