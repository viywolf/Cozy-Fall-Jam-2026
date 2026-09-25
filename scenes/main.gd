extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_notif("a")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_notif(image: String):
	var new_image_sprite: Sprite2D = Sprite2D.new() 
	if image.is_absolute_path():
		new_image_sprite.texture = load(image)
	else:
		new_image_sprite.texture = load("res://icon.svg")
	new_image_sprite.position.x = get_viewport().get_visible_rect().size.x / 2
	add_child(new_image_sprite)
	var tween = create_tween()
	tween.tween_property(new_image_sprite, "position:y", new_image_sprite.texture.get_height() / 2.0, 0.3)
	await get_tree().create_timer(2).timeout
	tween = create_tween()
	tween.tween_property(new_image_sprite, "modulate:a", 0, 0.4)
	await tween.finished
	new_image_sprite.queue_free()


func _on_interactable_zone_treasure_gained() -> void:
	add_notif("treasure gained image")


func _on_interactable_zone_junk_gained() -> void:
	add_notif("junk gained image")
