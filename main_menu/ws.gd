extends Node
var ws_url = "ws://127.0.0.1:5338/ws/game/2/" 

var _ws_client = WebSocketPeer.new()


func _ready():
	var error = _ws_client.connect_to_url(ws_url)
	if error == OK:
		print("ws connect success")
	elif error != OK:
		print('ws connected error')


func _on_data():
	print("Получены данные с сервера: ", _ws_client.get_peer(1).get_packet().get_string_from_utf8())


func _process(delta):
	_ws_client.poll()
