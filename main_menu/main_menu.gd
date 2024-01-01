extends "res://base_scripts/menu.gd"


func _ready() -> void:
	load_config()
	
	if config['username'] == '':
		get_tree().change_scene_to_file('res://main_menu/set_user_name.tscn')
	else:
		$GUI/UserName.text = config['username']
	
	set_bg_img(get_node('BG'))


func _process(delta) -> void:
	pass


func _on_set_username_pressed() -> void:
	get_tree().change_scene_to_file('res://main_menu/set_user_name.tscn')


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game_select_menu/game_select_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://settings_menu/settings_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
