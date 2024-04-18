extends HBoxContainer
class_name ConversionLine
var former_from:String
@onready var From:LineEdit = $From
@onready var To:LineEdit = $To



func _on_confirmation_dialog_confirmed():
	Main.conversions.erase(From.text)
	queue_free()


func _replace():
	if former_from.is_empty():
		former_from = From.text
	Main.conversions.erase(former_from)
	Main.conversions[From.text] = To.text
	print(Main.conversions)
	former_from = From.text


func _on_to_text_changed(new_text):
	_replace()


func _on_from_text_changed(new_text):
	_replace()
