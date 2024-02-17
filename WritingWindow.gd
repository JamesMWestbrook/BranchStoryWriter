extends Control
@export var Dialog: PackedScene
var scene_title:String
var all_dialog: Array[Dictionary]
var word_count

signal updated_dialog(scene:Array[Dictionary])
signal reassigned()

var Scroll:ScrollContainer
var VBox:VBoxContainer
@export var ScrollPath:NodePath
@export var VBoxName:String
# Called when the node enters the scene tree for the first time.
func _ready():
	Scroll = get_node(ScrollPath)
	VBox = get_node(VBoxName)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func _load_dialog(scene: Array[Dictionary]):
	all_dialog = scene.duplicate()
	if !all_dialog.is_empty():
		for dialog in all_dialog:
			_create_dialog(null,true,true,dialog)
			
	else:
		_create_dialog(null,true)
	
	
func _create_dialog(node, first=false, loading = false, data = {}):
	var dialog = Dialog.instantiate()
	var separator = HSeparator.new()
	if first:
		VBox.add_child(dialog)
		VBox.add_child(separator)
	else:
		node.add_sibling(dialog)
		node.add_sibling(separator)
	dialog.get_node("HBoxContainer2/TextEdit").create_dialog.connect(_create_dialog.bind(dialog))
	dialog.changed_dialog.connect(_update_scene_data)
	dialog.deleted.connect(_on_dialog_delete)
	await get_tree().process_frame
	Scroll.ensure_control_visible(dialog.get_node("HBoxContainer2/DialogCopy"))
	dialog.get_node("HBoxContainer/LineEdit").grab_focus()
	if loading:
		if data:
			dialog._set_text(data.speaker,data.dialog,true)


func _on_button_button_down():
	pass # Replace with function body.
	
	
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
	word_count = 0
	for i in all_dialog:
		var dialog:String = i.dialog.replacen(".","")
		word_count += dialog.split(" ", false).size()
	#title = scene_title + " | Word Count: " + str(word_count)
	updated_dialog.emit(all_dialog)

func _on_close_requested():
	hide()

func _on_dialog_delete():
	await get_tree().process_frame
	_update_scene_data()

func _clear():
	LemonUtils.ClearSignals(updated_dialog)
	reassigned.emit()
	LemonUtils.ClearSignals(reassigned)
	LemonUtils.ClearChildren(VBox)
	all_dialog.clear()

