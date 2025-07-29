tool
class_name GravitySettings
extends ModifiableResource

var gravity_mult := 2.0 setget set_gravity_mult,get_gravity_mult
var fall_mult := 2.0 setget set_fall_mult,get_fall_mult
var max_jump_height := 2.25 * 64 setget set_max_jump_height,get_max_jump_height
var min_jump_height := 0.8 * 64 setget set_min_jump_height,get_min_jump_height
var jump_duration := 0.4 setget set_jump_duration,get_jump_duration


func get_gravity(is_falling: bool) -> float:
	return get_fall_gravity() if is_falling == true else get_normal_gravity() 


func get_normal_gravity() -> float:
	return get_gravity_mult() * get_max_jump_height() / pow(get_jump_duration(), get_gravity_mult())


func get_fall_gravity() -> float:
	return get_normal_gravity() * get_fall_mult()


func get_jump_strength() -> float:
	return -sqrt(get_gravity_mult() * get_normal_gravity() * get_max_jump_height())


func get_release_strength() -> float:
	return -sqrt(get_gravity_mult() * get_normal_gravity() * get_min_jump_height())


func set_gravity_mult(value: float) -> void:
	gravity_mult = value


func get_gravity_mult() -> float:
	return gravity_mult


func set_fall_mult(value: float) -> void:
	fall_mult = value

	
func get_fall_mult() -> float:
	return fall_mult


func set_max_jump_height(value: float) -> void:
	max_jump_height = value

	
func get_max_jump_height() -> float:
	return max_jump_height


func set_min_jump_height(value: float) -> void:
	min_jump_height = value
	
	
func get_min_jump_height() -> float:
	return min_jump_height


func set_jump_duration(value: float) -> void:
	jump_duration = value

		
func get_jump_duration() -> float:
	return jump_duration


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("GravitySettings")
	properties.add_float("gravity_mult")
	properties.add_float("fall_mult")
	properties.add_group("Jump Settings")
	properties.add_float("max_jump_height")
	properties.add_float("min_jump_height")
	properties.add_float("jump_duration")
	return properties.get_properties()
