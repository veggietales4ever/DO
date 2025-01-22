extends Entity

@onready var player_graphics: Node2D = $PlayerGraphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_group('move')
@export var speed := 100 # := is the data type of first value is the only data type this var can accept.
@export var acceleration := 1200
@export var friction := 1800
var direction := Vector2.ZERO
var can_move := true
var dash := false
@export_range(0.1,2) var dash_cooldown := 0.5
var crouching := false

@export_group('jump')
@export var jump_strength := 300
@export var gravity := 600
@export var terminal_velocity := 500
var jump := false
var faster_fall := false
var gravity_multiplier := 1

@export_group('weapon')
var current_sword = Global.swords.LONGSWORD
var attacking := false
@export_range(0.1,2) var attack_cooldown := 0.5

func _ready() -> void:
	$Timers/DashCooldown.wait_time = dash_cooldown
	$Timers/AttackCooldown.wait_time = attack_cooldown
	player_graphics.connect("attack_finished", Callable(self, "_on_attack_finished"))
	
func _process(delta: float) -> void:
	apply_gravity(delta)
	
	if can_move:
		get_input()
		apply_movement(delta)
		animate()

func animate():
	player_graphics.update_sprite(direction, is_on_floor(), crouching, attacking) # direction of player, if they're on the floor, crouching or not

func get_input():
	# horizontal movement
	direction.x = Input.get_axis("left", "right")
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump = true
		if velocity.y > 0 and not is_on_floor():
			$Timers/JumpBuffer.start()
	
	if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		faster_fall = true
		
	# Dash
	if Input.is_action_just_pressed("dash") and velocity.x and not $Timers/DashCooldown.time_left: #Can only dash if moving in a direction
		dash = true
		$Timers/DashCooldown.start()
		
	# Crouching
	crouching = Input.is_action_pressed("down") and is_on_floor()
	
	# Attacking
	if Input.is_action_just_pressed("attack"):
		attacking = true

func apply_movement(delta):
	# Left / Right movement
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if crouching:
		velocity.x = 0
		jump = false
		
	# Jump
	if jump:# or $Timers/JumpBuffer.time_left and is_on_floor():
		velocity.y = -jump_strength
		jump = false
		faster_fall = false
	
	# Dash
	if dash:
		dash = false
		var dash_tween = create_tween()
		dash_tween.tween_property(self, 'velocity:x', velocity.x + direction.x * 300, 0.3)
		dash_tween.connect("finished", on_dash_finish)
		gravity_multiplier = 0
		
		
	#var on_floor = is_on_floor()
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)

func on_dash_finish():
	velocity.x = move_toward(velocity.x, 0, 900)
	gravity_multiplier = 1

func _on_attack_finished():
	attacking = false
