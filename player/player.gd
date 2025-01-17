extends Node2D

var speed = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		position.x += speed * delta
		
	if Input.is_action_pressed("down"):
		position.y += speed * delta
		
	if Input.is_action_pressed("left"):
		position.x -= speed * delta
		
	if Input.is_action_pressed("up"):
		position.y -= speed * delta
