## KnockBack2D applies a directional force to the parent Node2D, simulating physical impacts like hits or explosions.
## Customizable through direction scaling, extra vector boost, and optional velocity reset.

tool
class_name KnockBack2D,"res://addons/HoneyLib/Icons/Physics/KnockBack2D.svg"
extends Component2D

signal knockback_applied(force)
signal knockback_failed(reason)


## The magnitude of the knockback. A scalar which multiplies the direction vector from the damage source.
var knockback_force := 150.0 setget set_knockback_force,get_knockback_force
## Scale applied to the incoming damage direction. Allows tuning horizontal/vertical push.
var knockback_direction := Vector2.LEFT setget set_knockback_direction,get_knockback_direction
## Additional fixed vector to apply (e.g. upward boost when hit).
var additional_vector := Vector2.ZERO setget set_additional_vector,get_additional_vector
## If true, zeroes the current velocity before applying knockback.
var reset_velocity := true setget set_reset_velocity,should_reset_velocity


func apply_knockback() -> void:
	if not is_enabled() == true:
		return
	
	if not get_actor() is Node2D:
		push_error("KnockBack2D must be on a Node2D.")
		emit_signal("knockback_failed", "Invalid actor")
		return
	
	var total_force := get_final_force()
	if get_actor() is EntityBody2D:
		if reset_velocity == true:
			get_actor().reset_velocity()
		get_actor().apply_impulse(total_force)
		
	emit_signal("knockback_applied", total_force)


func get_final_force() -> Vector2:
	var direction := get_knockback_direction().normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.LEFT
	return direction * knockback_force + additional_vector


func set_knockback_force(value: float) -> void:
	knockback_force = value


func get_knockback_force() -> float:
	return knockback_force


func set_knockback_direction(value: Vector2) -> void:
	knockback_direction = value
	

func get_knockback_direction() -> Vector2:
	return knockback_direction


func set_additional_vector(value: Vector2) -> void:
	additional_vector = value
	

func get_additional_vector() -> Vector2:
	return additional_vector


func set_reset_velocity(value: bool) -> void:
	reset_velocity = value
	

func should_reset_velocity() -> bool:
	return reset_velocity


func get_class() -> String:
	return "KnockBack2D"


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("KnockBack2D")
	properties.add_float("knockback_force")
	properties.add_vector2("damage_direction_scale")
	properties.add_vector2("additional_vector")
	properties.add_bool("reset_velocity")
	return properties.get_properties()
