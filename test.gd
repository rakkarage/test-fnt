@tool
extends Control

@onready var grid: GridContainer = $ScrollContainer/VBoxContainer/SizeGrid

const SAMPLE := "ABCDEFG 0123"

func _ready():
	get_window().size_changed.connect(_update_grid)
	await get_tree().process_frame
	_build_grid()
	_update_grid()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		var current_mode = DisplayServer.window_get_mode()
		if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _build_grid():
	for child in grid.get_children():
		child.queue_free()

	var fonts := [
		{"name": "SuperWhite", "font": load("res://Font/SuperWhite.fnt"), "base": 12},
		{"name": "SuperBlack", "font": load("res://Font/SuperBlack.fnt"), "base": 12},
		{"name": "Venice", "font": load("res://Font/Venice.fnt"), "base": 16},
	]
	var scales := [1, 2, 4]

	# Header row
	_add_header("Font")
	for s in scales:
		_add_header("x%d" % s)

	for entry in fonts:
		var name_label := Label.new()
		name_label.text = "%s\n(base %d)" % [entry.name, entry.base]
		grid.add_child(name_label)

		for s in scales:
			var cell := VBoxContainer.new()
			var sample := Label.new()
			sample.text = SAMPLE
			var font_size: int = entry.base * s
			sample.add_theme_font_override("font", entry.font)
			sample.add_theme_font_size_override("font_size", font_size)
			sample.set_meta("font_res", entry.font)
			sample.set_meta("font_size", font_size)
			sample.set_meta("scale", s)

			var metrics := Label.new()
			metrics.autowrap_mode = TextServer.AUTOWRAP_OFF
			metrics.set_meta("metrics_for", sample.get_path())

			cell.add_child(sample)
			cell.add_child(metrics)
			grid.add_child(cell)

func _add_header(text: String) -> void:
	var l := Label.new()
	l.text = text
	grid.add_child(l)

func _update_grid():
	if not is_instance_valid(grid):
		return
	# GridContainer holds header + 3 rows * 4 cols = 16 children
	for cell in grid.get_children():
		if cell is VBoxContainer:
			var sample: Label = cell.get_child(0)
			var metrics: Label = cell.get_child(1)
			var font: Font = sample.get_theme_font("font")
			var font_size: int = sample.get_theme_font_size("font_size")
			var string_size := font.get_string_size(sample.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
			var font_height := font.get_height(font_size)
			var ascent := font.get_ascent(font_size)
			var descent := font.get_descent(font_size)
			metrics.text = "size=%d\nmeasured=%dx%d\nheight=%d (a=%d d=%d)" % [
				font_size, int(string_size.x), int(string_size.y), font_height, ascent, descent
			]
			print("--- %s x%s --- size=%d measured=%s height=%d ascent=%d descent=%d" % [
				font.resource_path.get_file(), sample.get_meta("scale"), font_size, string_size, font_height, ascent, descent
			])