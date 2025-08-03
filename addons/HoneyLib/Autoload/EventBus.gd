extends Node

var listeners := {}


func add_listener(event_name: String,func_ref: FuncRef,priority: int = 0,once: bool = false) -> void:
	if not listeners.has(event_name):
		listeners[event_name] = []
	listeners[event_name].append({
		"func_ref": func_ref,
		"priority": priority,
		"once": once
	})


func remove_listener(event_name: String,func_ref: FuncRef) -> void:
	if not listeners.has(event_name):
		return
	
	var filtered := []
	for entry in listeners[event_name]:
		if entry.func_ref != func_ref:
			filtered.append(entry)
	
	listeners[event_name] = filtered


func emit(event_name: String,payload: Dictionary = {}) -> void:
	if not listeners.has(event_name):
		return
	
	var to_remove := []
	for i in listeners[event_name].size():
		var entry := listeners[event_name][i] as Dictionary
		var func_ref := entry.func_ref as FuncRef
		var once := entry.once as bool
		func_ref.call_func()
		if once == true:
			to_remove.append(i)


func _sort_priority_desc(a: Dictionary,b: Dictionary) -> Dictionary:
	return a.priority > b.priority
