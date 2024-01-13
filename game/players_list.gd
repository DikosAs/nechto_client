extends Control


func _on_mouse_entered():
	position = Vector2(
		position.x - 250,
		position.y
	) 


func _on_mouse_exited():
	position = Vector2(
		position.x + 250,
		position.y
	) 
