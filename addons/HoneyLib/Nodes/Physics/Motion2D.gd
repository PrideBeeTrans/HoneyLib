tool
class_name Motion2D
extends Component2D

signal trajectory_started()
signal trajectory_updated(distance_traveled, remaining_distance)
signal trajectory_reached()
signal trajectory_reset()
signal trajectory_stopped()


var speed := 200.0



func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("Motion2D")
	properties.add_float("speed")
	properties.add_vector2("direction")
	properties.add_float("max_distance")
	return properties.get_properties()
