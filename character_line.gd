extends HBoxContainer

var character:String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _assign_character(new_character:String):
	$LineEdit.text = new_character
	character = new_character

func _on_edit_button_down():
	$Save.show()
	$LineEdit.editable = true



func _on_save_button_down():
	Settings.characters.erase(character)
	character = $LineEdit.text
	Settings.characters.append(character)
	$Save.hide()
	$LineEdit.editable = false


func _on_delete_button_down():
	Settings.characters.erase(character)
	queue_free()
