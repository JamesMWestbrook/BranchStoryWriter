extends Control
@export var Dialog: PackedScene
var scene_title:String
var all_dialog: Array[Dictionary]
var word_count

signal updated_dialog(scene:Array[Dictionary])
signal reassigned()

var Scroll:ScrollContainer
var VBox:VBoxContainer
var WordLabel:Label
@export var ScrollPath:NodePath
@export var VBoxName:String
@export var WordLabelPath:NodePath
# Called when the node enters the scene tree for the first time.
func _ready():
	Scroll = get_node(ScrollPath)
	VBox = get_node(VBoxName)
	WordLabel = get_node(WordLabelPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func _load_dialog(scene: Array[Dictionary]):
	all_dialog = scene.duplicate()
	if !all_dialog.is_empty(): #has a scene
		for dialog in all_dialog:
			_create_dialog(null,true,true,dialog)
			
	else: #empty scene
		_create_dialog(null,true)
		var dialog = VBox.get_child(0)
		dialog.speaker_edit.grab_focus()
	
func _create_dialog(node, first=false, loading = false, data = {}):
	var dialog = Dialog.instantiate()
	if first:
		VBox.add_child(dialog)
	else:
		node.add_sibling(dialog)
	dialog.get_node("HBoxContainer2/TextEdit").create_dialog.connect(_create_dialog.bind(dialog))
	dialog.changed_dialog.connect(_update_scene_data)
	dialog.deleted.connect(_on_dialog_delete)
	await get_tree().process_frame
	Scroll.ensure_control_visible(dialog.get_node("HBoxContainer2/DialogCopy"))
	dialog.get_node("HBoxContainer/LineEdit").grab_focus()
	dialog.import.connect(_import.bind(dialog))
	if loading:
		if data:
			dialog._set_text(data.speaker,data.dialog,true)
			if data.has("comment") and data.comment:
				dialog._turn_comment()

func _on_button_button_down():
	pass # Replace with function body.

enum TYPE {PANEL, WINDOW}
@export var type:TYPE
func _set_title(new_title):
	match type:
		TYPE.WINDOW:
			$"../..".title = new_title
		TYPE.PANEL:
			$VBoxContainer/Title.text = new_title
			
			
func _set_word_count(new_count):
	WordLabel.text = "Word Count: " + str(new_count)
	
	
func _update_scene_data():
	all_dialog.clear()
	for child in VBox.get_children():
		if child is SingleDialog:
			var new_dialog = {
				"speaker": child.speaker,
				"dialog": child.dialog,
				"comment": child.comment
			}
			all_dialog.append(new_dialog)

	#title = scene_title + " | Word Count: " + str(word_count)
	updated_dialog.emit(all_dialog)

func _on_close_requested():
	hide()

func _on_dialog_delete():
	await get_tree().process_frame
	_update_scene_data()

func _clear():
	LUtil.ClearSignals(updated_dialog)
	reassigned.emit()
	LUtil.ClearSignals(reassigned)
	LUtil.ClearChildren(VBox)
	LUtil.ClearChildren(Globals.WritingPanel.VBox)
	all_dialog.clear()
	
func _import(dialog:SingleDialog):
	var index = dialog.get_index()
	var text:String = DisplayServer.clipboard_get()
	
	var scene:Array = text.split("\n")
	print(scene)
	for i in range(0,scene.size() - 1, 2):
		print(scene[i])
		print(scene[i + 1])
		var data:Dictionary = {
			"speaker": scene[i],
			"dialog": scene[i+1]
			}
		_create_dialog(null,true, true,data)
	#while !text.is_empty():
