extends CharacterBody2D

var input
@export var speed = 60
@export var gravity = 10

# Variable for jumping
var jump_count = 0
@export var max_jump = 2
@export var jump = 500



func _process(delta: float) -> void:
	movement(delta)

func movement(delta):
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input != 0: # ! means not
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 60.0, speed)
			$AnimatedSprite2D.scale.x = -1
			$AnimatedSprite2D.animation = "move"
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 60.0, -speed)
			$AnimatedSprite2D.scale.x = 1
			$AnimatedSprite2D.animation = "move"
			
		
	if input == 0:
		velocity.x = 0
		$AnimatedSprite2D.animation = "idle"
		
# Jump Code
	if is_on_floor():
		jump_count = 0
		
	if !is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "jump"
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "fall"
			
	if Input.is_action_pressed("ui_accept") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump
		velocity.x = input
	if !is_on_floor() && Input.is_action_pressed("ui_accept") && jump_count < max_jump:
		jump_count += 1
		velocity.y -= jump
		velocity.x = input
	if !is_on_floor() && Input.is_action_just_released("ui_accept") && jump_count < max_jump:
		velocity.y = gravity
		velocity.x = input
	else:
		gravity_force()
		
		
	gravity_force()
	move_and_slide()

func gravity_force():
	velocity.y += gravity
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#if Input.is_action_pressed("right"):
		#position.x += speed * delta
		#
	#if Input.is_action_pressed("down"):
		#position.y += speed * delta
		#
	#if Input.is_action_pressed("left"):
		#position.x -= speed * delta
		#
	#if Input.is_action_pressed("up"):
		#position.y -= speed * delta
