extends HBoxContainer
class_name AddedWord
@onready var word_label: Label = $Label

signal update_words(word)

func _on_delete_button_button_down() -> void:
	update_words.emit(word_label.text)
	await get_tree().process_frame
	queue_free()
