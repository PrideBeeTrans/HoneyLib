tool
class_name StartingStats
extends Resource

var max_health := 1 setget set_max_health,get_max_health


func set_max_health(value: int) -> void:
	max_health = value


func get_max_health() -> int:
	return max_health


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("StartingStats")
	properties.add_int("max_health")
	return properties.get_properties()
