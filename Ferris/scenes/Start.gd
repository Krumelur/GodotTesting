extends Node2D

const Hud = preload("res://scenes/HUD/HUD.gd")

enum TILE_TYPES {
	Wall = 0,
	Kill = 1,
	Background = 2,
	Climb = 3,
	Collect = 4
}

enum SPRITE_ID {
	Player = 247
}

# The node that will be the parent of the current level's tile map.
onready var _current_level_node : Node = $CurrentLevelNode

# The tile map containing the current level's data.
var _current_level_map : TileMap

# The node representing the player in the current scene.
onready var _player_node : Node2D  = $CurrentLevelNode/Player

# The camera is attached to this node. Moving the node changes the part of the scene we're looking at.
# The game logic will move this node along with the player.
onready var _camera_follow_node : Node = $CurrentLevelNode/CameraFollowNode

# Overlay containing input controls.
onready var _hud_node : Node2D = $HUD


func _ready():
	# Note about the game's dimensions:
	# The assets were designed for a resolution of 320x200 (MCGA) back in the days.
	# Because they are just 16x16 pixels in size, we have to scale things up.
	# The window resolution of the project is set to 320x200 but the window can be resized to any given dimensions.
	# Setting the project settings to scale 2D (in section "Window") and keep aspect ratio right takes care of proper resizing.
	# We set the initial window size to 640x480 to prevent the game window from being tiny.
	OS.window_size = Vector2(640, 480)
	
	# Create an instance of the level. What we get back is a TileMap.
	var resource : Resource = load("res://scenes/Levels/level_1.tscn")
	_current_level_map = resource.instance()
	# Scale by a factor of 4...modern hardware has so much more resolution than back in the good old days of 320x200 :-)
	#_current_level_map.scale = Vector2(1, 1)
	_current_level_node.add_child(_current_level_map)
	
	# Every level map has got a child TileMap that defines the type of the tile used at a specific location (background, wall, kill, collectable, climbable)
	var tile_type_map : TileMap = _current_level_map.get_child(0)
	tile_type_map.visible = true
	tile_type_map.modulate.a = 0.0

	# Optimize: if tile type map indicates a background it means there is nothing. So remove the tile from the type map.
	for background_cell in tile_type_map.get_used_cells_by_id(TILE_TYPES.Background):
		tile_type_map.set_cellv(background_cell, -1)

	# Scan the map and find actors (player, enemies, ...)
	var level_tile_set : TileSet = _current_level_map.tile_set
	for used_cell in _current_level_map.get_used_cells():
		var level_tile_id = _current_level_map.get_cellv(used_cell)
		# The tile ID is the ID of the resource in the TileSet. What I need is the ID of the sprite because that's used in the original code
		# and I don't want to mentally map things all the time.
		# Example:
		# In TileSet_Map.tres there is the texture resource for the player stored as: [ext_resource path="res://assets/gfx/tiles/247.png" type="Texture" id=94]
		# This resource is used to define the player tile:
		# 	182/name = "247"
		# 	182/texture = ExtResource( 94 )
		# 	[...]
		# This means: texture resource 94 is used for tile ID 182 and the name of the tile is 247 which is the ID of the sprite because I used the sprite ID
		# as the name when generating the TileSet using a C# script.
		var tile_name : String = level_tile_set.tile_get_name(level_tile_id)
		var sprite_id : int = int(tile_name)
		# Now we can search for the sprite ID
		match sprite_id:
			SPRITE_ID.Player:
				print("Found player at %s" % used_cell)
				_current_level_map.set_cellv(used_cell, -1)
				setup_player_node(used_cell)

func _physics_process(delta: float) -> void:
	#_player_node.move($Joystick.joystick_vector)
	if _camera_follow_node && _player_node :
		_camera_follow_node.position = Vector2(_player_node.position.x - 150, 0)
		
						
# Places the player at a given level position. Adds player to the scene if not in it yet.
func setup_player_node(tile_position : Vector2) -> void:
	# Pivot point of sprite is the center. Adjust by half the width and height when inserting player.
	_player_node.position = (tile_position * _current_level_map.cell_size) + _current_level_map.cell_size / 2

func _on_hud_direction_input(direction, is_pressed):
	if !is_pressed:
		_player_node.move(Vector2(0, 0))
		return
		
	var move_dir = Vector2.ZERO
	
	if	direction == Hud.Direction.Jump:
		_player_node.jump()
	
	if direction == Hud.Direction.Left:
		move_dir.x = -1
	elif direction == Hud.Direction.Right:
		move_dir.x = +1
		
	_player_node.move(move_dir)