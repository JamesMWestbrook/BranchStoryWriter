extends BoxContainer
class_name Chapter

var title:String
@onready var scene_file = load("res://Scene.tscn")
@onready var SceneContainer = $Scenes/Panel/SceneContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_add_scene_right_button_down(null,false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_scene_right_button_down(prev_scene, data): #false data = brand new
	var new_scene:Scene = scene_file.instantiate()
	if is_instance_valid(prev_scene):
		prev_scene.add_sibling(new_scene)
	else:
		SceneContainer.add_child(new_scene)
		
	new_scene.AddSceneRight.button_down.connect(_on_add_scene_right_button_down.bind(new_scene,true))
	
#on load
	if data:
		pass
	
