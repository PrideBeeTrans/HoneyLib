tool
class_name InteractionInputArea2D,"res://addons/HoneyLib/Icons/Objects/InteractionInputArea2D.svg"
extends InteractionArea2D

var interaction_input := ""


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if InputMap.has_action(interaction_input):
		return
	if event.is_action_pressed(interaction_input):
		interact(_interactor)


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("InteractionInputArea2D")
	properties.add_string("interaction_input")
	return properties.get_properties()
