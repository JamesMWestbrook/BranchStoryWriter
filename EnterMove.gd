extends LineEdit

@export var NextNode:Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_text_submitted(new_text):
	NextNode.grab_focus()
	


func _on_gui_input(event):
	if Input.is_action_just_pressed("Tab") and has_focus():
		$"../RichTextLabel"._on_line_edit_text_submitted(text)
		
