extends Node2D

signal attack_finished

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	# Connect the signal (if not already connected via the editor)
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func update_sprite(direction, on_floor, crouching, attacking):
	# Flip
	if direction.x:
		$Sprite2D.flip_h = direction.x < 0

	# State
	#var state = 'idle' if not crouching else 'crouching'
	#if on_floor and direction.x and not crouching: # If on the floor and moving, and not crouching
		#state = 'run'
	#if not on_floor:
		#state = 'jump'
	#if on_floor and attacking:
		#state = 'attacking'
	#animation_player.play(state)
	
	# State
	var state = 'idle'
	
	#Prioritize attacking
	if attacking:
		state = "attack"
	elif crouching:
		state = 'crouching'
	elif not on_floor:
		state = 'jump'
	elif on_floor and direction.x:
		state = 'run'

	animation_player.play(state)
	
func _on_animation_finished(anim_name):
	if anim_name == 'attack':
		animation_player.play('idle')
		emit_signal("attack_finished")
