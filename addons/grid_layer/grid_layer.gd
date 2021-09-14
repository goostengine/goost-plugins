class_name GridLayer, "icon_grid_layer.svg" extends CanvasLayer
tool

# This class allows to display infinite grid at run-time, similarly to how
# editor displays grid with snapping is enabled in canvas editor.
# For example, when using Camera2D, the grid's origin offset and scale are
# going to be updated automatically.

func _init():
	 # Do not show grid on top, since we have transparent grid by default.
	layer = -1


func _ready():
	if not Engine.editor_hint:
		return

	if not has_grid():
		return

	# Instantiate a default GridRect with transparent background.
	var grid = GridRect.new()
	add_child(grid)
	if get_parent():
		if get_parent().filename:
			grid.owner = get_parent()
		else:
			grid.owner = get_parent().owner

	grid.origin_axes_visible = true

	grid.anchor_right = 1.0
	grid.anchor_bottom = 1.0
	grid.margin_right = 0.0
	grid.margin_bottom = 0.0

	var bc = Color()
	bc.a = 0.0 # Transparent by default.
	grid.set("custom_colors/background", bc)
	# Use default colors from GraphEdit.
	grid.set("custom_colors/line_cell", grid.get_color("grid_minor", "GraphEdit"))
	grid.set("custom_colors/line_division", grid.get_color("grid_major", "GraphEdit"))


func _process(_delta):
	for idx in get_child_count():
		var grid = get_child(idx)
		if not grid is GridRect:
			continue

		grid.origin_offset = get_viewport().canvas_transform.origin
		grid.origin_scale = get_viewport().canvas_transform.get_scale()


func _get_configuration_warning():
	if not has_grid():
		return "GridLayer must have at least one GridRect added as a child."
	return ""


func has_grid():
	for idx in get_child_count():
		if get_child(idx) is GridRect:
			return true
	return false
