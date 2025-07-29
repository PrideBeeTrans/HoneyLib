## StateMachine.gd
## A flexible and modular finite state machine (FSM) component.
## Allows defining and switching between named states, each with optional enter, exit, update, and input callbacks.
## Emits signals for transitions, state activity, and input handling.

tool
class_name StateMachine,"res://addons/HoneyLib/Icons/System/StateMachine.svg"
extends Component

## Emitted when the current state changes.
## param state The new state object.
## param state_name The name of the new state.
signal state_changed(state, state_name)

## Emitted when the previous state changes.
## param state The previous state object.
## param state_name The name of the previous state.
signal previous_state_changed(state, state_name)

const NullState := null

var callback_target_path := NodePath(".") setget set_callback_target_path,get_callback_target_path

## Currently active state.
var state : State
## Previously active state.
var previous_state : State

onready var callback_target := get_node_or_null(callback_target_path) as Node setget set_callback_target,get_callback_target
## Dictionary of all registered states.
var states := {}


func _ready() -> void:
	if Engine.is_editor_hint() == true:
		return
	if get_callback_target() == null:
		push_error("CallBack Target is null")
		

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() == true:
		return
	if get_state() != NullState:
		get_state().on_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint() == true:
		return
	if get_state() != NullState:
		get_state().on_input(event)


## Creates and registers a new state.
## @param state_name The name of the state.
## @param instance Object which owns the callbacks.
## @return The created State instance.
func create_state(state_name: String) -> State:
	var new_state := State.new(get_callback_target())
	new_state.set_state_name(state_name)
	states[state_name] = state
	return new_state


func set_initial_state(init_state: State) -> void:
	if Engine.is_editor_hint() == true:
		return
	call_deferred("change_state", init_state)


## Change to a registered state.
func change_state(new_state: State) -> void:
	if not states.has(new_state.get_state_name()):
		push_warning("State not found: %s" % new_state.get_state_name())
		return
	
	if get_state() != NullState:
		get_state().on_exit()
	
	set_previous_state(state)
	set_state(new_state)
	emit_signal("state_changed", get_state(), get_state_name())
	emit_signal("previous_state_changed", get_previous_state(), get_previous_state_name())
	
	if get_state() != NullState:
		get_state().on_enter()

## Returns the current state name.
func get_state_name() -> String:
	return get_state().get_state_name() if get_state() != null else ""


## Returns the previous state name.
func get_previous_state_name() -> String:
	return get_previous_state().get_state_name() if get_previous_state() != null else ""


## Clear all states (use with care).
func clear_states() -> void:
	states.clear()
	set_state(NullState)
	set_previous_state(NullState)


func set_callback_target_path(value: NodePath) -> void:
	callback_target_path = value


func get_callback_target_path() -> NodePath:
	return callback_target_path


func set_callback_target(value: Node) -> void:
	callback_target = value


func get_callback_target() -> Node:
	return callback_target


func set_state(value: State) -> void:
	state = value


func get_state() -> State:
	return state


func set_previous_state(value: State) -> void:
	previous_state = value


func get_previous_state() -> State:
	return previous_state


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("StateMachine")
	properties.add_node_path("callback_target_path")
	return properties.get_properties()

## State.gd
## Represents a single state in a finite state machine (FSM).
## Stores optional callbacks for enter, exit, update, and input behaviors.
class State:
	
	const NULL_STATE := ""
	
	var state_name := NULL_STATE setget set_state_name,get_state_name
	
	var _instance : Object setget _set_instance,_get_instance
	var _on_enter := "" setget _set_on_enter,_get_on_enter
	var _on_exit := "" setget _set_on_exit,_get_on_exit
	var _on_update := "" setget _set_on_update,_get_on_update
	var _on_input := "" setget _set_on_input,_get_on_input
	
	
	func _init(instance: Object) -> void:
		_set_instance(instance)
	
	
	func configure(context: Dictionary) -> State:
		with_enter(context.get("enter"))
		with_exit(context.get("exit"))
		with_update(context.get("update"))
		with_input(context.get("input"))
		return self
	
	
	func with_enter(method: String) -> State:
		_on_enter = method
		return self
	
	
	func with_exit(method: String) -> State:
		_on_exit = method
		return self
	
	
	func with_update(method: String) -> State:
		_on_update = method
		return self
	
	
	func with_input(method: String) -> State:
		_on_input = method
		return self
	
	
	func on_enter() -> void:
		if _instance == null:
			return
		if _get_on_enter() != "" and _instance.has_method(_get_on_enter()):
			var instance := funcref(_get_instance(), _get_on_enter())
			instance.call_func()
	
	
	func on_exit() -> void:
		if _instance == null:
			return
		if _get_on_exit() != "" and _instance.has_method(_get_on_exit()):
			var instance := funcref(_get_instance(), _get_on_exit())
			instance.call_func()
	
	
	func on_update(delta: float) -> void:
		if _instance == null:
			return
		if _get_on_update() != "" and _instance.has_method(_get_on_update()):
			var instance := funcref(_get_instance(), _get_on_update())
			instance.call_func(delta)
	
	
	func on_input(event: InputEvent) -> void:
		if _instance == null:
			return
		if _get_on_input() != "" and _instance.has_method(_get_on_input()):
			var instance := funcref(_get_instance(), _get_on_input())
			instance.call_func(event)

	
	func set_state_name(value: String) -> void:
		state_name = value
	
	
	func get_state_name() -> String:
		return state_name


	func _set_instance(value: Object) -> void:
		_instance = value
	
	
	func _get_instance() -> Object:
		return _instance
	
	
	func _set_on_enter(value: String) -> void:
		_on_enter = value
	
	
	func _get_on_enter() -> String:
		return _on_enter
		
		
	func _set_on_exit(value: String) -> void:
		_on_exit = value
	
	
	func _get_on_exit() -> String:
		return _on_exit
			
			
	func _set_on_update(value: String) -> void:
		_on_update = value
	
	
	func _get_on_update() -> String:
		return _on_update
	
	
	func _set_on_input(value: String) -> void:
		_on_input = value
	
	
	func _get_on_input() -> String:
		return _on_input
