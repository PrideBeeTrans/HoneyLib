tool
class_name TraitSystem
extends Component

var traits := {}


func _ready() -> void:
	_handle_callback("initialize", {"actor": actor,"trait_system": self})


func _physics_process(delta: float) -> void:
	_handle_callback("process_trait", {"actor": actor,"trait_system": self,"delta": delta})


func add_trait(trait: Resource,can_clone: bool = true) -> Resource:
	if trait in traits:
		return trait
	
	var instance : Resource = trait.clone() if can_clone == true else trait
	traits[instance.get_trait_name()] = instance
	if instance.has_method("on_added"):
		instance.on_added({"actor": actor,"trait_system": self})
	return instance


func remove_trait(trait_name: String) -> void:
	var trait_remove : Resource = traits[trait_name]
	if trait_remove.has_method("on_removed"):
		trait_remove.on_removed({"actor": actor,"trait_system": self})
	traits.erase(trait_remove)


func has_trait_by_id(trait_id: String) -> bool:
	return traits.has(trait_id)


func clear_traits() -> void:
	for trait in traits:
		trait.on_removed(self)
	traits.clear()


func _handle_callback(func_name: String,payload: Dictionary = {}) -> void:
	if Engine.is_editor_hint() == true:
		return
	if payload.empty() != true:
		for trait in traits:
			if trait.has_method(func_name):
				trait.call(func_name, payload)
	else:
		for trait in traits:
			if trait.has_method(func_name):
				trait.call(func_name, payload)
