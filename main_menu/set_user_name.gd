extends Control


var config: Dictionary


func _ready() -> void:
	config = base_func.load_config()
	base_func.set_bg_img(get_node('BG'))


func _on_set_username_pressed() -> void:
	if str(config['username']).is_empty() or str(config['username']).replace(' ', '').is_empty():
		config['username'] == 'user'
	else:
		config['username'] = str($GUI/NameInput.text).replace(' ', '_')
	base_func.wright_json_data(
		'res://data/configs.json',
		config
	)
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
