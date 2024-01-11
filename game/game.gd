extends Node2D

var ws_client := WebSocketPeer.new()
var cards_data: Dictionary
@onready var room_data: Dictionary = base_func.read_json_file('res://temp/game_params.json')
@onready var config: Dictionary = base_func.load_config()
@onready var cards_objs: Array[Node2D] = [$Card1, $Card2, $Card3, $Card4, $Card5]
#@onready var C: Script = load("res://game/scripts/classes.gd").new()


func _ready() -> void:
	# Обновляю состояние окна и обновляю переменные
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	base_func.set_bg_img($BG)
	# Начинаю добавлять пользователя в дб
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._player_add_request_completed)
	
	var error = http_request.request(
		"http://%s/%d/add-player/%s" % [config['serverURL'], room_data['gameID'], config['username']]
	)
	
	if error != OK:
		push_error('Не удалось добавить пользователя')


# Добавление игрока
func _player_add_request_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		cards_data = base_func.read_json_file("res://temp/cards_data.json")
		
		# Обновляю WS Client 
		var error = ws_client.connect_to_url("ws://%s/ws/%s@%s/" % [config['serverURL'], config['username'], room_data['gameID']])
		if error != 0:
			push_error('WS connect error')
			set_process(false)
	elif response_code == 500:
		push_error('Ошибка, не удалось добавить пользователя')
	elif response_code == 501:
		push_error('Пользователь уже существует')
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_tree().change_scene_to_file('res://main_menu/main_menu.tscn')


# Удаление игрока
func _on_exit_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._player_del_request_completed)
	
	var error = http_request.request(
		"http://%s/%d/del-player/%s" % [config['serverURL'], room_data['gameID'], config['username']]
	)
	if error != OK:
		push_error('Не удалось удалить пользователя')

func _player_del_request_completed(result, response_code, headers, body) -> void:
	if response_code == 501:
		push_error('Не удалось удалить пользователя')
	elif response_code == 200:
		get_tree().change_scene_to_file('res://main_menu/main_menu.tscn')


# Функции отрисовки карт и игрока
#func _cards(cards: Array):
	#for card in cards_objs:
		#card.visible = false
	#for cardID in range(len(cards)):
		#var card_ = cards_objs[cardID]
		##var card_data = C
		#card_.visible = true
		


func _players(players: Dictionary):
	for child in $CanvasLayer/PlayerContainer.get_children():
		remove_child(child)
	var player_list: Array = players.keys()
	player_list.sort()
	for playerID in player_list:
		var player_ := Label.new()
		player_.text = players[playerID]
		player_.theme = load("res://data/them/game.tres")
		player_.theme_type_variation = &"player_from_list"
		$CanvasLayer/PlayerContainer.add_child(player_)


# Обработка данныйх из от сервера через WebSocket
func _process(delta):
	ws_client.poll()
	if ws_client.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while ws_client.get_available_packet_count():
			var data: Dictionary = JSON.parse_string(ws_client.get_packet().get_string_from_ascii())
			
			#if data['func'] == "data":
				#if data['cards'] != null:
					#_cards(data['cards'])
				#if data['players'] != null:
					#_players(data['players'])
			
			if data['func'] == "dsa":
				pass
