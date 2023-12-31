extends Window
@export var Dialog: PackedScene

var all_dialog: Dictionary = {
	"dialog":[]
}
# Called when the node enters the scene tree for the first time.
func _ready():
	var dialog = Dialog.instantiate()
	dialog.name = "Dialog"
	var separator = HSeparator.new()
	$ScrollContainer/VBoxContainer.add_child(dialog)
	$ScrollContainer/VBoxContainer.add_child(separator)
	dialog.get_node("HBoxContainer2/TextEdit").create_dialog.connect(_create_dialog.bind(dialog))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_size_changed():
	print(size)
	
func _create_dialog(node):
	var dialog = Dialog.instantiate()
	var separator = HSeparator.new()
	node.add_sibling(dialog)
	node.add_sibling(separator)
	dialog.get_node("HBoxContainer2/TextEdit").create_dialog.connect(_create_dialog.bind(dialog))
#


func _on_button_button_down():
	pass # Replace with function body.
