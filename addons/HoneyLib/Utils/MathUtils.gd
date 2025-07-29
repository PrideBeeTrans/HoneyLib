class_name MathUtils
extends Reference


static func get_random_point_in_circle(
		center: Vector2,
		radius: float,
		margin: float = 0.0,
		exclude_radius: float = 0.0
	) -> Vector2:
	var min_radius := clamp(exclude_radius, 0.0, radius - margin)
	var max_radius := clamp(radius - margin, min_radius, radius)
	
	var angle := randf() * TAU
	var distance := randf_range(min_radius, max_radius)
	var point := center + Vector2(cos(angle), sin(angle)) * distance
	return point


static func get_random_points_in_circle(
		center: Vector2,
		radius: float,
		count: int,
		margin: float = 0.0,
		exclude_radius: float = 0.0
	) -> Array:
	var points := []
	for i in count:
		points.append(get_random_point_in_circle(center, radius, margin, exclude_radius))
	return points


static func randf_range(from: float, to: float) -> float:
	randomize()
	return rand_range(from, to)


static func rand_vector2i(min_vector2: Vector2,max_vector2: Vector2) -> Vector2:
	randomize()
	var x := randi_range(min_vector2.x, max_vector2.x)
	var y := randi_range(min_vector2.y, max_vector2.y)
	return Vector2(x, y)


static func rand_vector2(min_vector2: Vector2,max_vector2: Vector2) -> Vector2:
	randomize()
	var x := randf_range(min_vector2.x, max_vector2.x)
	var y := randf_range(min_vector2.y, max_vector2.y)
	return Vector2(x, y)


static func get_random_direction() -> Vector2:
	return Vector2.ZERO


static func randi_range(from: float, to: float) -> float:
	randomize()
	return rand_range(from, to)


static func lerpi(from: int,to: int,weight: float) -> int:
	randomize()
	return int(lerp(from, to, weight))


static func lerpf(from: float,to: float,weight: float) -> float:
	randomize()
	return float(lerp(from, to, weight))
