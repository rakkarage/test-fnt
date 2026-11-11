@tool
extends Control

@onready var test_label = $VBoxContainer/TestLabel
@onready var size_label = $VBoxContainer/SizeLabel
@onready var test_label2 = $VBoxContainer/TestLabel2
@onready var size_label2 = $VBoxContainer/SizeLabel2
@onready var test_label3 = $VBoxContainer/TestLabel3
@onready var size_label3 = $VBoxContainer/SizeLabel3

func _ready():
	# Connect to window resize so it updates when toggling fullscreen
	get_window().size_changed.connect(_update_measurements)
	
	# Wait a frame to ensure layout is calculated
	await get_tree().process_frame
	_update_measurements()

# Add this function to toggle fullscreen
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F11:
		var current_mode = DisplayServer.window_get_mode()
		if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Moved your measurement code into a function so it can be called on resize
func _update_measurements():
	# Test 1
	var font = test_label.get_theme_font("font")
	var font_size = test_label.get_theme_font_size("font_size")
	var string_size = font.get_string_size("ABCDEFG", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var font_height = font.get_height(font_size)
	size_label.text = "Font Size setting: %d\nMeasured Text: %d x %d\nFont Height: %d" % [
		font_size, string_size.x, string_size.y, font_height
	]
	print("--- MVP DEBUG 1 ---")
	print("Font Height: ", font_height, " | Measured String: ", string_size)

	# Test 2
	var font2 = test_label2.get_theme_font("font")
	var font_size2 = test_label2.get_theme_font_size("font_size")
	var string_size2 = font2.get_string_size("ABCDEFG", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size2)
	var font_height2 = font2.get_height(font_size2)
	size_label2.text = "Font Size setting: %d\nMeasured Text: %d x %d\nFont Height: %d" % [
		font_size2, string_size2.x, string_size2.y, font_height2
	]
	print("--- MVP DEBUG 2 ---")
	print("Font Height: ", font_height2, " | Measured String: ", string_size2)

	# Test 3
	var font3 = test_label3.get_theme_font("font")
	var font_size3 = test_label3.get_theme_font_size("font_size")
	var string_size3 = font3.get_string_size("ABCDEFG", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size3)
	var font_height3 = font3.get_height(font_size3)
	size_label3.text = "Font Size setting: %d\nMeasured Text: %d x %d\nFont Height: %d" % [
		font_size3, string_size3.x, string_size3.y, font_height3
	]
	print("--- MVP DEBUG 3 ---")
	print("Font Height: ", font_height3, " | Measured String: ", string_size3)