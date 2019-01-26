extends Area2D

signal button_state_changed(sender, is_pressed)

onready var _btn_sprite : Sprite = get_parent()
onready var _initial_scale = _btn_sprite.scale

func _input(event : InputEvent) -> void:
	# Handle if mouse button or screen is released outside of the sprite's rectangle and reset button state.
	if event is InputEventScreenTouch || event is InputEventMouseButton:
		if !event.is_pressed():
			_btn_sprite.scale = _initial_scale
			emit_signal("button_state_changed", _btn_sprite, false)

func _input_event(viewport, event, shape_idx):
	# Detect click/tap inside of the sprite's rectangle.
	if event is InputEventScreenTouch || event is InputEventMouseButton:
		var is_pressed : bool = event.is_pressed()
		
		if is_pressed:
			_btn_sprite.scale = _initial_scale * 0.8
		else:
			_btn_sprite.scale = _initial_scale
			
		emit_signal("button_state_changed", _btn_sprite, is_pressed)
		#print("Event position %s" % event.position)
