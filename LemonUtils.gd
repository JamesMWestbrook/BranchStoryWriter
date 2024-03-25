extends Node
class_name LUtil


static func ClearChildren(node:Node):
	for child in node.get_children():
		child.queue_free()


static func ClearSignals(sig:Signal):
	for c in sig.get_connections():
		sig.disconnect(c.callable)
