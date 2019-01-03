extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _physics_process(delta):
	var vel = Vector2(0, 0)

	if Input.is_action_pressed("ui_up"):
		vel.y = -1
	if Input.is_action_pressed("ui_down"):
		vel.y = 1
	if Input.is_action_pressed("ui_left"):
		vel.x = -1
	if Input.is_action_pressed("ui_right"):
		vel.x = 1

	
	vel = vel.normalized() * 150
	#position.x += vel.x * max_speed
	#position.y += vel.y * max_speed
	
	move_and_slide(vel)