## ValueRange.gd
## A reusable component for tracking and modifying a floating point value within a configurable range.
## Supports min/max limits, stepping, optional rounding, and automatic regeneration.
## Emits signals when values change, reach min/max, increase, decrease, or regenerate.

tool
class_name ValueRange
extends Component

## Emitted when the current value changes.
signal changed(old_value, new_value, reason)
## Emitted when the maximum allowed value changes.
signal max_changed(old_max, new_max, reason)
## Emitted when the minimum allowed value changes.
signal min_changed(old_min, new_min, reason)
## Emitted when the value increases.
signal increased(old_value, new_value, reason)
## Emitted when the value decreases.
signal decreased(old_value, new_value, reason)
## Emitted when the value reaches the maximum.
signal filled(reason)
## Emitted when the value reaches the minimum.
signal depleted(reason)
## Emitted when the value regenerates automatically.
signal regenerated(amount_recovered)

const EMPTY_VALUE := 0.0
const MIN_STEP := 0.0001

## Minimum allowed value.
var min_value := 0.0 setget set_min_value,get_min_value

## Maximum allowed value.
var max_value := 100.0 setget set_max_value,get_max_value

## Step increment/decrement amount.
var step := 1.0 setget set_step,get_step

## Page increment/decrement amount, usually larger than step.
var page := 0.0 setget set_page,get_page

## Enable exponential editing (reserved for future use).
var exp_edit := false setget set_exp_edit,get_exp_edit

## Round values to nearest integer if true.
var rounded := false setget set_rounded,is_rounded

## Allow value to exceed maximum if true.
var allow_greater := false setget set_allow_greater,is_allow_greater

## Allow value to go below minimum if true.
var allow_lesser := false setget set_allow_lesser,is_allow_lesser

## Enable automatic regeneration.
var regenerate := false setget set_regenerate,can_regenerate

## Time interval between regeneration ticks (seconds).
var regen_interval := 1.0 setget set_regen_interval,get_regen_interval

## Amount recovered each regeneration tick.
var regen_step := 0.1 setget set_regen_step,get_regen_step

## Current value of the range.
var value := EMPTY_VALUE setget set_value,get_value

var _regen_timer := 0.0

## Called every frame; handles automatic regeneration if enabled.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == true:
		return
	if can_regenerate() == true and get_value() < get_max_value():
		_regen_timer += delta
	while _regen_timer >= get_regen_interval() and get_value() < get_max_value():
		_regen_timer -= get_regen_interval()


## Increase the current value by the specified amount
func increase(amount: float, reason: String = CauseType.INCREASE_VALUE) -> void:
	if get_value() <= 0:
		return
	set_value(get_value() + amount, reason)


## Increase value by the configure page amount if > MIN_STEP,else step amount.
func increase_page(reason: String = CauseType.PAGE_INCREASE) -> void:
	if get_page() > MIN_STEP:
		increase(page, reason)
	else:
		increase(get_step(), reason)


## Increase valye by the configured step amount.
func increase_step(reason: String = CauseType.STEP_INCREASE) -> void:
	increase(get_step(), reason)


## Decrease value by the configured step amount.
func decrease_step(reason: String = CauseType.STEP_DECREASE) -> void:
	decrease(get_step(), reason)


## Decrease the current value by the specified amount.
func decrease(amount: float, reason: String = CauseType.DECREASE_VALUE) -> void:
	if get_value() <= 0:
		return
	set_value(get_value() - amount, reason)
	
	
func set_value(new_value: float,reason: String = CauseType.CHANGED_VALUE) -> void:
	if not is_allow_greater() == true and new_value > get_max_value():
		new_value = get_max_value()
	if not is_allow_lesser() == true and new_value < get_min_value():
		new_value = get_min_value()
	if is_rounded() == true:
		new_value = round(new_value)
	value = new_value
	var old_value := get_value()
	if old_value != value:
		emit_signal("changed", old_value, get_value(), reason)
	elif get_value() < old_value:
		emit_signal("increased", old_value, get_value(), reason)
	
	if is_full() == true:
		emit_signal("filled", reason)
	elif is_empty() == true:
		emit_signal("depleted", reason)

## Returns true if current value is at or below minimum.
func is_empty() -> bool:
	return get_value() <= get_min_value()


## Returns true if current value is at or above maximum.
func is_full() -> bool:
	return get_value() >= get_max_value()
	
## Returns the normalized percent (0.0 to 1.0) of current value between min and max
func get_percent() -> float:
	if get_max_value() - get_min_value() == 0:
		return 0.0
	return (get_value() - get_min_value()) / (get_max_value() - get_min_value())


func get_value() -> float:
	return value


func set_min_value(value: float) -> void:
	min_value = value


func get_min_value() -> float:
	return min_value


func set_max_value(value: float) -> void:
	max_value = value


func get_max_value() -> float:
	return max_value


func set_step(value: float) -> void:
	step = value


func get_step() -> float:
	return step


func set_page(value: float) -> void:
	page = value


func get_page() -> float:
	return page


func set_regen_interval(value: float) -> void:
	regen_interval = value


func get_regen_interval() -> float:
	return regen_interval


func set_regen_step(value: float) -> void:
	regen_step = value


func get_regen_step() -> float:
	return regen_step


func set_exp_edit(value: bool) -> void:
	exp_edit = value


func get_exp_edit() -> bool:
	return exp_edit


func set_rounded(value: bool) -> void:
	rounded = value


func is_rounded() -> bool:
	return rounded


func set_allow_greater(value: bool) -> void:
	allow_greater = value


func is_allow_greater() -> bool:
	return allow_greater


func set_allow_lesser(value: bool) -> void:
	allow_lesser = value


func is_allow_lesser() -> bool:
	return allow_lesser


func set_regenerate(value: bool) -> void:
	regenerate = value


func can_regenerate() -> bool:
	return regenerate


func _set(property: String, value) -> bool:
	if property == "can_regenerate":
		set_regenerate(value)
		return true
	return false


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("ValueRange")
	properties.add_group("Range Limits")
	properties.add_range("min_value", TYPE_REAL, "min")
	properties.add_range("max_value", TYPE_REAL, "max")
	properties.add_group("Value Control")
	properties.add_float("step")
	properties.add_bool("exp_edit")
	properties.add_bool("rounded")
	properties.add_bool("allow_greater")
	properties.add_bool("allow_lesser")
	properties.add_group("Regeneration")
	properties.add_bool("can_regenerate")
	properties.add_float("regen_interval")
	properties.add_float("regen_step")
	return properties.get_properties()
