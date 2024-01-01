extends "res://base_scripts/menu.gd"


func _ready() -> void:
	load_config()
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	var error = http_request.request("http://%s/game-list/" % config['serverURL'])
	if error != OK:
		push_error("Ошибка запроса")
	
	set_bg_img(get_node('BG'))


func _http_request_completed(result, response_code, headers, body) -> void:
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	for gameID in response:
		var button: Node = get_node('GUI/%s' % gameID)
		button.visible = true


func _process(delta) -> void:
	pass


func _on_1_pressed() -> void:
	wright_json_data('res://temp/game_params.json', {
		"gameID": 1,
	})
	get_tree().change_scene_to_file('res://game/game.tscn')


func _on_2_pressed() -> void:
	wright_json_data('res://temp/game_params.json', {
		"gameID": 2,
	})
	get_tree().change_scene_to_file('res://game/game.tscn')


func _on_3_pressed() -> void:
	wright_json_data('res://temp/game_params.json', {
		"gameID": 3,
	})
	get_tree().change_scene_to_file('res://game/game.tscn')
