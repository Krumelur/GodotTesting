extends KinematicBody2D

export var max_speed : int = 80
export var walk_acceleration : int = 15
export var max_fall_speed : int = 400

var jump_speed : float = 200.0

func _ready():
	pass
	
var idle_timer_started : bool = false
var vel : Vector2 = Vector2(0, 0)
var is_jumping : bool = false

func _input(event : InputEvent) -> void:
	if is_jumping:
		return
	if event.is_action_pressed("jump"):
		is_jumping = true
		vel.y = -jump_speed

func _physics_process(delta : float):
	if Input.is_action_pressed("ui_left"):
		#vel.x -= walk_acceleration
		#vel.x = clamp(vel.x, -max_speed, 0)
		vel.x = -max_speed
	elif Input.is_action_pressed("ui_right"):
		#vel.x += walk_acceleration
		#vel.x = clamp(vel.x, 0, max_speed)
		vel.x = max_speed
	else:
		vel.x = 0

	if vel.x != 0:
		$Sprite.flip_h = vel.x < 0
		$Sprite.animation = "walk_right"
		$Sprite.play()
		idle_timer_started = false
		$IdleTimer.stop()
	else:
		if !idle_timer_started:
			idle_timer_started = true
			$Sprite.stop()
			$IdleTimer.start()

		
	#vel.y = clamp(vel.y, 0, max_fall_speed)
	var remaining = move_and_slide(vel, Vector2(0, -1), true)
	
	if is_jumping && remaining.round().y == 0 :
		is_jumping = false
		vel.y = 0
	
	if !is_on_floor():
		vel.y += global.GRAVITY * delta
	else:
		is_jumping = false
	
	

func _idle_timer_triggered():
	$Sprite.animation = "idle"
	$Sprite.play()
