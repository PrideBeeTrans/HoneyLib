tool
class_name ModifierData
extends Resource

enum ModifierType{ADD, MULTIPLY, OVERRIDE}
enum ValueType{INT, FLOAT, BOOL}

var stat_name := "" setget set_stat_name,get_stat_name
var modifier_type : int = ModifierType.ADD setget set_modifier_type,get_modifier_type
var value_type : int = ValueType.FLOAT setget set_value_type,get_value_type
var value := 0.0 setget set_value,get_value
var source := "" setget set_source,get_source
var priority := 0 setget set_priority,get_priority
var duration := -1.0 setget set_duration,get_duration


func set_stat_name(value: String) -> void:
	stat_name = value


func get_stat_name() -> String:
	return stat_name


func set_modifier_type(value: int) -> void:
	modifier_type = value


func get_modifier_type() -> int:
	return modifier_type


func set_value_type(value: int) -> void:
	value_type = value


func get_value_type() -> int:
	return value_type


func set_value(new_value: float) -> void:
	value = new_value


func get_value() -> float:
	return value


func set_source(value: String) -> void:
	source = value


func get_source() -> String:
	return source


func set_priority(value: int) -> void:
	priority = value


func get_priority() -> int:
	return priority


func set_duration(value: float) -> void:
	duration = value


func get_duration() -> float:
	return duration


func is_expired() -> bool:
	return duration > 0


func get_typed_value():
	if value_type == ValueType.INT:
		return int(value)
	elif value_type == ValueType.FLOAT:
		return float(value)
	elif value_type == ValueType.BOOL:
		return bool(value)
	return value


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("ModifierData")
	properties.add_property("stat_name", TYPE_STRING)
	properties.add_enum("modifier_type", "Int,Float,Bool")
	properties.add_enum("value", "Add,Multiply,Override")
	properties.add_property("value", TYPE_REAL)
	properties.add_property("source", TYPE_STRING)
	properties.add_property("priority", TYPE_INT)
	properties.add_property("duration", TYPE_REAL)
	return properties.get_properties()
