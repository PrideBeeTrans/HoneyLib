tool
class_name HitFlash2D
extends Component2D


var flash_color := Color.white setget set_flash_color,get_flash_color
var flash_duration := 0.1 setget set_flash_duration,get_flash_duration

onready var health_stats := get_component(NodeRegistry.HEALTH_STATS) as HealthStats


func set_flash_color(value: Color) -> void:
	flash_color = value


func get_flash_color() -> Color:
	return flash_color


func set_flash_duration(value: float) -> void:
	flash_duration = value


func get_flash_duration() -> float:
	return flash_duration


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("HitFlash2D")
	properties.add_color("flash_color")
	properties.add_float("flash_duration")
	return properties.get_properties()
