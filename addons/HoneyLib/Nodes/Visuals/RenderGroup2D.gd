tool
class_name RenderGroup2D
extends Component2D

const CATEGORY_NAME := "RenderGroup2D"
const PROPERTY_VIEWPORT_SIZE := "viewport_size"

const RENDER_VIEWPORT_SCENE := preload("res://addons/HoneyLib/Resources/Visuals/ViewportScene.tscn")


var viewport_size := Vector2(256,256) setget set_viewport_size,get_viewport_size

var render_viewport : Viewport setget set_render_viewport,get_render_viewport
var sprite : Sprite setget set_sprite,get_sprite


func _enter_tree() -> void:
	_check_dependencies()


func _check_dependencies() -> void:
	if get_node_or_null("ViewportScene") == null:
		var new_viewport := RENDER_VIEWPORT_SCENE.instance() as Viewport
		new_viewport.set_size(get_viewport_size())
		add_child(new_viewport)
		render_viewport = new_viewport
		render_viewport.owner = get_tree().get_edited_scene_root()
	
	if get_node_or_null("Sprite") == null:
		var new_sprite := Sprite.new()
		add_child(new_sprite)
		sprite = new_sprite
		sprite.owner = get_tree().get_edited_scene_root()
		sprite.texture = render_viewport.get_texture() if render_viewport != null else null


func set_viewport_size(value: Vector2) -> void:
	viewport_size = value
	if render_viewport != null:
		render_viewport.set_size(get_viewport_size())
	property_list_changed_notify()


func get_viewport_size() -> Vector2:
	return viewport_size


func set_render_viewport(value: Viewport) -> void:
	render_viewport = value


func get_render_viewport() -> Viewport:
	return render_viewport


func set_sprite(value: Sprite) -> void:
	sprite = value


func get_sprite() -> Sprite:
	return sprite



func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category(CATEGORY_NAME)
	properties.add_vector2(PROPERTY_VIEWPORT_SIZE)
	return properties.get_properties()
