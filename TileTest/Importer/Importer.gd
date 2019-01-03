tool
extends Node2D

func _ready():
	print("Importer ready.");
	
	var file = File.new()
	var error = file.open("res://ferris_level.res", File.READ)
	print("File opened with code %d" % error)
	
	print("--------------------------------------")
	print("Clearing out template node...")
	$TemplateTileMap.clear()
	
	# Remove all level nodes.
	print("--------------------------------------")
	print("Deleting level nodes...")
	for child_node in get_children():
		if "MapLevel" in child_node.name:
			child_node.free()
	
	# Recreate level nodes.
	print("--------------------------------------")
	print("Recreating level nodes...")
	for level_index in range(0, 28):
		print("Creating tilemap for level level %d" % (level_index + 1))
		var level_map = $TemplateTileMap.duplicate()
		level_map.name = "MapLevel%d" % (level_index + 1)
		add_child(level_map)
		# Important - otherwise the map won't show up in the editor
		level_map.set_owner(self)
		
	# Read level file and create tilemap content.
	print("--------------------------------------")
	print("Processing tiles...")
	for level_index in range(0, 28):
		var tile_map = get_node("MapLevel$d" % (level_index + 1))

		# First part of the file is an array of word sized tile infos.
		for column in range(0, 200 + 1):
			for row in range(0, 11 + 1):
				var tile_id = file.get_16()
				if row == 11:
					continue
				print("Processing column %d, row %d. Found tile ID %d" % [column, row, tile_id])
				tile_map.set_cell(column, row, tile_id)

		# Second part of level is a byte array of the type of the tile ('Wall', 'Kill', 'Background', 'Climb', 'Collect')
		print("--------------------------------------")
		print("Processing tile types...")
		for column in range(0, 200 + 1):
			for row in range(0, 11 + 1):
				var tile_type = file.get_8()
				if row == 11:
					continue
				print("Processing column %d, row %d. Found type %d" % [column, row, tile_type])
				tile_map.set_cell(column, row, tile_id)
	file.close()