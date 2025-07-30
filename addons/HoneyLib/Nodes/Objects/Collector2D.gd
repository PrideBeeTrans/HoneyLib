tool
class_name Collector2D
extends ComponentArea2D

signal item_collected(item, payload_result)
signal collection_failed(item)

var debug := false setget set_debug,get_debug


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	_connect_area()


func _connect_area() -> void:
	connect("area_entered", self, "_on_area_entered")


func _on_area_entered(collectible: Area2D) -> void:
	if not collectible.has_method("can_collect") == true and not collectible.has_method("collect") == true:
		return
	if collectible.can_collect(self):
		var result : bool = collectible.collect(self)
		if result != false:
			emit_signal("item_collected", collectible, result)
			_print("Item Collect: %s" % collectible.get_name())
		else:
			_print("Fails to collect: %s" % collectible.get_name())


func _print(message: String) -> void:
	if get_debug() == true:
		print("[Collector] %s" % message)


func set_debug(value: bool) -> void:
	debug = value


func get_debug() -> bool:
	return debug


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("Collector2D")
	properties.add_property("debug", TYPE_BOOL)
	return properties.get_properties()
