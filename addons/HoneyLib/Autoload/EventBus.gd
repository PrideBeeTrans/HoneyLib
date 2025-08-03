extends Node

const ONE_SHOOT_LISTENER := true
const DEFAULT_LISTENER := false
const DEFAULT_PRIORITY := 0

const LISTENER_KEY_FUNC_REF := "func_ref"
const LISTENER_KEY_ONCE := "once"
const LISTENER_KEY_PRIORITY := "priority"

var events := {}


func add_event(event_name: String,func_ref: FuncRef,priority: int = DEFAULT_PRIORITY,once: bool = DEFAULT_LISTENER) -> void:
	_ensure_event(event_name)
	_add_listener(event_name, func_ref, priority, once)


func remove_event(event_name: String,func_ref: FuncRef) -> void:
	if not events.has(event_name):
		return
	
	var filtered := []
	for entry in events[event_name]:
		if entry.func_ref != func_ref:
			filtered.append(entry)
	
	events[event_name] = filtered


func emit(event_name: String,payload: Dictionary = {}) -> void:
	if not events.has(event_name):
		return
	
	var to_remove := []
	for i in get_event_total_listeners(event_name):
		var entry := get_event_listeners(event_name, i) as Dictionary
		var func_ref := entry.get(LISTENER_KEY_FUNC_REF) as FuncRef
		var once := entry.get(LISTENER_KEY_ONCE) as bool
		
		if payload.empty() == true:
			func_ref.call_func()
		else:
			func_ref.call_func(payload)
		
		if once == true:
			to_remove.append(i)


func has_event(event_name: String) -> bool:
	return events.has(event_name)


func get_event(event_name: String) -> Array:
	return events.get(event_name)


func get_event_total_listeners(event_name: String) -> int:
	return get_event(event_name).size()


func get_event_listeners(event_name: String,index: int) -> Dictionary:
	return get_event(event_name)[index]


func _ensure_event(event_name: String) -> void:
	if not has_event(event_name):
		events[event_name] = []


func _add_listener(event_name: String,func_ref: FuncRef,priority: int,once: bool) -> void:
	events[event_name].append({
		LISTENER_KEY_FUNC_REF: func_ref,
		LISTENER_KEY_PRIORITY: priority,
		LISTENER_KEY_ONCE: once
	})


func _sort_priority_desc(a: Dictionary,b: Dictionary) -> Dictionary:
	return a.priority > b.priority
