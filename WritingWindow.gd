extends Window
@export var Dialog: PackedScene

var all_dialog: Array[Dictionary]
signal updated_dialog()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _create_dialog(node, first=false, loading = false, data = {}):
	var dialog = Dialog.instantiate()
	var separator = HSeparator.new()
	if first:
		$ScrollContainer/VBoxContainer.add_child(dialog)
		$ScrollContainer/VBoxContainer.add_child(separator)
	else:
		node.add_sibling(dialog)
		node.add_sibling(separator)
	dialog.get_node("HBoxContainer2/TextEdit").create_dialog.connect(_create_dialog.bind(dialog))
	dialog.changed_dialog.connect(_update_scene_data)
	dialog.tree_exited.connect(_update_scene_data)
	await get_tree().process_frame
	$ScrollContainer.ensure_control_visible(dialog.get_node("HBoxContainer2/DialogCopy"))
	dialog.get_node("HBoxContainer/LineEdit").grab_focus()
	if loading:
		if data:
			dialog._set_text(data.speaker,data.dialog)


func _on_button_button_down():
	pass # Replace with function body.
	
	
func _update_scene_data():
	all_dialog.clear()
	for child in $ScrollContainer/VBoxContainer.get_children():
		if child is SingleDialog:
			var new_dialog = {
				"speaker": child.speaker,
				"dialog": child.dialog,
				"comment": child.comment
			}
			all_dialog.append(new_dialog)
	updated_dialog.emit()

func _on_close_requested():
	hide()
