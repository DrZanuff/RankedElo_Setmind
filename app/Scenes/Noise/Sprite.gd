extends Sprite


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		texture.get_data().save_png("res://fog.png")
