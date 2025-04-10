extends Window

signal update_theme(theme)
signal reset_timer()
signal set_window()
signal set_layout(new_layout:String)
@export var dark_theme:Theme
@export var light_theme:Theme

var configdata:ConfigData = ConfigData.new()

const ADDED_WORD_SCENE = preload("res://added_word.tscn")
@onready var new_word_line_edit: LineEdit = $ScrollContainer/VBoxContainer/DictionaryButton/Window/WordContainer/HBoxContainer/NewWordLineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	if ResourceLoader.exists(configdata.config_path):
		configdata = ConfigData._load()
		_on_theme_option_item_selected(configdata.theme)
	
	if !configdata.autoOpen:
		configdata.save_path = ""
	if Settings.configdata.layout == "Vertical":
		%Layout.select(1)
	%AutoSaveCheckBox.button_pressed = configdata.autosave
	%AutoSaveSpinBox.value = configdata.interval
	%AutoOpen.button_pressed = configdata.autoOpen
	%PopoutCheckBox.button_pressed = configdata.popout
	%ExportCharWithStory.button_pressed = configdata.export_char_with_story
	
	await get_tree().process_frame
	_load_words()
	
	
	
func _load_words():
	for word in configdata.custom_words:
		_spawn_word(word,true)
		
		
func _load_defaults():
	pass
func _on_theme_option_item_selected(index):
	var new_theme
	configdata.theme = index
	match index:
		0: #dark
			new_theme = dark_theme
		1: #light
			new_theme = light_theme
			
	update_theme.emit(new_theme)




func _on_close_requested():
	hide()


func _on_export_option_item_selected(index):
	match index:
		0:#godot
			configdata.export = "godot"
		1:#RPG Maker MZ
			configdata.export = "rpgmz"
		2:#Unity TMP
			configdata.export = "unitytmp"


func _save_config():
	configdata._save()


func _on_autosave_toggled(toggled_on):
	configdata.autosave = toggled_on
	if toggled_on:
		reset_timer.emit()
	_save_config()

func _on_spin_box_value_changed(value):
	configdata.interval = value
	_save_config()

func _on_auto_open_toggled(toggled_on):
	configdata.autoOpen = toggled_on
	_save_config()
func _set_save(path):
	#global and last save path
	Globals.file_name = path
	configdata.last_save_path = path
	_save_config()

func _on_popout_check_box_toggled(toggled_on):
	configdata.popout = toggled_on
	set_window.emit()
	_save_config()


func _on_layout_item_selected(index):
	match index:
		0:
			configdata.layout = "Horizontal"
			set_layout.emit("Horizontal")
		1:
			configdata.layout = "Vertical"
			set_layout.emit("Vertical")
	_save_config()


func _on_export_char_with_story_toggled(toggled_on):
	configdata.export_char_with_story = toggled_on
	_save_config()


func _on_size_option_item_selected(index):
	match index:
		0: #medium
			for scene:Scene in get_tree().get_nodes_in_group("scenes"):
				scene._medium()
			for chapter:Chapter in get_tree().get_nodes_in_group("chapters"):
				chapter._medium()
		1: #slim
			for scene:Scene in get_tree().get_nodes_in_group("scenes"):
				scene._slim()
			for chapter:Chapter in get_tree().get_nodes_in_group("chapters"):
				chapter._medium()
func _remove_word(word:String):
	configdata.custom_words.erase(word)
	Globals.spell_checker.remove_word(word)

func _spawn_word(word:String,loading:bool=false):
	if configdata.custom_words.has(word) and !loading:
		return
	Globals.spell_checker.add_word(word)
	var new_word = ADDED_WORD_SCENE.instantiate()
	new_word.update_words.connect(_remove_word)
	$ScrollContainer/VBoxContainer/DictionaryButton/Window/WordContainer.add_child(new_word)
	new_word.word_label.text = word
	
	if !loading:
		configdata.custom_words.append(word)


func _on_add_word_button_button_down() -> void:
	_spawn_word(new_word_line_edit.text)
	new_word_line_edit.text = ""
