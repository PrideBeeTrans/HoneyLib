tool
class_name DirectionalMotion2D,"res://addons/HoneyLib/Icons/Physics/DirectionalMotion2D.svg"
extends PhysicsMotion2D

var move_settings : Resource


func acceleration_to(move_direction: Vector2) -> void:
	var move_speed := move_settings.get_move_speed() as float if move_settings != null else 0.0
	var weight := move_settings.get_move_weight(move_direction) as float if move_settings != null else 0.0
	var move_to := move_direction.normalized() * move_speed
	set_direction(move_direction)
	get_actor().set_velocity(lerp(get_actor().get_velocity(), move_to, weight))


func decelerate() -> void:
	var move_to := Vector2.ZERO
	var weight := move_settings.get_move_weight(move_to) as float if move_settings != null else 0.0
	set_direction(move_to)
	get_actor().set_velocity(lerp(get_actor().get_velocity(), move_to, weight))


func get_class() -> String:
	return "DirectionalMotion2D"


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("DirectionalMotion2D")
	properties.add_resource("move_settings")
	return properties.get_properties()

