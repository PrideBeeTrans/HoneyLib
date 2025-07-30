tool
class_name InteractionArea2D
extends ComponentArea2D

signal interaction_started(interactor)
signal interaction_ended(interactor)
signal interacted(interactor)

var payload : Resource setget set_payload,get_payload

var _interactor : Node


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	_connect_area()
	_connect_body()
	_connect_input()


func _connect_area() -> void:
	connect("area_entered", self, "_on_interacted_entered")
	connect("area_exited", self, "_on_interacted_exited")


func _connect_body() -> void:
	connect("body_entered", self, "_on_interacted_entered")
	connect("body_exited", self, "_on_interacted_exited")


func _connect_input() -> void:
	connect("input_event", self, "_on_input_event")


func can_interact(interactor: Node) -> bool:
	return is_enabled()


func interact(interactor: Node) -> bool:
	if not can_interact(interactor):
		return false

	var result := execute_payload(interactor)
	emit_signal("interacted", interactor)
	return result


func execute_payload(interactor: Node) -> bool:
	if payload != null and payload.has_method("execute"):
		return payload.execute(self, interactor)
	return true


func _on_interacted_entered(source: Node) -> void:
	if can_interact(source):
		_interactor = source
		emit_signal("interaction_started", source)


func _on_interacted_exited(source: Node) -> void:
	if can_interact(source):
		_interactor = null
		emit_signal("interaction_ended", source)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.


func set_payload(value: Resource) -> void:
	payload = value


func get_payload() -> Resource:
	return payload


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category("InteractionArea2D")
	properties.add_resource("payload", "Resource")
	return properties.get_properties()
