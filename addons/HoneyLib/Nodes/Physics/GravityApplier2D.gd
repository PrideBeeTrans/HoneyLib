tool
class_name GravityApplier2D
extends Component


var gravity_settings : Resource setget set_gravity_settings,get_gravity_settings


func apply_gravity(delta: float) -> void:
	var gravity := get_gravity()
	get_actor().set_velocity_y(get_actor().get_velocity_y() + gravity * delta)


func set_gravity_settings(value: Resource) -> void:
	gravity_settings = value


func get_gravity_settings() -> Resource:
	return gravity_settings


func get_gravity() -> float:
	if get_gravity_settings() == null or get_actor() == null:
		return 0.0
	return get_gravity_settings().get_gravity(get_actor().is_falling())


func _get_configuration_warning() -> String:
	var warning := ""
	if not get_owner() is PhysicsBody2D:
		warning = "This component requires a RigidBody2D or KinematicBody2D or EntityBody2D as its owner."
	return warning


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("GravityApplier2D")
	properties.add_resource("gravity_settings")
	return properties.get_properties()
