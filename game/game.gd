extends "res://base_scripts/menu.gd"


var room_data: Dictionary = {}
var account_data: Dictionary = {}


func _ready() -> void:
	DisplayServer.window_set_mode(3)
	load_config()
	set_bg_img(get_node('BG'))
	room_data = read_json_file('res://temp/game_params.json')
	_data_update()
	
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._player_add_request_completed)
	
	var error = http_request.request(
		"http://%s/%d/add-player/%s" % [config['serverURL'], room_data['gameID'], config['username']]
	)
	
	if error != OK:
		push_error('Не удалось добавить пользователя')


func _player_add_request_completed(result, response_code, headers, body) -> void:
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
	
	if response['status'] == 500:
		push_error('Ошибка, не удалось добавить пользователя')
	elif response['status'] == 501:
		push_error('Пользователь уже существует')
		get_tree().change_scene_to_file('res://main_menu/main_menu.tscn')
	elif response['status'] == 200:
		$Timer.autostart = true


func _on_exit_pressed() -> void:
	DisplayServer.window_set_mode(0)
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._player_del_request_completed)
	
	var error = http_request.request(
		"http://%s/%d/del-player/%s" % [config['serverURL'], room_data['gameID'], config['username']]
	)
	if error != OK:
		push_error('Не удалось удалить пользователя')


func _player_del_request_completed(result, response_code, headers, body) -> void:
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	if response['status'] == 501:
		push_error('Не удалось удалить пользователя')
	elif response['status'] == 200:
		get_tree().change_scene_to_file('res://main_menu/main_menu.tscn')


func _data_update() -> void:
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._data_load_request_completed)
	
	var error = http_request.request(
		"http://%s/%d/data-load/%s" % [config['serverURL'], room_data['gameID'], config['username']]
	)
	if error != OK:
		push_error('Не удалось получить данные')


func _data_load_request_completed(result, response_code, headers, body) -> void:
	var json: JSON = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	if response['status'] == 503:
		_show_players(response['players'])
	elif response['status'] == 200:
		pass


func _show_players(players: Dictionary) -> void:
	for playerLab in $GUI/PlayersCont.get_children():
		$GUI/PlayersCont.remove_child(playerLab)
	
	for player in players:
		var name: String = players[player]['username']
		var player_lab: Label = Label.new()
		player_lab.text = name
		player_lab.size_flags_vertical = Control.SIZE_EXPAND_FILL
		$GUI/PlayersCont.add_child(player_lab)


func _on_timer_timeout() -> void:
	_data_update()
