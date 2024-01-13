@icon("res://data/sprites/cards/nechto.jpg")
extends Node2D
class_name Card
signal card_is_pressed

# Metadata
@export var card_num: int = 0
@export var texture := Texture2D
@export var card_name: String = "Card"
@export var card_description: String = "Description"


func _ready():
	$Name.text = card_name
	$Description.text = card_description
	$CardSprite_Button.texture_normal = texture if texture != null else load("res://data/sprites/cards/imgnotfind.svg")


func _process(delta):
	$Name.text = card_name
	$Description.text = card_description
	$CardSprite_Button.texture_normal = texture if texture != null else load("res://data/sprites/cards/imgnotfind.svg")


# движение и изменение размера карты
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


func _on_card_sprite_button_pressed():
	emit_signal("card_is_pressed")
