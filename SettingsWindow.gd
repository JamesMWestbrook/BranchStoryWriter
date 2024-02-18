extends Window

signal update_theme(theme)
signal reset_timer()
signal set_window()
signal set_layout(new_layout:String)
@export var dark_theme:Theme
@export var light_theme:Theme

var configdata:ConfigData = ConfigData.new()

var characters:Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	if ResourceLoader.exists(configdata.config_path):
		configdata = ConfigData._load()
		_on_theme_option_item_selected(configdata.theme)
	
	if !configdata.autoOpen:
		configdata.save_path = ""
	
	$VBoxContainer/HBoxContainer3/CheckBox.button_pressed = configdata.autosave
	$VBoxContainer/HBoxContainer3/SpinBox.value = configdata.interval
	$VBoxContainer/AutoOpen.button_pressed = configdata.autoOpen
	%PopoutCheckBox.button_pressed = configdata.popout
	
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
	configdata.save_path = path
	_save_config()

func _on_popout_check_box_toggled(toggled_on):
	configdata.popout = toggled_on
	set_window.emit()
	_save_config()


func _on_layout_item_selected(index):
	match index:
		0:
			set_layout.emit("Horizontal")
		1:
			set_layout.emit("Vertical")
	_save_config()
