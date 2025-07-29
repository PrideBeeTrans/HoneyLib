tool
class_name ModifiableResource
extends Resource

signal modifier_added(modifier)
signal modifier_removed(modifier)
signal modifier_clear()

var modifiers := [] setget set_modifiers,get_modifiers


func add_modifier(modifier: Resource) -> void:
	var scene_tree := Engine.get_main_loop() as SceneTree
	modifiers.append(modifier)
	emit_signal("modifier_added", modifier)
	if modifier.has_duration() == true:
		yield(scene_tree.create_timer(modifier.get_duration()), "timeout")
		remove_modifier(modifier)


func remove_modifier(modifier: Resource) -> void:
	if modifier.has(modifier):
		modifiers.erase(modifier)
		emit_signal("modifier_removed", modifier)


func remove_modifiers_by_source(source: String) -> void:
	var copy_modifiers := modifiers.duplicate()
	for modifier in copy_modifiers:
		if modifier.get_source() == source:
			remove_modifier(modifier)


func clear_modifiers() -> void:
	modifiers.clear()
	emit_signal("modifier_clear")


func set_modifiers(value: Array) -> void:
	modifiers = value


func get_modifiers() -> Array:
	return modifiers


func get_final_stat(stat_name: String,base_value: float) -> float:
	var add := 0.0
	var mult := 1.0
	var override_value = null
	
	for modifier in modifiers:
		if modifier.get_stat_name() != stat_name:
			continue
		if modifier == ModifierData.ModifierType.ADD:
			add += modifier.get_value()
		elif modifier ==  ModifierData.ModifierType.MULTIPLY:
			mult *= modifier.get_value()
		elif modifier ==  ModifierData.ModifierType.OVERRIDE:
			override_value = modifier.get_value()
	
	var result := (base_value + add) * mult
	return override_value if override_value != null else result
