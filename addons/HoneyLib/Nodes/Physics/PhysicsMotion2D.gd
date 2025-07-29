tool
class_name PhysicsMotion2D,"res://addons/HoneyLib/Icons/Physics/PhysicsMotion2D.svg"
extends Component


var direction := Vector2.ZERO setget set_direction,get_direction


func acceleration_to(move_direction) -> void:
	push_warning("%s: acceleration_to() not implement" % self)


func decelerate() -> void:
	push_warning("%s: decelerate() not implement" % self)


func set_direction(value: Vector2) -> void:
	direction = value


func get_direction() -> Vector2:
	return direction


func _enter_tree() -> void:
	update_configuration_warning()


func _exit_tree() -> void:
	update_configuration_warning()


func _get_configuration_warning() -> String:
	var warning := ""
	if not get_owner() is PhysicsBody2D:
		warning = "This component requires a RigidBody2D or KinematicBody2D or EntityBody2D as its owner."
	return warning
