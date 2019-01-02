extends Sprite

# Helper class to convert my good old sprite sheet from Ferris the Wanderer into individual sprites.

const TILE_SPACING_HORIZONTAL = 1
const TILE_SPACING_VERTICAL = 1
const TILE_WIDTH = 16
const TILE_HEIGHT = 16
const TILES_PER_ROW = 18
const TOTAL_TILES = 18 * 20 + 3

func _ready():
	print("Exporting %d images..." % TOTAL_TILES)

	# Use the texture of the sprite as the source image.
	var source_image = texture.get_data()

 	# Iterate over all the tiles
	for index in range(0, TOTAL_TILES):
		# Get the current tile as an image.
		var tile_image = source_image.get_rect(Rect2((index % TILES_PER_ROW) * (TILE_WIDTH + TILE_SPACING_HORIZONTAL), (index / TILES_PER_ROW) * (TILE_HEIGHT + TILE_SPACING_VERTICAL), TILE_WIDTH, TILE_HEIGHT))
		# Must lock to be able to get/set pixels!
		tile_image.lock()
		
		# The image we're saving back to disk.
		var convert_image = Image.new()
		# Must use RGBA8 format to support alpha.
		convert_image.create(tile_image.get_width(), tile_image.get_height(), false, Image.FORMAT_RGBA8)
		convert_image.lock()
		
		# Process source tile pixel by pixel
		for y in range(0, tile_image.get_height()):
			for x in range(0, tile_image.get_width()):
				# If source color is WHITE, save as transparant (alpha = 0), otherwise save source color directly to detsination.
				var pixel_color = tile_image.get_pixel(x, y)
				if pixel_color.r == 1 && pixel_color.g == 1 && pixel_color.b == 1:
					convert_image.set_pixel(x, y, Color(1.0, 0.0, 0.0, 0.0))
				else:
					convert_image.set_pixel(x, y, pixel_color)
					
		# Save image back to resources.
		var img_name = "exported_tiles/%03d.png" % index
		print("Saving image %s..." % img_name)
		convert_image.save_png(img_name)