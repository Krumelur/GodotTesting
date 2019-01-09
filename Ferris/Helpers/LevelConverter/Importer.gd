tool
extends Node2D

# The IDs of the tiles used in the level file.
# The level file stores the tile ID but in the imported assets of the TileSet_Auto.tres are only
# a subset of all tiles. The resource ID of the tile is equal to the index of the tile in this array here.
# Example: tile 124 is at index 76
var level_file_tile_ids = [000, 001, 002, 003, 004, 005, 006, 007,
                                            008, 009, 010, 011, 012, 013, 014, 015,
                                            016, 017, 018, 019, 020, 021, 022, 023,
                                            024, 025, 026, 027, 028, 029, 030, 031,
                                            032, 033, 034, 035, 036, 037, 038, 039,
                                            040, 041, 042, 043, 044, 045, 046, 047,
                                            048, 049, 050, 051, 052, 053, 054, 055,
                                            059, 060, 061, 062, 063, 067, 071, 075,
                                            079, 083, 087, 091, 095, 099, 103, 107,
                                            111, 115, 119, 123, 124, 125, 126, 127,
                                            128, 129, 130, 131, 132, 133, 134, 135,
                                            136, 137, 138, 139, 140, 141, 142, 143,
                                            144, 145, 146, 147, 148, 149, 150, 151,
                                            152, 153, 154, 155, 156, 157, 158, 159,
                                            160, 161, 162, 163, 164, 165, 166, 167,
                                            168, 169, 170, 171, 172, 173, 174, 175,
                                            176, 177, 178, 179, 180, 181, 182, 183,
                                            184, 185, 186, 187, 188, 189, 190, 191,
                                            192, 193, 194, 195, 196, 197, 198, 199,
                                            200, 201, 202, 203, 204, 205, 206, 207,
                                            208, 209, 210, 211, 212, 213, 214, 215,
                                            216, 217, 218, 219, 220, 221, 222, 223,
                                            224, 225, 226, 227, 228, 229, 247, 283,
                                            287, 291, 295, 303, 307, 311, 315, 323,
                                            327, 331, 343, 351]

func _get_tile_resource_id(tile_id : int) -> int:
	var index = level_file_tile_ids.find(tile_id)
	return index

func _ready():
	print("Importer ready.");
	
	var file = File.new()
	var error = file.open("res://Helpers/LevelConverter/ferris_level.res", File.READ)
	print("File opened with code %d" % error)
	
	# Remove all level nodes.
	print("--------------------------------------")
	print("Deleting level nodes...")
	for child_node in get_children():
		if "MapLevel" in child_node.name:
			child_node.free()
		
	# Read level file and create tilemap content. There are 27 levels in total.
	print("--------------------------------------")
	print("Processing tiles...")
	for level_index in range(0, 27):
		print("Creating tilemap for level %d" % (level_index + 1))
		# The TileMap used as a template is saved as a scene. There is  duplicate() method for nodes but uisng
		# it does not what it seems. (https://www.reddit.com/r/godot/comments/8z84aq/how_to_duplicate_a_node_with_codes/)
		var tile_map = load("res://Helpers/LevelConverter/TemplateTileMap.tscn").instance()
		tile_map.clear()
		tile_map.name = "MapLevel%d" % (level_index + 1)
		add_child(tile_map)
		# Important - otherwise the map won't show up in the editor
		tile_map.set_owner(self)
		#tile_map.visible = false
		
		# First part of the file is an array of word sized tile infos.
		for column in range(0, 200 + 1):
			for row in range(0, 11 + 1):
				var tile_id = file.get_16()
				if row == 11:
					continue
				var mapped_tile_id = _get_tile_resource_id(tile_id)
				if mapped_tile_id == -1 :
					print("*** ERROR: Processing column %d, row %d. Found tile ID %d. Maps to invalid ID!" % [column, row, tile_id])
				else:
					#print("Processing column %d, row %d. Found tile ID %d. Maps to ID %d" % [column, row, tile_id, mapped_tile_id])
					tile_map.set_cell(column, row, mapped_tile_id)

		# Second part of level is a byte array of the type of the tile ('Wall', 'Kill', 'Background', 'Climb', 'Collect')
		# We generate another TileMap as a child of the level map and set the tile types.
		# At runtime, this map will be parsed and removed.
		print("Creating tilemap for tile types %d" % (level_index + 1))
		var level_type_map = load("res://Helpers/LevelConverter/Template_TypesTileMap.tscn").instance()
		level_type_map.clear()
		level_type_map.name = "MapLevelTypes%d" % (level_index + 1)
		tile_map.add_child(level_type_map)
		level_type_map.set_owner(tile_map)
		level_type_map.visible = false 
		print("--------------------------------------")
		print("Processing tile types...")
		for column in range(0, 200 + 1):
			for row in range(0, 11 + 1):
				var tile_type = file.get_8()
				if row == 11:
					continue
				if tile_type < 0 || tile_type > 4:
					print("Processing column %d, row %d. Found invalid type %d" % [column, row, tile_type])
				else:
					level_type_map.set_cell(column, row, tile_type)
	
		# Last byte per level is the background color (zero based index of a palette)
		var background_color_index = file.get_8()
		# TODO: Save somewhere
		
		# Save scene to disk
		print("--------------------------------------")
		print("Saving level to disk...")
		var level_scene = PackedScene.new()
		var result = level_scene.pack(tile_map)
		print("RESULT:")
		if result != OK:
			print("Error saving scene: %i" % result)
		else:
			var save_error = ResourceSaver.save("res://Helpers/LevelConverter/GeneratedScenes/level_%d.tscn" % (level_index + 1), level_scene)
			print("Saving resource result: %s" % str(save_error))
	file.close()