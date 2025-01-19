extends CharacterBody2D

@export_group('move')
@export var speed := 200 # := is the data type of first value is the only data type this var can accept.
@export var acceleration := 1200
var direction := Vector2.ZERO
var can_move := true

@export_group('jump')
@export var jump_strength := 300


func _process(delta: float) -> void:
	if can_move:
		get_input()
		apply_movement(delta)
		
func get_input():
	# horizontal movement
	direction.x = Input.get_axis("left", "right")
	
func apply_movement(delta):
	# Left / Right movement
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(direction.x * speed, velocity.x, 0)
	move_and_slide()
