## InputAxis2D.gd
## A configurable 2D input component for axis-based movement.
## Supports two input modes: Side Scroller (horizontal only) and Full Directional (4-way movement).
## Automatically validates assigned input actions, and provides a directional vector from user input.

tool
class_name InputAxis2D,"res://addons/HoneyLib/Icons/InputAxis2D.svg"
extends Component

## Input mode options:
## SIDE_SCROLLER: horizontal movement only.
## FULL_DIRECTIONAL: movement in both horizontal and vertical axes.
enum InputMode{SIDE_SCROLLER, FULL_DIRECTIONAL}

## The current input mode for this axis (default: SIDE_SCROLLER).
var input_mode : int = InputMode.SIDE_SCROLLER setget set_input_mode,get_input_mode

## List of valid input actions that can be assigned to movement directions.
var input_list := [] setget set_input_list,get_input_list

## Input action for moving left (string name from InputMap).
var move_left := "none" setget set_move_left,get_move_left

## Input action for moving right.
var move_right := "none" setget set_move_right,get_move_right

## Input action for moving up (used only in FULL_DIRECTIONAL mode).
var move_up := "none" setget set_move_up,get_move_up

## Input action for moving down (used only in FULL_DIRECTIONAL mode).
var move_down := "none" setget set_move_down,get_move_down


func _ready() -> void:
	if Engine.is_editor_hint() == true:
		return
	_validate_input_bindings()


## Ensures all assigned input actions exist in the Input Map.
func _validate_input_bindings() -> void:
	var missings := PoolStringArray()
	if get_move_left() == "none" or not InputMap.has_action(get_move_left()):
		missings.append("move_left")
	if get_move_right() == "none" or not InputMap.has_action(get_move_right()):
		missings.append("move_right")
	if is_input_mode_full_directional() == true:
		if get_move_up() == "none" or not InputMap.has_action(get_move_up()):
			missings.append("move_up")
		if get_move_down() == "none" or not InputMap.has_action(get_move_down()):
			missings.append("move_down")
	
	if missings.size() > 0:
		push_error("InputAxis: Missing or invalid input actions: %s. These must be assigned and exist in Project > Input Map." % missings.join(", ") )


# --- Setters/Getters ---
func set_input_mode(value: int) -> void:
	input_mode = value
	property_list_changed_notify()


func set_input_list(value: Array) -> void:
	input_list = value
	property_list_changed_notify()


func get_input_list() -> Array:
	return input_list


func get_input_mode() -> int:
	return input_mode


func set_move_left(value: String) -> void:
	move_left = value


func get_move_left() -> String:
	return move_left


func set_move_right(value: String) -> void:
	move_right = value


func get_move_right() -> String:
	return move_right


func set_move_up(value: String) -> void:
	move_up = value


func get_move_up() -> String:
	return move_up


func set_move_down(value: String) -> void:
	move_down = value


func get_move_down() -> String:
	return move_down


# --- Core Logic ---

## Helper to set all input actions at once.
func set_all_inputs(left: String, right: String, up: String = "none", down: String = "none") -> void:
	set_move_left(left)
	set_move_right(right)
	set_move_up(up)
	set_move_down(down)


## Prints input state to the console (for debugging).
func print_debug_input() -> void:
	print_debug("Direction: ", get_input_direction())
	print_debug("Raw: ", get_raw_input_axis())
	print_debug("Moving? ", is_moving())


## Returns true if the input vector is non-zero (player is giving directional input).
func is_moving() -> bool:
	return not get_input_direction().is_equal_approx(Vector2.ZERO)


## Returns the raw input axis from pressed keys (without normalization).
func get_raw_input_axis() -> Vector2:
	var x := int(Input.is_action_pressed(get_move_right())) - int(Input.is_action_pressed(get_move_left()))
	var y := int(Input.is_action_pressed(get_move_down())) - int(Input.is_action_pressed(get_move_up()))
	return Vector2(x, y)


## Returns normalized direction vector from input.
func get_normalized_direction() -> Vector2:
	var dir := get_input_direction()
	return dir.normalized() if dir.length() > 0 else Vector2.ZERO


## Returns the angle (in radians) of the current input direction.
func get_facing_angle() -> float:
	var dir := get_input_direction()
	return dir.angle() if dir.length() > 0 else 0.0


## Returns the 2D directional input vector (Vector2).
func get_input_direction() -> Vector2:
	if not has_valid_input() == true:
			return Vector2.ZERO
	elif is_input_mode_side_scroller() == true:
		return Vector2(Input.get_axis(get_move_left(), get_move_right()), 0)
	elif is_input_mode_full_directional() == true:
		return Input.get_vector(get_move_left(), get_move_right(), get_move_up(), get_move_down())
	return Vector2.ZERO


## Returns true if any valid directional inputs are configured.
func has_valid_input() -> bool:
	return has_valid_horizontal_input() or has_valid_vertical_input()
		
		
## Checks if left/right inputs are valid.
func has_valid_horizontal_input() -> bool:
	return InputMap.has_action(get_move_left()) == true or InputMap.has_action(get_move_right()) == true


## Checks if up/down inputs are valid.
func has_valid_vertical_input() -> bool:
	return InputMap.has_action(get_move_up()) == true or InputMap.has_action(get_move_down()) == true

# --- Utility ---

## Returns true if the current input mode is SIDE_SCROLLER.
func is_input_mode_side_scroller() -> bool:
	return get_input_mode() == InputMode.SIDE_SCROLLER
	
	
## Returns true if the current input mode is FULL_DIRECTIONAL.
func is_input_mode_full_directional() -> bool:
	return get_input_mode() == InputMode.FULL_DIRECTIONAL
	

# --- Editor Integration ---

## Prevents this node from being automatically included in resource maps.
func _include_resource_map() -> bool:
	return false
	

## Customizes how this node's properties appear in the Inspector.
func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	if not input_list.has("none"):
		input_list.append("none")
	properties.add_category("InputAxis2D")
	properties.add_enum("input_mode", "Side Scroller,Full Directional")
	properties.add_array_string("input_list")
	properties.add_enum_string("move_left", PoolStringArray(input_list).join(","))
	properties.add_enum_string("move_right", PoolStringArray(input_list).join(","))
	if is_input_mode_full_directional() == true:
		properties.add_enum_string("move_up", PoolStringArray(input_list).join(","))
		properties.add_enum_string("move_down", PoolStringArray(input_list).join(","))
	return properties.get_properties()
