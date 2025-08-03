## HealthStats.gd
## A specialized ValueResource for managing health, including taking damage, healing,
## and syncing with a starting stats resource.

tool
class_name HealthStats,"res://addons/HoneyLib/Icons/Combat/HealthStats.svg"
extends ValueResource

const RESET_ON_CHANGE := true
const KEEP_CURRENT_HEALTH := false

signal stats_changed(new_stats)
signal damage_taken(amount, source, reason)
signal healed(amount, source, reason)

## Optional resource used to initialize health values.
var starting_stats : Resource setget set_starting_stats,get_starting_stats
## Fallback max health value if starting_stats is not assigned or invalid.
var default_max_health := 1 setget set_default_max_health,get_default_max_health


func _ready() -> void:
	_validate_starting_stats()


## Changes the starting_stats to a new valid resource.
## Changes the starting_stats to a new valid resource.
## You can control whether health is reset using the constants:
## - RESET_ON_CHANGE
## - KEEP_CURRENT_HEALTH
## Warns if the resource is invalid.
func change_stats(new_stats: Resource,reset_health : bool = RESET_ON_CHANGE) -> void:
	if new_stats == null:
		push_warning("change_stats(): Provided resource is null.")
		return
	
	if not new_stats is StartingStats:
		push_warning("change_stats(): Resource must inherit from StartingStats")
		return
	
	set_starting_stats(new_stats)
	
	if reset_health == true:
		reset(CauseType.RESET_HEALTH)


## Resets current health to the maximum value.
func reset_health(reason := CauseType.RESET_HEALTH) -> void:
	reset(reason)


## Applies damage to current health. Cannot go below zero.
func take_damage(amount: int, source: Node = null, reason := CauseType.DAMAGE) -> void:
	decrease(amount, reason)
	emit_signal("damage_taken", amount, source, reason)


## Restores health by the given amount. Cannot exceed max health.
func heal(amount: int, source: Node = null, reason := CauseType.HEAL) -> void:
	increase(amount, reason)
	emit_signal("healed", amount, source, reason)

## Reload life completely
func restore_full_health(reason := CauseType.RESTORE_HEALTH) -> void:
	reset(reason)


## Instantly sets the current health value.
func set_health(amount: int, reason := CauseType.SET_HEALTH) -> void:
	set_amount(amount, reason)


## Instantly sets the maximum health value.
func set_max_health(amount: int, reason := CauseType.SET_MAX_HEALTH) -> void:
	set_max_amount(amount, reason)


## Returns the current health.
func get_health() -> int:
	return get_amount()


## Returns the maximum health.
func get_max_health() -> int:
	return get_max_amount()


## Returns true if current health is zero.
func is_dead() -> bool:
	return is_empty()


## Returns true if health is full (current equals max).
func is_full_health() -> bool:
	return is_full()


func get_class() -> String:
	return "HealthStats"

# --- Setters/Getters ---
func set_starting_stats(value: Resource) -> void:
	starting_stats = value
	emit_signal("stats_changed", get_starting_stats())
	update_configuration_warning()


func get_starting_stats() -> Resource:
	return starting_stats


func set_default_max_health(value: int) -> void:
	default_max_health = value


func get_default_max_health() -> int:
	return default_max_health


func get_base_max_health() -> int:
	return get_starting_stats().get_max_health() if get_starting_stats() != null else get_default_max_health()


# Returns percentage of life (0.0 to 1.0)
func get_health_percentage() -> float:
	return get_percent()


func _validate_starting_stats() -> void:
	if Engine.is_editor_hint() == true:
		return
	
	if get_starting_stats() == null:
		push_warning("HealthStats: No starting_stats assigned. Falling back to default_max_health.")


func _get_configuration_warning() -> String:
	var warning := ""
	if get_starting_stats() == null:
		warning = "HealthStats: No starting_stats assigned. Default values may be incorrect or incomplete."
	elif not starting_stats.has_method("get_max_health") and get_starting_stats() != null:
		warning = "HealthStats: The assigned starting_stats is not a valid resource with get_max_health()."
	return warning


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("HealthStats")
	properties.add_resource("starting_stats")
	properties.add_int("default_max_health")
	return properties.get_properties()
