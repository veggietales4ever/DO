extends CharacterBody2D

var input
var crouching = false
@onready var animated_sprite: AnimatedSprite2D =$AnimatedSprite2D

@export var speed = 60
@export var gravity = 10

# Variable for jumping
var jump_count = 0
@export var max_jump = 2
@export var jump = 500



func _ready() -> void:
	pass

	



func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta):
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input != 0: # ! means not
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 60.0, speed)
			animated_sprite.scale.x = 1
			animated_sprite.animation = "idle"
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 60.0, -speed)
			animated_sprite.scale.x = -1
			animated_sprite.animation = "idle"
			
		
	if input == 0:
		velocity.x = 0
		animated_sprite.animation = "idle"
		
	# Crouch Code
	if Input.get_action_strength("down") && is_on_floor():
		animated_sprite.animation = "crouching"
		crouching = true
		if crouching && input > 0:
			velocity.x = 0
		if crouching && input < 0:
			velocity.x = 0

		
	if Input.is_action_pressed("down") && is_on_floor() && crouching == true:
		animated_sprite.animation = "crouching"
		#print(animated_sprite.animation)
# Jump Code
	if is_on_floor():
		jump_count = 0
		
	#if !is_on_floor():
		#if velocity.y < 0:
			#animated_sprite.animation = "jump"
		#if velocity.y > 0:
			#animated_sprite.animation = "fall"
			
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
