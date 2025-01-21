extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func update_sprite(direction, on_floor, crouching):
	# Flip
	if direction.x:
		$Sprite2D.flip_h = direction.x < 0

	# State
	var state = 'idle' if not crouching else 'crouching'
	if on_floor and direction.x and not crouching: # If on the floor and moving, and not crouching
		state = 'run'
	if not on_floor:
		state = 'jump'
	animation_player.current_animation = state
