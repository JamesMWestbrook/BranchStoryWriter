extends VBoxContainer
class_name Main
@export var graph_node:PackedScene
var initial_position = Vector2(40,40)
var node_index = 0

var save_time_left:float
var second_timer:float
@onready var ChapterContainer: BoxContainer = $SplitContainer/ChapterScroll/ChapterSection/ChapterContainer

@onready var WordCount:Label = $TitleBar/WordCount

@onready var ChapterFile = load("res://chapter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.main = self
	Globals.Loading = true
	save_time_left = 666
	Settings.update_theme.connect(_update_theme) 
	await get_tree().create_timer(0.01).timeout
	if Settings.configdata.autoOpen and Settings.configdata.save_path != "":
		_on_load_button_down()
	if Settings.configdata.autosave:
		save_time_left = Settings.configdata.interval
		
	if Settings.configdata.layout == "Vertical":
		%SplitContainer.vertical = true
	Settings.set_layout.connect(_set_layout)
	Settings.reset_timer.connect(_reset_time_left)
	_reset_time_left()
	await get_tree().create_timer(0.01).timeout
	Globals.Loading = false
	Settings.set_window.connect(_set_window)
	_set_window()
	_word_count()
	
	%WritingWindow.hide()
	%WritingPanel.hide()
		
func _process(delta):
	if Input.is_action_just_pressed("SaveAs"):
		$TitleBar/SaveFile.show()
	elif Input.is_action_just_pressed("Save"):
		_on_save_button_down()	
	elif Input.is_action_just_pressed("Open"):
		_on_title_bar_open_file()
	
	if Settings.configdata.autosave:
		save_time_left -= delta
		if save_time_left <= 0:
			_save()
			_reset_time_left()
	second_timer += delta
	if second_timer > 1:
		_word_count()
	
func _reset_time_left():
	save_time_left = Settings.configdata.interval * 60

	

func _remove_node(node:GraphNode):
	var _name = node.name
	var _list = %GraphEdit.get_connection_list()
	
func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	%GraphEdit.connect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	%GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_list_button_down():
	var list = %GraphEdit.get_connection_list()
	print(list)


func _on_save_button_down():
	if Settings.configdata.save_path == "":
		$TitleBar/SaveNamePopup.show()
	else:
		_save()
		
		
func _save():
	var data = SaveData.new()
	
	for chapter in ChapterContainer.get_children():
		if chapter is Chapter:
			data.chapters.append(chapter.save())
	
	
	data.characters = Settings.characters
	data.save(Settings.configdata.save_path)
	Settings.configdata._save()
	DisplayServer.window_set_title(data.file_name)
	$TitleBar/SavedNotifyPanel.show()
	await get_tree().create_timer(2).timeout
	$TitleBar/SavedNotifyPanel.hide()


func _on_load_button_down():
	LemonUtils.ClearChildren(ChapterContainer)
	var data:SaveData = SaveData.load(Settings.configdata.save_path)
	DisplayServer.window_set_title(data.file_name)
	for chapter:Dictionary in data.chapters:
		var new_chapter:Chapter = ChapterFile.instantiate()
		ChapterContainer.add_child(new_chapter)
		new_chapter.title = chapter.title
		if !chapter.scenes.is_empty():
			for i in chapter.scenes:
				new_chapter._on_add_scene_right_button_down(null,i)
		#new_chapter._set_word_count()
		new_chapter.TitleEdit.text = chapter.title
		new_chapter._get_word_count()
	Settings.characters = data.characters
	$TitleBar/HBoxContainer/Characters/Window._generate_list()
	
		
func _on_select_all_button_down():
	%GraphEdit.arrange_nodes()
	
func _update_theme(_theme):
	theme = _theme


func _on_save_file_file_selected(path):
	Settings.configdata.save_path = path
	_save()


func _on_title_bar_open_file():
	$TitleBar/OpenFile.show()


func _on_open_file_file_selected(path):
	Settings._set_save(path)
	_on_load_button_down()


func _on_title_bar_save_and_quit():
	if Settings.configdata.save_path == "":
		$TitleBar/SaveNamePopup.show()
	else:
		_save()
		$TitleBar._on_close_button_down()
func _word_count():
	var count:int = 0
	for child in %GraphEdit.get_children():
		if child is GraphNode:
			var string:String = child.WordCount.text
			string = string.lstrip("Word Count: ")
			var child_count:int = string.to_int()
			count += child_count
	WordCount.text = "Project Word Count: " + str(count)

func _set_window():
	if Settings.configdata.popout:
		Globals.WritingPanel = %WritingWindow/VBoxContainer/Window
		%WritingWindow.show()
		%WritingPanel.hide()
		
	else:
		Globals.WritingPanel = %WritingPanel
		%WritingPanel.show()
		%WritingWindow.hide()
		
func _set_layout(new_layout:String):
	match new_layout:
		"Horizontal":
			%SplitContainer.vertical = false
		"Vertical":
			%SplitContainer.vertical = true


func _on_add_chapter_top_button_down():
	_add_chapter(0)

func _on_add_chapter_bottom_button_down():
	_add_chapter(ChapterContainer.get_child_count())

func _add_chapter(index):
	var new_chapter:Chapter = ChapterFile.instantiate()
	ChapterContainer.add_child(new_chapter)
	ChapterContainer.move_child(new_chapter,index)
