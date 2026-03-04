extends Control

@onready var parent: Control = $"../"




func _on_arrage_up_button_pressed() -> void:
	parent.clickedArrangeUp();


func _on_arrage_down_button_pressed() -> void:
	parent.clickedArrangeDown();
