extends VBoxContainer
class_name Main
static var instance:Main
var initial_position = Vector2(40,40)
var node_index = 0

var save_time_left:float
var second_timer:float
@onready var ChapterContainer: BoxContainer = $SplitContainer/ChapterScroll/ChapterSection/ChapterContainer

@onready var WordCount:Label = $TitleBar/HBoxContainer/WordCount
@onready var TodayWordCount: Label = $TitleBar/HBoxContainer/TodayCount
@onready var GoalLabel: Label = $TitleBar/HBoxContainer/GoalLabel
@onready var EditGoal: LineEdit = $TitleBar/HBoxContainer/EditGoal

@onready var ChapterFile = load("res://chapter.tscn")
@onready var CharWindow:CharacterWindow = $TitleBar/HBoxContainer/Characters/Window

static var character_count:int
static var characters:Array[Dictionary]

static var conversions:Dictionary

var CurrentDailyGoal:int
var history:Dictionary:
	set(value):
		history = value


func Goal(goal:int=0,start_count:int = 0,met:bool=false,date:String=""):
	return {
		"goal":goal,
		"start_count":start_count,
		"word_count":0,
		"met":met,
		"date":date
	}



# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.main = self
	Globals.Loading = true
	save_time_left = 666
	Settings.update_theme.connect(_update_theme) 
	await get_tree().create_timer(0.01).timeout
	if Settings.configdata.autoOpen and Settings.configdata.last_save_path != "":
		_on_load_button_down()
	if Settings.configdata.autosave:
		save_time_left = Settings.configdata.interval
		
	if Settings.configdata.layout == "Vertical":
		%SplitContainer.vertical = true
	if Settings.configdata.default_folder_path.is_empty():
		Globals.set_save_path()
	$TitleBar/OpenFile.current_dir = Settings.configdata.default_folder_path
	$TitleBar/SaveFile.current_dir = Settings.configdata.default_folder_path
	Settings.set_layout.connect(_set_layout)
	Settings.reset_timer.connect(_reset_time_left)
	_reset_time_left()
	await get_tree().create_timer(0.01).timeout
	Globals.Loading = false
	Settings.set_window.connect(_set_window)
	_set_window()
	
	%WritingWindow.hide()
	%WritingPanel.hide()
	var date = Time.get_date_string_from_system()
	if !history.has(date):
		history[date] = (Goal(CurrentDailyGoal,_update_word_count(),false,date))
	else:
		pass
		
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

func clear():
	characters.clear()
	LUtil.ClearChildren(ChapterContainer)
	if is_instance_valid(Globals.WritingPanel):
		LUtil.ClearChildren(Globals.WritingPanel.VBox)
	history.clear()
	$TitleBar/HBoxContainer/WordCount.text = "Word Count: 0"
	TodayWordCount.text = "Today's Word Count: " + str(0)
	TodayWordCount.modulate = Color.WHITE
	
func _reset_time_left():
	save_time_left = Settings.configdata.interval * 60

	

func _remove_node(node:GraphNode):
	var _name = node.name
	var _list = %GraphEdit.get_connection_list()
	
func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	%GraphEdit.connect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	%GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_save_button_down():
	if Globals.file_name == "":
		$TitleBar/SaveNamePopup.show()
		
	else:
		_save()
		
		
func _save():
	var data = SaveData.new()
	
	for chapter in ChapterContainer.get_children():
		if chapter is Chapter:
			data.chapters.append(chapter.save())
	
	data.export_folder = Globals.export_folder
	data.characters = Main.characters
	data.conversions = Main.conversions
	data.GoalHistory = history
	data.CurrentDailyGoal = CurrentDailyGoal
	data.save(Globals.file_name)
	Settings.configdata._save()
	DisplayServer.window_set_title(data.file_name)
	$TitleBar/SavedNotifyPanel.show()
	await get_tree().create_timer(2).timeout
	$TitleBar/SavedNotifyPanel.hide()


func _on_load_button_down():
	clear()
	await get_tree().process_frame
	var data:SaveData = SaveData.load(Settings.configdata.last_save_path)
	DisplayServer.window_set_title(data.file_name)
	for chapter:Dictionary in data.chapters:
		var new_chapter:Chapter = ChapterFile.instantiate()
		ChapterContainer.add_child(new_chapter)
		if !chapter.scenes.is_empty():
			for i in chapter.scenes:
				new_chapter._on_add_scene_right_button_down(null,i)
		#new_chapter._set_word_count()
		new_chapter.AddChapterAfter.button_down.connect(_add_chapter_sibling.bind(new_chapter,false))
		new_chapter.AddChapterBefore.button_down.connect(_add_chapter_sibling.bind(new_chapter,true))
		new_chapter.TitleEdit.text = chapter.title
		new_chapter.update_word_count.connect(_update_word_count)
		new_chapter._get_word_count()
		Globals.export_folder = data.export_folder
	history = data.GoalHistory
	conversions = data.conversions
	print(conversions)
	for conv in conversions:
		Conversion.main.add_conversion_line(conv,conversions[conv])
	CurrentDailyGoal = data.CurrentDailyGoal
	EditGoal.text = str(CurrentDailyGoal)
	Main.characters = data.characters
	CharWindow._generate_list()
	_update_word_count()
	
		
func _on_select_all_button_down():
	%GraphEdit.arrange_nodes()
	
func _update_theme(_theme):
	theme = _theme


func _on_save_file_file_selected(path):
	Globals.file_name = path
	Settings.configdata.last_save_path = path
	Settings.configdata.default_folder_path = path.get_base_dir()
	_save()


func _on_title_bar_open_file():
	$TitleBar/OpenFile.show()


func _on_open_file_file_selected(path):
	Settings._set_save(path)
	_on_load_button_down()


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
	
	
func _add_chapter_sibling(chapter:Chapter,left:bool):
	var index:int = chapter.get_index()
	if !left:
		index += 1
	_add_chapter(index)
	
	
func _add_chapter(index):
	var new_chapter:Chapter = ChapterFile.instantiate()
	ChapterContainer.add_child(new_chapter)
	ChapterContainer.move_child(new_chapter,index)
	new_chapter.update_word_count.connect(_update_word_count)
	new_chapter.AddChapterAfter.button_down.connect(_add_chapter_sibling.bind(new_chapter,false))
	new_chapter.AddChapterBefore.button_down.connect(_add_chapter_sibling.bind(new_chapter,true))


func _update_word_count():
	var new_word_count = 0
	for i in ChapterContainer.get_children():
		if i is Chapter:
			new_word_count += i.word_count
	
	WordCount.text = str(new_word_count) + " Words"
	_update_goal(new_word_count)
	return new_word_count

func _get_today_goal():
	var date = Time.get_date_string_from_system()
	if history.has(date):
		return history[date]
	
func _update_goal(count):
	var today = _get_today_goal()
	if _get_today_goal():
		var start_count:int = _get_today_goal().start_count
		var updated_count:int = count - _get_today_goal().start_count
		today.word_count = updated_count
		TodayWordCount.text = "Today's Word Count: " + str(updated_count)
		if today.word_count >= today.goal:
			today.met = true
			TodayWordCount.modulate = Color.GREEN
		else:
			today.met = false
			TodayWordCount.modulate = Color.WHITE
	

func _on_edit_goal_text_changed(new_text):
	CurrentDailyGoal = int(new_text)
	_get_today_goal().goal = CurrentDailyGoal
