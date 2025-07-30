tool
class_name StartingStats
extends Resource

var max_health := 1 setget set_max_health,get_max_health


func set_max_health(value: int) -> void:
	max_health = value


func get_max_health() -> int:
	return max_health
