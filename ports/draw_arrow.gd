# Initial prototype for drawing arrows, implemented in `Debug2D` singleton:
# https://github.com/goostengine/goost/commit/d4ba40cb57

func draw_arrow(from, to, color = Color.white, width = 1.0, tip = Vector2(8, 8), offset = 0.0):
	var vector = (to - from)
	var half_length = vector.length() * 0.5
	var tip_size = Vector2(max(tip.x, width), tip.y)

	if half_length < tip_size.y:
		var ratio = (half_length / tip_size.y)
		tip_size.y = tip_size.y * ratio
		tip_size.x = max(tip_size.x * ratio, width)

	var trans = Transform2D(vector.angle(), to)
	var dest
	if offset <= 0.0:
		dest = trans.xform(Vector2(-tip_size.y, 0))
	else:
		dest = to

	draw_line(from, dest, color, width, true)

	var points = PoolVector2Array([])
	var shift = Vector2(-vector.length() * offset, 0)
	points.push_back(trans.xform(shift))
	points.push_back(trans.xform(Vector2(-tip_size.y + shift.x, tip_size.x * 0.5)))
	points.push_back(trans.xform(Vector2(-tip_size.y + shift.x, -tip_size.x * 0.5)))

	draw_colored_polygon(points, color, [], null, null, true)
