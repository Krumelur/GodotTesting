tool
extends Sprite

# Helper class to convert my good old sprite sheet from Ferris the Wanderer into individual sprites.

const TILE_SPACING_HORIZONTAL = 1
const TILE_SPACING_VERTICAL = 1
const TILE_WIDTH = 16
const TILE_HEIGHT = 16
const TILES_PER_ROW = 18
const TOTAL_TILES = 18 * 20 + 3

# Scans the image that is passed in and replaces all white pixels with transparency.
# Returns the processed image.
func _apply_transparency(input_image : Image) -> Image:
	# The image we're saving the converted data into
	var converted_image = Image.new()
	# Must use RGBA8 format to support alpha.
	converted_image.create(input_image.get_width(), input_image.get_height(), false, Image.FORMAT_RGBA8)
	converted_image.lock()
	
	# Must lock to be able to get/set pixels!
	input_image.lock()

	for y in range(0, input_image.get_height()):
			for x in range(0, input_image.get_width()):
				# If source color is WHITE, save as transparant (alpha = 0), otherwise save source color directly to detsination.
				var pixel_color = input_image.get_pixel(x, y)
				if pixel_color.r == 1 && pixel_color.g == 1 && pixel_color.b == 1:
					converted_image.set_pixel(x, y, Color(1.0, 0.0, 0.0, 0.0))
				else:
					converted_image.set_pixel(x, y, pixel_color)
	return converted_image

func _ready():
	print("Exporting %d tile images..." % TOTAL_TILES)

	# Use the texture of the sprite as the source sprite sheet.
	var source_image = texture.get_data()

 	# Iterate over all the tiles
	for index in range(0, TOTAL_TILES):
		# Get the current tile as an image.
		var tile_image = source_image.get_rect(Rect2((index % TILES_PER_ROW) * (TILE_WIDTH + TILE_SPACING_HORIZONTAL), (index / TILES_PER_ROW) * (TILE_HEIGHT + TILE_SPACING_VERTICAL), TILE_WIDTH, TILE_HEIGHT))
		
		var convert_image : Image = _apply_transparency(tile_image)
					
		# Save image back to resources.
		var img_name = "res://Helpers/ExportIndividualTiles/exported_tiles/%03d.png" % index
		print("Saving image %s..." % img_name)
		var error = convert_image.save_png(img_name)
		if error != OK:
			print("Error: " + Image.Error[error])

	print("Converting sprite sheet...")
	var sprite_sheet_convert_image = _apply_transparency(source_image)
	var error = sprite_sheet_convert_image.save_png("res://Helpers/ExportIndividualTiles/exported_tilesheet/spritesheet.png")
	if error != OK:
			print("Error: " + Image.Error[error])
	
	
	
	
