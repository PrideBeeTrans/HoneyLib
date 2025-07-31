## A modular UI component for managing screen transitions.
## Handles enter/exit transitions by calling optional callbacks on each screen.
## Supports editor configuration via an initial screen path.

tool
class_name ScreenContainer, "res://addons/HoneyLib/Icons/UI/ScreenContainer.svg"
extends ComponentControl

# Method names expected on screens
const METHOD_PLAY_IN := "play_in"
const METHOD_PLAY_OUT := "play_out"
const METHOD_ENTER := "enter"
const METHOD_EXIT := "exit"

## Path to the initial screen node
var initial_screen_path := NodePath() setget set_initial_screen_path, get_initial_screen_path

## Currently active screen (automatically resolved from the path on ready)
onready var screen := get_node_or_null(initial_screen_path) as Control setget set_screen, get_screen

## Called when the node is added to the scene tree
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	change_screen(get_screen())

## Changes the currently active screen, playing optional transition methods if available.
## param new_screen The Control node to switch to.
## param msg Optional data dictionary passed to enter/exit methods.
func change_screen(new_screen: Control, msg: Dictionary = {}) -> void:
	if has_play_out(get_screen()):
		get_screen().play_out()
		get_screen().exit(msg)

	set_screen(new_screen)

	if has_play_in(new_screen):
		get_screen().play_in()
		get_screen().enter(msg)

## Checks if a screen has a valid `play_in` method.
## param current_screen The Control to check.
func has_play_in(current_screen: Control) -> bool:
	return current_screen != null and current_screen.has_method(METHOD_PLAY_IN)

## Checks if a screen has a valid `play_out` method.
## param current_screen The Control to check.
func has_play_out(current_screen: Control) -> bool:
	return current_screen != null and current_screen.has_method(METHOD_PLAY_OUT)

## Sets the initial screen path.
func set_initial_screen_path(value: NodePath) -> void:
	initial_screen_path = value

## Returns the initial screen path.
func get_initial_screen_path() -> NodePath:
	return initial_screen_path

## Sets the current screen reference.
func set_screen(value: Control) -> void:
	screen = value

## Returns the current screen reference.
func get_screen() -> Control:
	return screen

## Customizes the property list to expose `initial_screen_path` in the editor.
func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("ScreenContainer")
	properties.add_node_path("initial_screen_path")
	return properties.get_properties()
