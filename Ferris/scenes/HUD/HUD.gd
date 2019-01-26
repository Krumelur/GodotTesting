extends CanvasLayer

enum Direction {
	Left = 0,
	Right = 1,
	Jump = 2
}

signal direction_input(direction, is_pressed)

func _on_button_state_changed(sender, is_pressed):
	if sender == $MoveLeftNode:
		emit_signal("direction_input", Direction.Left, is_pressed)
	elif sender == $MoveRightNode:
		emit_signal("direction_input", Direction.Right, is_pressed)
	elif sender == $MoveUpNode:
		emit_signal("direction_input", Direction.Jump, is_pressed)