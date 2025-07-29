tool
class_name HurtBox2D,"res://addons/HoneyLib/Icons/Combat/HurtBox2D.svg"
extends ComponentArea2D


onready var health_stats := get_component("HealthStats") as HealthStats


func _ready() -> void:
	pass


func get_class() -> String:
	return "HurtBox2D"


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("HurtBox2D")
	properties.add_group("Payloads")
	properties.add_resource("on_hurt", "Resource")
	properties.add_resource("on_death", "Resource")
	return properties.get_properties()
