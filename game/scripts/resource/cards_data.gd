class_name CardsData extends Resource

@export var cards: Dictionary

func _init(cards_: Dictionary):
	resource_name = "CardsData"
	resource_path = "res://temp/cards_data.tres"
	cards = cards_
