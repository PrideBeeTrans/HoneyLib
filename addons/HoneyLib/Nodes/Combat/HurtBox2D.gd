tool
class_name HurtBox2D,"res://addons/HoneyLib/Icons/Combat/HurtBox2D.svg"
extends ComponentArea2D

const CATEGORY_NAME := "HurtBox2D"

const PROPERTY_GROUP_NAME_PAYLOAD := "Payloads"
const PROPERTY_PAYLOAD_ON_HURT := "on_hurt"

onready var health_stats := get_component(NodeRegistry.HEALTH_STATS) as HealthStats


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	_connect_area()
	_connect_health_stats()


func _connect_health_stats() -> void:
	if health_stats == null:
		return
	health_stats.connect("damage_taken", self, "_on_HealthStats_damage_taken")


func _connect_area() -> void:
	connect("area_entered", self, "_on_area_entered")


func _on_area_entered(area: Area2D) -> void:
	pass


func _on_HealthStats_damage_taken(amount: int,source: Node,reason: String) -> void:
	pass


func get_class() -> String:
	return CATEGORY_NAME


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category(CATEGORY_NAME)
	properties.add_group(PROPERTY_GROUP_NAME_PAYLOAD)
	properties.add_resource(PROPERTY_PAYLOAD_ON_HURT, "Resource")
	return properties.get_properties()
