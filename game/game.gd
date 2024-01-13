extends Node2D

var ws_client := WebSocketPeer.new()
var cards_data: Dictionary
@onready var room_data: Dictionary = base_func.read_json_file('res://temp/game_params.json')
@onready var config: Dictionary = base_func.load_config()
@onready var cards_objs: Array[Node2D] = [$Card1, $Card2, $Card3, $Card4, $Card5]
#var excelFile = ExcelFile.open_file("")
var cards_status_for_use := false
var cards_status_for_trade := false 


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
func _cards(cards: Array) -> void:
	for card in cards_objs:
		card.visible = false
	for cardID in range(len(cards)):
		var card = cards_objs[cardID]
		var card_data = cards_data[str(cards[cardID])]
		card.visible = true
		card.card_num = int(cards[cardID])
		
		var img_name = str(card_data['image'])
		if not img_name.is_empty():
			card.texture = load(img_name)
		else:
			card.texture = null
		
		card.card_name = card_data['name']
		card.card_description = card_data['description']

func _players(players: Dictionary) -> void:
	for child in $CanvasLayer/Players/PlayerContainer.get_children():
		remove_child(child)
	var player_list: Array = players.keys()
	player_list.sort()
	for playerID in player_list:
		var player_ := Label.new()
		player_.text = players[playerID]
		player_.theme = load("res://data/them/game.tres")
		player_.theme_type_variation = &"player_from_list"
		$CanvasLayer/Players/PlayerContainer.add_child(player_)


# Обработка данныйх из от сервера через WebSocket
func _process(delta) -> void:
	ws_client.poll()
	if ws_client.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while ws_client.get_available_packet_count():
			var data: Dictionary = JSON.parse_string(ws_client.get_packet().get_string_from_ascii())
			
			if data['func'] == "data":
				if data['cards'] != null:
					_cards(data['cards'])
				if data['players'] != null:
					_players(data['players'])
					print(data['players'])
					if data['players']['1'] == config['username']:
						cards_status_for_use = true


func _on_card_card_is_pressed(cardID) -> void: 
	var card = cards_objs[cardID]
	if cards_status_for_use: 
		if card: 
			pass
		var data: Dictionary = {
			"func": "step",
			"cardID": card.card_num
		}
		ws_client.send_text(JSON.stringify(data))
		#cards_status_for_trade = true
		#cards_status_for_use = false
