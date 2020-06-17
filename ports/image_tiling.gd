class_name GoostImageTiling
#
# The `tile` and `repeat` methods are initial prototypes for image tiling
# which are now implemented directly in the GoostImage singleton:
#
#    https://github.com/GoostGD/goost/commit/3bcaffab29
#
enum Tile {
	NONE,
	X,
	Y,
	XY
}

static func tile(p_image: Image, p_size: Vector2, p_mode := Tile.NONE):
	var sw = p_image.get_width()
	var sh = p_image.get_height()
	var dw = int(p_size.x)
	var dh = int(p_size.y)

	assert(dw > 0)
	assert(dh > 0)

	var cols = (dw + sw - 1) / sw;
	var rows = (dh + sh - 1) / sh;

	return repeat(p_image, Vector2(cols, rows), p_mode, p_size)


static func repeat(p_image: Image,
					p_count := Vector2.ONE,
					p_mode := Tile.NONE,
					p_max_size := Vector2(Image.MAX_WIDTH, Image.MAX_HEIGHT)):
	assert(p_image)
	assert(not p_image.is_empty())

	var cols = int(p_count.x)
	var rows = int(p_count.y)

	assert(cols > 0)
	assert(rows > 0)

	var src = p_image
	var src_fx
	var src_fy
	var src_fxy

	var src_rect = Rect2(Vector2(0, 0), src.get_size())
	var w = src.get_width()
	var h = src.get_height()

	if p_mode == Tile.XY or p_mode == Tile.Y:
		src_fx = Image.new()
		src_fx.copy_from(src)
		src_fx.flip_x()

	if p_mode == Tile.XY or p_mode == Tile.X:
		src_fy = Image.new()
		src_fy.copy_from(src)
		src_fy.flip_y()

	if p_mode == Tile.XY:
		src_fxy = Image.new()
		src_fxy.copy_from(src_fx)
		src_fxy.flip_y()

	var dest = Image.new()
	var dw = clamp(w * cols, 0, p_max_size.x)
	var dh = clamp(h * rows, 0, p_max_size.y)
	if cols == 1 and p_max_size.x < src.get_size().x:
		dw = p_max_size.x
	if rows == 1 and p_max_size.y < src.get_size().y:
		dh = p_max_size.y
	dest.create(dw, dh, false, src.get_format())

	for i in rows:
		for j in cols:
			src = p_image
			match p_mode:
				Tile.X:
					if (i & 1):
						src = src_fy
				Tile.Y:
					if (j & 1):
						src = src_fx
				Tile.XY:
					if (i & 1) and not (j & 1):
						src = src_fy
					elif not (i & 1) and (j & 1):
						src = src_fx
					elif (i & 1) and (j & 1):
						src = src_fxy

			dest.blit_rect(src, src_rect, Vector2(j * w, i * h))

	return dest
