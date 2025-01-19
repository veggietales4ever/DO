extends CharacterBody2D

var input
var crouching = false
var default_speed = .75

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $anim
@onready var sword_collision: Area2D = $sword
@onready var collision_shape_2d: CollisionShape2D = $sword/CollisionShape2D


@export var speed = 70
@export var gravity = 8

# Variable for jumping
var jump_count = 0
@export var max_jump = 2
@export var jump = 200


# State Machine Info
var current_state = player_states.MOVE
enum player_states {MOVE, SWORD, CROUCH, RISE}


func _ready() -> void:
	collision_shape_2d.disabled = true

	



func _physics_process(delta: float) -> void:
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword()
		player_states.CROUCH:
			crouch()
		player_states.RISE:
			rise()


func movement(delta):
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input != 0: # ! means not
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 70.0, speed)
			sprite.scale.x = 1
			sword_collision.position.x = 16
			anim.play("idle")
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed, 70.0, -speed)
			sprite.scale.x = -1
			sword_collision.position.x = -43
			
			anim.play("idle")
			
		
	if input == 0:
		velocity.x = 0
		anim.play("idle")
		anim.speed_scale = default_speed
		
	# Crouch Code
	if Input.is_action_pressed("down") && is_on_floor():
		current_state = player_states.CROUCH
	
	
	if crouching && input > 0:
		velocity.x = 0
	if crouching && input < 0:
		velocity.x = 0
			
			
		
		
# Jump Code
	if is_on_floor():
		jump_count = 0
		
			
			
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
		
	if Input.is_action_just_pressed("attack"):
		current_state = player_states.SWORD
		
	gravity_force()
	move_and_slide()

	
func gravity_force():
	velocity.y += gravity


#func input_movement(delta):
	#input = Input.get_action_strength("right") - Input.get_action_strength("left")
	#
	#
	#if Input.is_action_pressed("ui_accept") && input != 0: # ! means not
		#if input > 0:
			#velocity.x += speed * delta
			#velocity.x = clamp(speed, 70.0, speed)
		#if input < 0:
			#velocity.x -= speed * delta
			#velocity.x = clamp(-speed, 70.0, -speed)


func reset_states():
	current_state = player_states.MOVE
			
			
func sword():
	anim.play("sword")
	gravity_force()
	move_and_slide()
	
	
func crouch():
	crouching = true
	jump_count = max_jump
	anim.play("crouching")
	if Input.is_action_just_released("down") && crouching:
		current_state = player_states.RISE
		
		
func rise():
	anim.play("rise")
	crouching = false
	current_state = player_states.MOVE
