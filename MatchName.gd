extends RichTextLabel

@export var matchMe: Control
# Called when the node enters the scene tree for the first time.
var has_match:bool
func _ready():
	pass # Replace with function body.

func _on_line_edit_text_changed(new_text):
	
	var has_true:bool
	for i:Dictionary in Settings.characters:
		if i.name.to_lower().contains(new_text.to_lower()):
			text = i.name
			has_true = true
	has_match = has_true
	if !has_true:
		text = $"../LineEdit".text




func _on_line_edit_text_submitted(_new_text):
	if has_match:
		$"../LineEdit".text = text
		$"../.."._on_speaker_edit_text_changed(text)
