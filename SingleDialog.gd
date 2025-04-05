extends VBoxContainer
class_name SingleDialog
signal changed_dialog()
signal deleted()
signal import()
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

@onready var suggestions_label: Label = $HBoxContainer4/SuggestionsLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_speaker_edit_text_changed(new_text,loading:bool = false):
	speaker = new_text
	if !loading:
		changed_dialog.emit()


func _on_dialog_edit_text_changed(loading:bool = false):
	dialog = dialog_edit.text
	if !loading:
		changed_dialog.emit()

func _input(event):
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_C and event.ctrl_pressed:
			if speaker_edit.has_focus():
				dialog_edit.grab_focus()
			if dialog_edit.has_focus():
				if comment:
					_reverse_comment()
				elif !comment:
					_turn_comment()
	
	
	#get_viewport().set_input_as_handled()
func _on_gui_input(event):

		
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			0:
				pass
				# left button clicked
			2: #right click
				$PopupMenu.show()
	#			$PopupMenu.position = get_viewport().get_mouse_position()
				$PopupMenu.position = DisplayServer.mouse_get_position()


func _on_popup_menu_id_pressed(id):
	match id:
		0: #turn into comment
			_turn_comment()
		1: #turn back into dialog
			_reverse_comment()
		2: #delete
			_on_delete_button_down()
		3: #import via paste
			import.emit()
func _turn_comment(loading:bool = false):
	comment = true
	$PopupMenu.set_item_disabled(0,true)
	$PopupMenu.set_item_disabled(1,false)
	theme = comment_theme_dark
	
	speaker_edit.hide()
	speaker_richtext.hide()
	speaker_button.hide()
	dialog_richtext.hide()
	if !loading:
		changed_dialog.emit()
		dialog_edit.grab_focus()
	
func _reverse_comment():
	comment = false
	$PopupMenu.set_item_disabled(1,true)
	$PopupMenu.set_item_disabled(0,false)
	theme = null

	speaker_edit.show()
	speaker_richtext.show()
	speaker_button.show()
	dialog_richtext.show()
	changed_dialog.emit()


func _on_speaker_copy_button_down():
	DisplayServer.clipboard_set(_convert(speaker))


func _on_dialog_copy_button_down():
	DisplayServer.clipboard_set(_convert(dialog))

func _convert(text:String):
	var new_string = text
	for conv in Main.conversions:
		if new_string.contains(conv):
			new_string = new_string.replace(conv,Main.conversions[conv])
	return new_string
	
func _set_text(set_speaker:String,set_dialog:String,loading:bool = false):
	speaker_edit.text = set_speaker
	dialog_edit.text = set_dialog
	speaker_richtext.text = set_speaker
	$HBoxContainer2/RichTextLabel.text = set_dialog
	_on_speaker_edit_text_changed(set_speaker,loading)
	_on_dialog_edit_text_changed(loading)
	$HBoxContainer2/RichTextLabel._change_text()

func _on_delete_button_down():
	deleted.emit()
	queue_free()
	
func _show_suggestion(suggestion_list:Array):
	if comment:
		return
	suggestions_label.text = ""
	for suggestion in suggestion_list:
		if suggestion.correct:
			continue
		suggestions_label.text += ("Could not recognize the word \"" + suggestion.word + "\". Possible alternatives are: " + str(suggestion.suggestion))
	
