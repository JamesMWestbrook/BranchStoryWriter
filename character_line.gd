extends BoxContainer
class_name CharacterLine
var index:int
@onready var NameEdit = $HBoxContainer/LineEdit
@onready var Save = $HBoxContainer/Save
@onready var Desc = $TextEdit

signal fixIndex(index_removed)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _assign_character(new_character:Dictionary):
	NameEdit.text = new_character.name
	Desc.text = new_character.desc
	if new_character.expand:
		Desc.show()

func _on_edit_button_down():
	Save.show()
	NameEdit.editable = true



func _on_save_button_down():
	var new_char = character( NameEdit.text,Desc.text,Desc.visible)
	#var new_char = {
		#"name" : NameEdit.text,
		#"desc" : Desc.text,
		#"expand" : Desc.visible
	#}
	#Settings.characters.erase(character)
	#Settings.characters.append(character)
	Save.hide()
	NameEdit.editable = false
	Settings.characters[index] = new_char

func _on_delete_button_down():
	Settings.characters.remove_at(index)
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
