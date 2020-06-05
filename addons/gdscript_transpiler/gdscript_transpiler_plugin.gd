tool
extends EditorPlugin

var transpiler


func _enter_tree():
	assert(Engine.get_version_info().major >= 3)

	transpiler = preload('gdscript_transpiler_window.tscn').instance()
	transpiler.connect("transpile_request", self, "_on_transpile_request")
	transpiler.connect('update_request', self, '_on_update_request')
	get_editor_interface().get_base_control().add_child(transpiler)

	add_transpiler_menu_item(tr('Transpile GDScript'), '_on_transpiler_pressed')


func _exit_tree():
	if transpiler:
		transpiler.queue_free()
		remove_transpiler_menu_item(tr('Transpile GDScript'))


func add_transpiler_menu_item(p_name, p_callback):
	if Engine.get_version_info().hex >= 0x030100:
		add_tool_menu_item(p_name, self, p_callback)


func remove_transpiler_menu_item(p_name):
	if Engine.get_version_info().hex >= 0x030100:
		remove_tool_menu_item(p_name)


func _on_transpiler_pressed(_data):
	update_script()
	transpiler.display()


func _on_update_request():
	update_script()


func update_script():
	var script = get_editor_interface().get_script_editor().get_current_script()
	transpiler.set_script(script)


func _on_transpile_request(script_path, language, output_path):
	var script = load(script_path)
	var script_file_no_ext = script_path.get_basename().get_file().split(".")[0]

	var lang = language.to_lower()

	var output = GDScriptTranspiler.transpile(script, language)

	match lang:
		"c++":
			var h = File.new()
			h.open("%s.h" % output_path.plus_file(script_file_no_ext), File.WRITE)
			h.store_string(output.header)
			h.close()

			var cpp = File.new()
			cpp.open("%s.cpp" % output_path.plus_file(script_file_no_ext), File.WRITE)
			cpp.store_string(output.source)
			cpp.close()
