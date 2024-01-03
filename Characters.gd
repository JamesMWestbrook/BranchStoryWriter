extends Window

@export var CharacterLine:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_add_character_button_down():
	_on_line_edit_text_submitted($VBoxContainer/HBoxContainer/LineEdit.text)

func _on_line_edit_text_submitted(new_text):
	$VBoxContainer/HBoxContainer/LineEdit.text = ""
	if Settings.characters.has(new_text):
		return
	else:
		Settings.characters.append(new_text)
		_add_item(new_text)

func _generate_list():
	for child in $VBoxContainer/ScrollContainer/Characters.get_children():
		child.queue_free()
	for person in Settings.characters:
		_add_item(person)

func _add_item(person):
		var new_line = CharacterLine.instantiate()
		$VBoxContainer/ScrollContainer/Characters.add_child(new_line)
		new_line._assign_character(person)


func _on_close_requested():
	hide()
