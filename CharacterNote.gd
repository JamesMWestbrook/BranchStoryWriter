extends HBoxContainer
@export var character_line:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_edit_text_submitted(new_text):
	var new_char = character_line.instantiate()
	$"../Characters".add_child(new_char)
	new_char.get_node("LineEdit").text = new_text
	$LineEdit.text = ""


func _on_add_character_button_down():
	_on_line_edit_text_submitted($LineEdit.text)
