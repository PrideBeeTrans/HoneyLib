tool
class_name HitFlash2D
extends Component2D

const CATEGORY_NAME := "HitFlash2D"
const PROPERTY_FLASH_COLOR := "flash_color"
const PROPERTY_FLASH_DURATION := "flash_duration"

const SHADER_PARAM_FLASH_INTENSITY := "shader_param/flash_intensity"
const SHADER_PARAM_FLASH_COLOR := "shader_param/flash_color"

const FLASH_INTENSITY_START := 0.0
const FLASH_INTENSITY_PEAK := 1.0


var flash_color := Color.white setget set_flash_color,get_flash_color
var flash_duration := 0.1 setget set_flash_duration,get_flash_duration

onready var health_stats := get_component(NodeRegistry.HEALTH_STATS) as HealthStats setget set_health_stats,get_health_stats

var flash_tween : SceneTreeTween setget set_flash_tween,get_flash_tween


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	_connect_health_stats()


func _connect_health_stats() -> void:
	if get_health_stats() != null:
		get_health_stats().connect("damage_taken", self, "_on_HealthStats_damage_taken")


func _on_HealthStats_damage_taken(amount: int, source: Node, reason: String) -> void:
	trigger_flash()


func trigger_flash() -> void:
	var mat := get_flash_material()
	if mat == null:
		return
	if get_flash_tween() != null:
		get_flash_tween().kill()
	mat.set_shader_param(SHADER_PARAM_FLASH_COLOR, get_flash_color())
	set_flash_tween(create_tween())
	get_flash_tween().tween_property(mat, SHADER_PARAM_FLASH_INTENSITY, FLASH_INTENSITY_START, get_flash_duration()).from(FLASH_INTENSITY_PEAK)


func get_flash_material() -> Material:
	var mat := get_material()
	if mat != null and mat is ShaderMaterial and mat.shader.has_param(SHADER_PARAM_FLASH_INTENSITY):
		return mat
	return null


func set_health_stats(value: HealthStats) -> void:
	health_stats = value


func get_health_stats() -> HealthStats:
	return health_stats


func set_flash_tween(value: SceneTreeTween) -> void:
	flash_tween = value


func get_flash_tween() -> SceneTreeTween:
	return flash_tween


func set_flash_color(value: Color) -> void:
	flash_color = value


func get_flash_color() -> Color:
	return flash_color


func set_flash_duration(value: float) -> void:
	flash_duration = value


func get_flash_duration() -> float:
	return flash_duration


func _get_property_list() -> Array:
	var properties := PropertiesList.create_property_list()
	properties.add_category(CATEGORY_NAME)
	properties.add_color(PROPERTY_FLASH_COLOR)
	properties.add_float(PROPERTY_FLASH_DURATION)
	return properties.get_properties()
