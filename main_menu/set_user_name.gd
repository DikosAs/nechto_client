extends "res://base_scripts/menu.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()
	set_bg_img(get_node('BG'))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func _on_set_username_pressed() -> void:
	config['username'] = str($GUI/NameInput.text).replace(' ', '_')
	if config['username'] == '':
		config['username'] == 'user'
	wright_json_data(
		'res://data/configs.json',
		config
	)
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
