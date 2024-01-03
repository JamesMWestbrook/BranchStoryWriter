extends RichTextLabel

@export var matchMe: Control
# Called when the node enters the scene tree for the first time.
var has_match:bool
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_edit_text_changed(new_text):
	
	var has_true:bool
	for i:String in Settings.characters:
		if i.contains(new_text):
			text = i
			has_true = true
	has_match = has_true




func _on_line_edit_text_submitted(new_text):
	if has_match:
		$"../LineEdit".text = text
