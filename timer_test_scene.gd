extends Node2D

@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		time()

func time():
	timer.start()
	if timer.start:
		print("timer started")
	
		


func _on_timer_timeout() -> void:
	print("timer ended")
