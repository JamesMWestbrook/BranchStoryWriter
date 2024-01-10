extends VBoxContainer
class_name SingleDialog
signal changed_dialog()
var speaker:String
var dialog:String


var comment:bool = false

@export var comment_theme_dark:Theme

@onready var speaker_edit = $HBoxContainer/LineEdit
@onready var speaker_richtext = $HBoxContainer/RichTextLabel

@onready var dialog_edit = $HBoxContainer2/TextEdit
@onready var dialog_richtext = $HBoxContainer2/RichTextLabel

@onready var dialog_button = $HBoxContainer2/DialogCopy
@onready var speaker_button = $HBoxContainer/SpeakerCopy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_speaker_edit_text_changed(new_text):
	speaker = new_text
	changed_dialog.emit()


func _on_dialog_edit_text_changed():
	dialog = dialog_edit.text
	changed_dialog.emit()


func _on_gui_input(event):

		
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			0:
				pass
				# left button clicked
			2: #right click
				$PopupMenu.show()
				$PopupMenu.position = get_viewport().get_mouse_position()


func _on_popup_menu_id_pressed(id):
	match id:
		0: #turn into comment
			_turn_comment()
			
		1: #turn back into dialog
			_reverse_comment()


func _turn_comment():
	comment = true
	$PopupMenu.set_item_disabled(0,true)
	$PopupMenu.set_item_disabled(1,false)
	theme = comment_theme_dark
	
	speaker_edit.hide()
	speaker_richtext.hide()
	speaker_button.hide()
	dialog_richtext.hide()
	
func _reverse_comment():
	comment = false
	$PopupMenu.set_item_disabled(1,true)
	$PopupMenu.set_item_disabled(0,false)
	theme = null

	speaker_edit.show()
	speaker_richtext.show()
	speaker_button.show()
	dialog_richtext.show()


func _on_speaker_copy_button_down():
	DisplayServer.clipboard_set(speaker)


func _on_dialog_copy_button_down():
	DisplayServer.clipboard_set(dialog)


func _set_text(set_speaker:String,set_dialog:String):
	speaker_edit.text = set_speaker
	dialog_edit.text = set_dialog
	speaker_richtext.text = set_speaker
	$HBoxContainer2/RichTextLabel.text = set_dialog
	_on_speaker_edit_text_changed(set_speaker)
	_on_dialog_edit_text_changed()
	$HBoxContainer2/RichTextLabel._change_text()

func _on_delete_button_down():
	queue_free()
