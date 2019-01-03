extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var max_speed = 150
export var walk_acceleration = 15
export var max_fall_speed = 400

func _ready():
	pass
	
var idle_timer_started = false
var vel = Vector2(0, 0)

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		vel.x -= walk_acceleration
		vel.x = clamp(vel.x, -max_speed, 0)
	elif Input.is_action_pressed("ui_right"):
		vel.x += walk_acceleration
		vel.x = clamp(vel.x, 0, max_speed)
	else:
		vel.x = 0

	var vec = Image.create(...)

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

	if !is_on_floor():
		vel.y += global.GRAVITY * delta
		
	vel.y = clamp(vel.y, 0, max_fall_speed)

	#position.x += vel.x * max_speed
	#position.y += vel.y * max_speed
	
	move_and_slide(vel, Vector2(0, -1), 5, 500)
	

func _idle_timer_triggered():
	$Sprite.animation = "idle"
	$Sprite.play()
