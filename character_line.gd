extends BoxContainer
class_name CharacterLine
var index:int
@onready var NameEdit = $HBoxContainer/LineEdit
@onready var Save = $HBoxContainer/Save
@onready var Desc = $TextEdit

signal fixIndex(index_removed)


func _assign_character(new_character:Dictionary):
	NameEdit.text = new_character.name
	Desc.text = new_character.desc
	if new_character.expand:
		Desc.show()

func _on_edit_button_down():
	Save.show()
	NameEdit.editable = true



func _on_save_button_down():
	var new_char = CharacterLine.character( 
		NameEdit.text,
		Desc.text,
		Desc.visible)
	Save.hide()
	NameEdit.editable = false
	Main.characters[index] = new_char

func _on_delete_button_down():
	Main.characters.remove_at(index)
	fixIndex.emit(index)
	queue_free()


func _on_expand_button_down():
	Desc.visible = !Desc.visible
	_on_save_button_down()

func _on_text_edit_text_changed():
	_on_save_button_down()

static func character(new_name:String = "", desc: String = "", expand:bool = false):
	return {
		"name" : new_name,
		"desc" : desc,
		"expand" : expand
	}
