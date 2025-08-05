tool
class_name HurtBox2D,"res://addons/HoneyLib/Icons/Combat/HurtBox2D.svg"
extends ComponentArea2D

signal hurt(hitbox, damage_info)
signal hurt_denied(hitbox)

const CATEGORY_NAME := "HurtBox2D"

const PROPERTY_GROUP_NAME_PAYLOAD := "Payloads"
const PROPERTY_PAYLOAD_ON_HURT := "on_hurt"
const PROPERTY_DEBUG := "debug"

onready var health_stats := get_component(NodeRegistry.HEALTH_STATS) as HealthStats

var on_hurt : Resource
var debug := false setget set_debug, get_debug


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


func _on_area_entered(hitbox: Area2D) -> void:
	if not hitbox.has_method("can_hit") or not hitbox.has_method("hit"):
		return
	if hitbox.can_hit(self):
		var result := hitbox.hit(self) as bool
		if result != false:
			emit_signal("hurt", hitbox, result)
			_print("Hurt by: %s" % hitbox.get_name())
		else:
			emit_signal("hurt_denied", hitbox)
	else:
		emit_signal("hurt_denied", hitbox)


func _on_HealthStats_damage_taken(amount: int,source: Node,reason: String) -> void:
	var damage_info := {
		"amount":amount,
		"source":source,
		"reason":reason,
		"hurtbox":self
	}
	
	if on_hurt != null and on_hurt.has_method("execute"):
		on_hurt.execute(source, self, damage_info)
	
	_print("Damage taken: %d from %s (reason: %s)" % [amount, str(source), reason])


func get_class() -> String:
	return CATEGORY_NAME


func _print(message: String) -> void:
	if debug:
		print("[HurtBox2D] %s" % message)


func set_debug(value: bool) -> void:
	debug = value

func get_debug() -> bool:
	return debug


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category(CATEGORY_NAME)
	properties.add_bool(PROPERTY_DEBUG)
	properties.add_group(PROPERTY_GROUP_NAME_PAYLOAD)
	properties.add_resource(PROPERTY_PAYLOAD_ON_HURT, "Resource")
	return properties.get_properties()
