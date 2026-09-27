extends CharacterBody2D

var speed = 300
var jump_speed = -500
var gravity = 12
var coyote_time = 0.2
var coyote_timer = 0.0

var rotate_direction: float = 1

@onready var jump_sound = %"Jump Sound"
@onready var walk_sound = %"Walk Sound"

@onready var normal_sprite = preload("res://CharacterNormal.png")
@onready var dig_sprite = preload("res://CharacterDig.png")

var is_digging: bool = false

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity
		
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
		
	if Input.is_action_just_pressed("Jump") and coyote_timer > 0:
		velocity.y = jump_speed
		coyote_timer = 0.0
		jump_sound.play()
		
	if Input.is_action_just_pressed("Interact") and is_on_floor():
		$Sprite2D.texture = dig_sprite
		is_digging = true
		var dig_tween = create_tween()
		dig_tween.tween_property($Sprite2D, "rotation", PI/8, 0.4)
		dig_tween.tween_property($Sprite2D, "rotation", -PI/8, 0.4)
		dig_tween.tween_property($Sprite2D, "rotation", PI/8, 0.4)
		dig_tween.tween_property($Sprite2D, "rotation", -PI/8, 0.4)
		await dig_tween.finished
		$Sprite2D.texture = normal_sprite
		is_digging = false
		
	var direction = Input.get_axis("Left", "Right")
	
	if direction == -1 and is_digging == false:
		velocity.x = -1 * speed
	elif direction == 1 and is_digging == false:
		velocity.x = speed
	else:
		velocity.x = 0
		
	var tween = create_tween()
	if direction != 0 and is_on_floor():
		if not walk_sound.playing:
			walk_sound.play()
		tween.tween_property($Sprite2D, "rotation", PI/20 * rotate_direction, 0.4)
		if $Sprite2D.rotation >= PI/22:
			rotate_direction = -1
		if $Sprite2D.rotation <= -PI/22:
			rotate_direction = 1
	else:
		walk_sound.stop()
		if is_digging == false:
			tween.tween_property($Sprite2D, "rotation", 0, 0.3)
		# This is to get rid of the error, does nothing
		tween.tween_property($Sprite2D, "position:x", 0, 0.3)
		
	move_and_slide()
