tool
extends AcceptDialog

signal transpile_request(script_path, language, output_path)
signal update_request()

var current_script = null


func _ready():
	get_ok().text = "Transpile"
	$body/script/hbox/button.icon = get_icon("Load", "EditorIcons")
	$body/output/hbox/button.icon = get_icon("Load", "EditorIcons")

	var ext = "gd"
	$script_dialog.mode = FileDialog.MODE_OPEN_FILE
	$script_dialog.filters = ["*.%s ; GDScript Files" % ext]

	$output_dialog.mode = FileDialog.MODE_OPEN_DIR
	$output_dialog.filters = []


func set_script(p_script):
	current_script = p_script
	$body/script/hbox/path.text = current_script.resource_path
	$body/output/hbox/path.text = current_script.resource_path.get_base_dir()

	$body/language/container/option.clear()
	for lang in GDScriptTranspiler.get_supported_languages():
		$body/language/container/option.add_item(lang)


func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.echo:
		if event.alt and event.scancode == KEY_G:
			if not visible:
				display()
			else:
				hide()


func display():
	emit_signal("update_request")
	popup_centered_ratio(0.25)


func _on_script_button_pressed():
	$script_dialog.popup_centered_ratio(0.5)


func _on_output_button_pressed():
	$output_dialog.popup_centered_ratio(0.5)


func _on_script_dialog_confirmed():
	$body/script/hbox/path.text = $script_dialog.current_file


func _on_output_dialog_confirmed():
	$body/output/hbox/path.text = $script_dialog.current_dir


func _on_window_confirmed():
	var script_path = $body/script/hbox/path.text
	var lang_opt = $body/language/container/option
	var language = lang_opt.get_item_text(lang_opt.selected)
	var output_path = $body/output/hbox/path.text
	emit_signal("transpile_request", script_path, language, output_path)
