## ValueResource.gd
## A reusable component for tracking and modifying an integer value with a max limit.
## Includes signals for when values change, reach zero, or fill up.

tool
class_name ValueResource
extends Component

## Emitted when the amount changes.
signal changed(old_amount, new_amount, reason)
## Emitted when the max amount changes.
signal max_changed(old_max, new_max, reason)
## Emitted when the amount increases.
signal increased(old_amount, new_amount, reason)
## Emitted when the amount decreases.
signal decreased(old_amount, new_amount, reason)
## Emitted when the amount reaches max.
signal filled(reason)
## Emitted when the amount reaches zero.
signal depleted(reason)

const EMPTY_AMOUNT := 0
const EMPTY_PERCENT_AMOUNT := 0.0
const MIN_AMOUNT := 1


## Max value allowed.
var max_amount := EMPTY_AMOUNT setget set_max_amount, get_max_amount
## Current value.
var amount := EMPTY_AMOUNT setget set_amount, get_amount


## Increase the value by a given amount.
func increase(value: int, reason := CauseType.INCREASE_AMOUNT) -> void:
	if value <= EMPTY_AMOUNT:
		return
	set_amount(amount + value, reason)


## Decrease the value by a given amount.
func decrease(value: int, reason := CauseType.DECREASE_AMOUNT) -> void:
	if value <= EMPTY_AMOUNT:
		return
	set_amount(amount - value, reason)


## Set the amount to max.
func reset(reason := CauseType.RESET_AMOUNT) -> void:
	set_amount(max_amount, reason)


## Set the max amount (minimum is 1).
func set_max_amount(value: int, reason := CauseType.MAX_ADJUST) -> void:
	max_amount = value
	max_amount = max(MIN_AMOUNT, value)
	emit_signal("max_changed", max_amount, reason)


func get_max_amount() -> int:
	return max_amount


## Set the current amount, clamped between 0 and max.
func set_amount(value: int, reason := CauseType.CHANGED_AMOUNT) -> void:
	var old_amount := amount
	amount = value
	amount = clamp(amount, EMPTY_AMOUNT, max_amount)

	if is_changed(old_amount):
		emit_signal("changed", amount, reason)
	if is_below(old_amount):
		emit_signal("decreased", old_amount, amount, reason)
	elif is_above(old_amount):
		emit_signal("increased", old_amount, amount, reason)

	if is_full():
		emit_signal("filled", reason)
	elif is_empty():
		emit_signal("depleted", reason)


func get_amount() -> int:
	return amount


## Get percent (0.0 to 1.0).
func get_percent() -> float:
	return (get_amount() / get_max_amount()) if get_max_amount() > EMPTY_PERCENT_AMOUNT else EMPTY_PERCENT_AMOUNT


## Check if value changed.
func is_changed(value: int) -> bool:
	return amount != value


## Check if current amount is greater than given value.
func is_above(value: int) -> bool:
	return amount > value


## Check if current amount is less than given value.
func is_below(value: int) -> bool:
	return amount < value


## Returns true if amount is zero.
func is_empty() -> bool:
	return get_amount() <= EMPTY_AMOUNT


## Returns true if amount is at max.
func is_full() -> bool:
	return get_amount() >= get_max_amount()


func get_class() -> String:
	return "ValueResource"
