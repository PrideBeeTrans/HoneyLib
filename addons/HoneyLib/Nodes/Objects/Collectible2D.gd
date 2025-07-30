tool
class_name Collectible2D
extends ComponentArea2D

signal collected(collector)
signal collection_denied(collector)

var auto_remove := true setget set_auto_remove,is_auto_remove
var payload : Resource setget set_payload,get_payload


func can_collect(collector: Area2D) -> bool:
	return is_enabled()


func collect(collector: Area2D) -> bool:
	if not is_enabled() == true:
		emit_signal("collection_denied", collector)
		return false
	
	var result := execute_payload(collector)
	emit_signal("collected", collector)
	
	if is_auto_remove() == true and result == true:
		queue_free()
	return result


func execute_payload(collector: Area2D) -> bool:
	if get_payload() != null and get_payload().has_method("execute"):
		return get_payload().execute(self, collector)
	return true


func set_auto_remove(value: bool) -> void:
	auto_remove = value


func is_auto_remove() -> bool:
	return auto_remove


func set_payload(value: Resource) -> void:
	payload = value


func get_payload() -> Resource:
	return payload


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("Collectible2D")
	properties.add_resource("payload", "Resource")
	properties.add_property("auto_remove", TYPE_BOOL)
	return properties.get_properties()
