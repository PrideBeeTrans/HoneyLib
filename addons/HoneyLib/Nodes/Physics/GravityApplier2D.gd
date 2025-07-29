tool
class_name GravityApplier2D
extends Component



func _get_configuration_warning() -> String:
	var warning := ""
	if not get_owner() is PhysicsBody2D:
		warning = "This component requires a RigidBody2D or KinematicBody2D or EntityBody2D as its owner."
	return warning
