extends CharacterBody2D

var speed = 300
var jump_speed = -500
var gravity = 12
var coyote_time = 0.2
var coyote_timer = 0.0

@onready var jump_sound = %"Jump Sound"
@onready var walk_sound = %"Walk Sound"

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
		
	var direction = Input.get_axis("Left", "Right")
	
	if direction == -1:
		velocity.x = -1 * speed
	elif direction == 1:
		velocity.x = speed
	else:
		velocity.x = 0
		
	if direction != 0 and is_on_floor():
		if not walk_sound.playing:
			walk_sound.play()
	else:
		walk_sound.stop()
		
	move_and_slide()
