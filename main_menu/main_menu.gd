extends Control


var config: Dictionary


func _ready() -> void:
	config = base_func.load_config()
	base_func.set_bg_img(get_node('BG'))
	
	if str(config['username']).is_empty():
		get_tree().change_scene_to_file('res://main_menu/set_user_name.tscn')
	else:
		$GUI/UserName.text = config['username']


func _on_set_username_pressed() -> void:
	get_tree().change_scene_to_file('res://main_menu/set_user_name.tscn')


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game_select_menu/game_select_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://settings_menu/settings_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
