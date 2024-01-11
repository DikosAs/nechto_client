@icon("res://data/sprites/cards/nechto.jpg")
extends Node2D


@export var texture := Texture2D
@export var card_name: String = "Card"
@export var card_description: String = "Description"


func _ready():
	$Name.text = card_name
	$Description.text = card_description
	$CardSprite_Button.texture_normal = texture
	$CardSprite_Button.texture_pressed = texture


func _on_control_mouse_entered():
	position = Vector2(
		position.x,
		position.y - 250
	) 
	scale = Vector2(1.15, 1.15)


func _on_control_mouse_exited():
	position = Vector2(
		position.x,
		position.y + 250
	)
	scale = Vector2(1, 1)
