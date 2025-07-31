tool
extends EditorPlugin


const AUTOLOAD_PATHS := {
	"EventBus":"res://addons/HoneyLib/Autoload/EventBus.gd",
}


func _enter_tree() -> void:
	_add_singletons()


func _exit_tree() -> void:
	_remove_singletons()


func _add_singletons() -> void:
	for singleton_name in AUTOLOAD_PATHS:
		var singleton_path := AUTOLOAD_PATHS.get(singleton_name, "None") as String
		add_autoload_singleton(singleton_name, singleton_path)


func _remove_singletons() -> void:
	for singleton_name in AUTOLOAD_PATHS:
		remove_autoload_singleton(singleton_name)
