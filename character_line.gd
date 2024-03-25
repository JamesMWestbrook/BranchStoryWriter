extends BoxContainer

@onready var NameEdit = $HBoxContainer/LineEdit
@onready var Save = $HBoxContainer/Save
@onready var Desc = $TextEdit
var character:String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _assign_character(new_character:String):
	NameEdit.text = new_character
	character = new_character

func _on_edit_button_down():
	Save.show()
	NameEdit.editable = true



func _on_save_button_down():
	Settings.characters.erase(character)
	character = NameEdit.text
	Settings.characters.append(character)
	Save.hide()
	NameEdit.editable = false


func _on_delete_button_down():
	Settings.characters.erase(character)
	queue_free()


func _on_expand_button_down():
	Desc.visible = !Desc.visible
