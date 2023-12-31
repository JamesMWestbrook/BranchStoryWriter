extends RichTextLabel
@export var Edit:Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_edit_text_changed():
	_change_text()

func _on_line_edit_text_changed(new_text):
	_change_text()

func _change_text():
	text = Edit.text
