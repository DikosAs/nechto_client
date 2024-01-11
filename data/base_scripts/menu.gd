extends Control


var bg_imgs = [
	preload('res://data/sprites/bg/1.png'),
	preload('res://data/sprites/bg/2.png'),
	preload('res://data/sprites/bg/3.png'),
	preload('res://data/sprites/bg/4.png'),
	preload('res://data/sprites/bg/5.png'),
]


func load_config() -> Dictionary:
	var file: FileAccess = FileAccess.open('res://data/configs.json', FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text())
	return {}


func read_json_file(file_path) -> Dictionary:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file != null:
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		var out_data: Dictionary = {}
		for stat in data:
			out_data[stat] = data[stat]
		return out_data
	return {'status': 404}


func wright_json_data(file_path, data) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(str(data))


func set_bg_img(bg_obj) -> void:
	bg_obj.set_texture(bg_imgs[randi()%5])
