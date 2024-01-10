extends VBoxContainer

@export var graph_node:PackedScene
var initial_position = Vector2(40,40)
var node_index = 0

var time_left:float
# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = 666
	Settings.update_theme.connect(_update_theme) 
	await get_tree().create_timer(0.01).timeout
	if Settings.configdata.autoOpen and Settings.configdata.save_path != "":
		_on_load_button_down()
	if Settings.configdata.autosave:
		time_left = Settings.configdata.interval
	Settings.reset_timer.connect(_reset_time_left)
	_reset_time_left()

func _process(delta):
	if Input.is_action_just_pressed("SaveAs"):
		$TitleBar/SaveFile.show()
	elif Input.is_action_just_pressed("Save"):
		_on_save_button_down()	
	elif Input.is_action_just_pressed("Open"):
		_on_title_bar_open_file()
	
	if Settings.configdata.autosave:
		time_left -= delta
		if time_left <= 0:
			_save()
			_reset_time_left()
func _reset_time_left():
	time_left = Settings.configdata.interval * 60
func _on_button_button_down():
	var node:GraphNode = graph_node.instantiate()
	node.position_offset  = $GraphEdit.scroll_offset / $GraphEdit.zoom
	$GraphEdit.add_child(node)
	#node.get_node("Delete/ConfirmationDialog").confirmed.connect(_remove_node.bind(node))
	node_index += 1
	

func _remove_node(node:GraphNode):
	var _name = node.name
	var list = $GraphEdit.get_connection_list()
	pass
func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.connect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_list_button_down():
	var list = $GraphEdit.get_connection_list()
	print(list)


func _on_save_button_down():
	if Settings.configdata.save_path == "":
		$TitleBar/SaveNamePopup.show()
	else:
		_save()
		
func _save():
	var data = SaveData.new()
	data.node_connections = $GraphEdit.get_connection_list()
	for child in $GraphEdit.get_children():
		if child is GraphNode:
			data._create_scene(child)
	
	data.characters = Settings.characters
		
	data.save(Settings.configdata.save_path)
	Settings.configdata._save()
	$TitleBar/SavedNotifyPanel.show()
	await get_tree().create_timer(2).timeout
	$TitleBar/SavedNotifyPanel.hide()

func _on_load_button_down():
	for child in $GraphEdit.get_children():
		child.queue_free()
	var data = SaveData.load(Settings.configdata.save_path)
	for child in data.all_nodes:
		child.name.replace("@","_")
		var node:GraphNode = graph_node.instantiate()
		$GraphEdit.add_child(node)
		node.name = child.name
		node.title = child.title
		node.scene_desc_edit.text = child.description
		node.title_edit.text = child.title
		node._on_write_button_down(true)
		node.active_window.hide()
		if !child.dialogs.is_empty():
			for dialog in child.dialogs:
				node.active_window._create_dialog(null,true,true,dialog)
		else:
				node.active_window._create_dialog(null,true)
	for conn in data.node_connections:
		conn.from_node = conn.from_node.replace("@","_")
		conn.to_node = conn.to_node.replace("@","_")
		$GraphEdit.connect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
	
	Settings.characters = data.characters
	$TitleBar/HBoxContainer/Characters/Window._generate_list()
	$GraphEdit.arrange_nodes()
		
func _on_select_all_button_down():
	$GraphEdit.arrange_nodes()
	
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

