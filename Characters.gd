extends Window
class_name CharacterWindow
@export var CharLine:PackedScene
@export var CharacterList: VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	pass # Replace with function body.

func _on_add_character_button_down():
	_on_line_edit_text_submitted($VBoxContainer/HBoxContainer/LineEdit.text)

func _on_line_edit_text_submitted(new_text):
	$VBoxContainer/HBoxContainer/LineEdit.text = ""
	if Settings.characters.has(new_text):
		return
	else:
		var new_char = CharacterLine.character(new_text)
		Settings.characters.append(new_char)
		_add_item(new_char)

func _generate_list():
	for child in CharacterList.get_children():
		child.queue_free()
	for person in Settings.characters:
		_add_item(person)

func _add_item(person):
		Settings.character_count += 1
		var new_index = Settings.character_count - 1
		var new_line:CharacterLine = CharLine.instantiate()
		CharacterList.add_child(new_line)
		new_line._assign_character(person)
		new_line.index = new_index
		new_line.fixIndex.connect(_fix_index)

func _on_close_requested():
	hide()

func _fix_index(index_removed):
	for line in CharacterList.get_children():
		if line.index > index_removed:
			line.index -= 1
