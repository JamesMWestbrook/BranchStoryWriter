extends Window
class_name Conversion
@onready var conversion_scene:PackedScene = load("res://conversion_line.tscn")
@onready var conversion_parent:VBoxContainer = $VBoxContainer/VBoxContainer

static var main:Conversion
func _ready():
	main = self
	
func _on_add_button_down():
	add_conversion_line()


func add_conversion_line(from:String = "",to:String = ""):
	var conversion:ConversionLine = conversion_scene.instantiate()
	conversion_parent.add_child(conversion)
	conversion.From.text = from
	conversion.To.text = to
