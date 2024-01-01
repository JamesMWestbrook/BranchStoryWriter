extends VBoxContainer

@export var graph_node:PackedScene
var initial_position = Vector2(40,40)
var node_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	var node:GraphNode = graph_node.instantiate()
	node.position_offset  = $GraphEdit.scroll_offset / $GraphEdit.zoom
	$GraphEdit.add_child(node)
	node_index += 1


func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.connect_node(from_node, from_port, to_node, to_port)


func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_list_button_down():
	var list = $GraphEdit.get_connection_list()
	print(list)


func _on_save_button_down():
	var data = SaveData.new()
	data.node_connections = $GraphEdit.get_connection_list()
	
	for child in $GraphEdit.get_children():
		if child is GraphNode:
			data._create_scene(child)
	data.save()


func _on_load_button_down():
	for child in $GraphEdit.get_children():
		child.queue_free()
	var data = SaveData.load()
	for child in data.all_nodes:
		child.name.replace("@","_")
		var node:GraphNode = graph_node.instantiate()
		$GraphEdit.add_child(node)
		node.name = child.name
		node.title = child.title
		node.get_node("TextEdit").text = child.title
		node._on_write_button_down()
		node.get_node("Window").hide()
		for dialog in child.dialogs:
			node.get_node("Window")._create_dialog(null,true,true,dialog)
	for conn in data.node_connections:
		conn.from_node = conn.from_node.replace("@","_")
		conn.to_node = conn.to_node.replace("@","_")
		$GraphEdit.connect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
	$GraphEdit.arrange_nodes()
		
func _on_select_all_button_down():
	$GraphEdit.arrange_nodes()
	#for child in $GraphEdit.get_children():
		#$GraphEdit.set_selected(child)
