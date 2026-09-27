extends Node2D

var spawnpoint: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()
	spawnpoint = $Player.global_position
	

func _physics_process(delta: float) -> void:
	if $Player.global_position.y > 2000:
		$Player.global_position = spawnpoint

	
func add_notif(image: String):
	print("adding notif")
	var new_image_sprite: Sprite2D = Sprite2D.new() 
	if image.is_absolute_path():
		new_image_sprite.texture = load(image)
	else:
		new_image_sprite.texture = load("res://icon.svg")
	new_image_sprite.position.x = get_viewport().get_visible_rect().size.x / 2
	$CanvasLayer.add_child(new_image_sprite)
	var tween = create_tween()
	tween.tween_property(new_image_sprite, "position:y", new_image_sprite.texture.get_height() / 2.0, 0.3)
	await get_tree().create_timer(2).timeout
	tween = create_tween()
	tween.tween_property(new_image_sprite, "modulate:a", 0, 0.4)
	await tween.finished
	new_image_sprite.queue_free()
	update_label()


func _on_interactable_zone_treasure_gained() -> void:
	add_notif("treasure gained image")
	Global.treasure_collected += 1


func _on_interactable_zone_junk_gained() -> void:
	add_notif("junk gained image")

func update_label() -> void:
	$CanvasLayer/Label.text = "Treasure found: " + str(Global.treasure_collected) + "/" + str(Global.total_treasure)
