extends Control


func _ready():
	base_func.set_bg_img($BG)


func _on_timer_timeout():
	base_func.set_bg_img($BG)
