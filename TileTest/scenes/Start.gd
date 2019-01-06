extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var resource : Resource = load("res://scenes/Levels/level_1.tscn")
	var level_scene : Node = resource.instance()
	add_child(level_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
