tool
class_name Component,"res://addons/HoneyLib/Icons/Component.svg"
extends Node

signal enabled_changed(new_value)
signal component_registered(component_name)
signal component_unregistered(component_name)

enum RegistryType{NAME, CLASS}

const META_KEY := "Components"

var actor_path := NodePath("..") setget set_actor_path,get_actor_path
var component_name := "" setget set_component_name,get_component_name
var enabled := true setget set_enabled,is_enabled
var tags := [] setget set_tags,get_tags
var registry_type : int = RegistryType.CLASS setget set_registry_type,get_registry_type
var resource_map : Resource = null setget set_resource_map,get_resource_map

onready var actor := get_node_or_null(actor_path) as Node setget set_actor


func _ready() -> void:
	if Engine.is_editor_hint() or is_enabled() == false:
		return
	_register_component()


func _enter_tree() -> void:
	resolve_name()
	if Engine.is_editor_hint() or is_enabled() == false:
		return
	_register_component()
	

func _exit_tree() -> void:
	if Engine.is_editor_hint() or is_enabled() == false:
		return
	_unregister_component()


func _register_component() -> void:
	if get_owner() == null or component_name == "":
		return

	if not get_owner().has_meta(META_KEY):
		get_owner().set_meta(META_KEY, {})

	var components_dict := get_owner().get_meta(META_KEY) as Dictionary
	components_dict[component_name] = self
	get_owner().set_meta(META_KEY, components_dict)


func _unregister_component() -> void:
	if get_owner() == null or not get_owner().has_meta(META_KEY):
		return
	var components_dict := get_owner().get_meta(META_KEY) as Dictionary
	components_dict.erase(component_name)
	get_owner().set_meta(META_KEY, components_dict)


func resolve_name() -> void:
	if get_component_name() != null:
		set_component_name(get_name())


func get_component_or_null(c_name: String) -> Node:
	var components_list := get_all_components()
	return components_list.get(c_name, null)


func get_component(c_name: String) -> Node:
	var components_list := get_all_components()
	var component := components_list.get(c_name, null) as Node
	if component == null:
		return null
	return component


func get_all_components() -> Dictionary:
	if get_owner() != null and get_owner().has_meta(META_KEY):
		var components_list := get_owner().get_meta(META_KEY) as Dictionary
		return components_list
	return {}


##Setters and Getters
func set_actor_path(value: NodePath) -> void:
	actor_path = value


func get_actor_path() -> NodePath:
	return actor_path


func set_component_name(value: String) -> void:
	component_name = value


func get_component_name() -> String:
	return component_name


func set_actor(value: Node) -> void:
	actor = value


func get_actor() -> Node:
	return actor


func set_enabled(value: bool) -> void:
	enabled = value


func is_enabled() -> bool:
	return enabled


func set_tags(value: Array) -> void:
	tags = value


func get_tags() -> Array:
	return tags


func set_resource_map(value: Resource) -> void:
	resource_map = value


func get_resource_map() -> Resource:
	return resource_map


func set_registry_type(value: int) -> void:
	registry_type = value
	property_list_changed_notify()


func get_registry_type() -> int:
	return registry_type


func get_registry_choose() -> String:
	if is_registry_by_name() == true:
		return get_component_name()
	else:
		return get_class()


func is_registry_by_name() -> bool:
	return get_registry_type() == RegistryType.NAME


func is_registry_by_class_name() -> bool:
	return get_registry_type() == RegistryType.CLASS


func get_class() -> String:
	return "Component"


func _include_resource_map() -> bool:
	return true


## Utilitys Interns
func _resolve_name() -> void:
	if get_component_name() != null:
		set_component_name(get_name())


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.create_component_base("Component", _include_resource_map(), is_registry_by_name())
	return properties.get_properties()
