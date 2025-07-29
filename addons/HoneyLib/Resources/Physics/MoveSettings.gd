tool
class_name MoveSettings
extends ModifiableResource

enum TypeWeight{GROUNDED, FLOATING}


var move_speed := 5.0 * 64.0 setget set_move_speed,get_move_speed
var type_weight : int = TypeWeight.GROUNDED setget set_type_weight,get_type_weight
var acceleration := 0.4 setget set_acceleration,get_acceleration
var friction := 0.3 setget set_friction,get_friction
var air_control := 0.1 setget set_air_control,get_air_control
var air_brake := 0.02 setget set_air_brake,get_air_brake


func get_move_weight(move_direction) -> float:
	if move_direction is Vector2 or move_direction is Vector3:
		return get_acceleration() if move_direction.length() != 0.0 else get_friction()
	else:
		return get_acceleration() if move_direction != 0.0 else get_friction()


func get_air_weight(move_direction) -> float:
	if move_direction is Vector2 or move_direction is Vector3:
		return get_air_control() if move_direction.length() != 0.0 else get_air_brake()
	else:
		return get_air_control() if move_direction != 0.0 else get_air_brake()


func set_move_speed(value: float) -> void:
	move_speed = value


func get_move_speed() -> float:
	return get_final_stat("move_speed", move_speed)


func set_type_weight(value: int) -> void:
	type_weight = value
	property_list_changed_notify()


func get_type_weight() -> int:
	return type_weight


func is_type_grounded() -> bool:
	return get_type_weight() == TypeWeight.GROUNDED


func is_type_floating() -> bool:
	return get_type_weight() == TypeWeight.FLOATING


func set_acceleration(value: float) -> void:
	acceleration = value


func get_acceleration() -> float:
	return get_final_stat("acceleration", acceleration)


func set_friction(value: float) -> void:
	friction = value


func get_friction() -> float:
	return get_final_stat("friction", friction)


func set_air_control(value: float) -> void:
	air_control = value


func get_air_control() -> float:
	return get_final_stat("air_control", air_control)


func set_air_brake(value: float) -> void:
	air_brake = value


func get_air_brake() -> float:
	return get_final_stat("air_brake", air_brake)


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("MoveSettings")
	properties.add_int("move_speed")
	properties.add_enum("type_weight", "Grounded,Floating")
	properties.add_float("acceleration")
	properties.add_float("friction")
	if is_type_grounded() == true:
		properties.add_float("air_control")
		properties.add_float("air_brake")
	return properties.get_properties()
