extends HTTPRequest

#const SQL = preload()

var config: Dictionary
var img_name: String
var total_requests = 0
var completed_requests = 0


func _ready() -> void:
	config = base_func.load_config()
	var error = request("http://%s/update-data/" % config['serverURL'])
	if error != OK:
		push_error("Ошибка запроса")


func _on_cards_request_completed(result, response_code, headers, body) -> void:
	if response_code == 500:
		push_error('Ошибка')
	elif response_code == 200:
		var json: JSON = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response: Dictionary = json.get_data()
		
		var CARDS: Dictionary
		var cards: Dictionary
		for card in response['cards']:
			var card_data = response['cards'][card]
			cards[card] = {
				'name': card_data['name'],
				'description': card_data['description'],
				'function': card_data['function'],
				'image': card_data['image'],
				'minPlayerInGame': card_data['minPlayerInGame'],
				'maxCardInColoda': card_data['maxCardInColoda']
			}
			CARDS[card] = Card.new(
				card_data['name'],
				card_data['description'],
				card_data['image']
			)
			
			
		
		
		base_func.wright_json_data('res://temp/cards_data.json', cards)
		for card in cards:
			if cards[card]['image'] != '':
				total_requests += 1
				var img_http: HTTPRequest = HTTPRequest.new()
				img_http.use_threads = true
				add_child(img_http)
				img_http.request_completed.connect(_on_card_sprite_request_completed)
				img_http.request("http://%s%s" % [config['serverURL'], cards[card]['image']])


func _on_card_sprite_request_completed(result, response_code, headers, body) -> void:
	if response_code == 200:
		var img: Image = Image.new()
		for header in headers:
			if "Content-Disposition" in header:
				for split1 in str(header).split(' '):
					if 'filename' in split1:
						for split2 in split1.split('"'):
							if ".png" in split2 or ".jpg" in split2:
								img_name = split2
		var path_to_image = "%s/%s" % [config['path_to_card_sprites'], img_name]
		if '.png' in img_name:
			img.load_png_from_buffer(body)
			img.save_png(path_to_image)
		elif '.jpg' in img_name:
			img.load_jpg_from_buffer(body)
			img.save_jpg(path_to_image)
		completed_requests += 1
		if completed_requests == total_requests:
			get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
