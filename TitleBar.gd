extends Control

var following = false
var dragging_start_position = Vector2()


signal save
signal save_as
signal save_and_quit
signal quit_no_save
signal open_file

func _process(_delta):
	#if following:
		#DisplayServer.window_set_position(
			#Vector2(DisplayServer.window_get_position()) + get_global_mouse_position()
			#- dragging_start_position
		#)
	pass


func _on_close_button_down():
	get_tree().quit()

func _on_theme_menu_button_down():
	var id = $HBoxContainer/SettingsWindow/VBoxContainer/HBoxContainer/ThemeMenu.get_index()
	print(id)


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
			Settings.configdata.save_path = ""
			Settings.characters.clear()
			LUtil.ClearChildren(%GraphEdit)
			LUtil.ClearChildren($HBoxContainer/Characters/Window.CharacterList)
			LUtil.ClearChildren(Globals.WritingPanel.VBox)
			#each object needs its own clear method for clarity/ease sake
			#word count
			#title
