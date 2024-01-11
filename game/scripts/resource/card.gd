class_name Card extends Resource


@export var name: String
@export var description: String
@export var image: Texture2D


func _init(
		name_: String,
		description_: String,
		image_: Texture2D
	):
	name = name_
	description = description_
	image = image_
