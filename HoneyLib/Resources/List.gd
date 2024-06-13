class_name List
extends Resource

const EMPTY_INDEX := 0
const START_INDEX := 0
const NEXT_INDEX := 1
const NULL_INDEX := -1

var data := {}


func add(value) -> void:
	var index := size()
	set_item(index, value)


func add_list(list: Array) -> void:
	for index in list.size():
		var value = list[index]
		set_item(index, value)


func set_item(index: int,value) -> void:
	data[index] = value


func get_item(index: int):
	return data.get(index, null)


func get_items() -> Array:
	return data.values()


func pop(index: int):
	var value = get_item(index)
	remove(index)
	return value


func front():
	return get_item(START_INDEX)


func push_back(value) -> void:
	set_item(size(), value)


func push_front(value) -> void:
	for i in range(data.size(), START_INDEX, -NEXT_INDEX):
		data[i] = data[i - NEXT_INDEX]
	data[START_INDEX] = value


func pop_front():
	if data.empty():
		return null
	var value = data[START_INDEX]
	for i in range(NEXT_INDEX, data.size()):
		data[i - NEXT_INDEX] = data[i]
	data.erase(data.size() - NEXT_INDEX)
	return value
	

func pop_back():
	var index := data.size() -NEXT_INDEX
	if index < EMPTY_INDEX:
		return null
	var value = data[index]
	data.erase(index)
	return value


func remove(index: int) -> void:
	data.erase(index)


func remove_all(value) -> void:
	for i in range(size(), NULL_INDEX, NULL_INDEX, NULL_INDEX):
		if data[i] == value:
			data.erase(i)


func size() -> int:
	return data.size()


func resize(new_size: int) -> void:
	if new_size < size():
		for i in range(size() - NEXT_INDEX, new_size - NEXT_INDEX, NULL_INDEX):
			data.erase(i)
	elif new_size > size():
		for i in range(size(), new_size):
			data[i] = null


func is_empty() -> bool:
	return data.empty()


func clear() -> void:
	data.clear()


func index_of(value) -> int:
	for i in range(size()):
		if data[i] == value:
			return i
	return NULL_INDEX


func contains(value) -> bool:
	return index_of(value) != NULL_INDEX
	

func reverse_in_place() -> void:
	var size := size()
	for i in range(size / 2):
		var temp = get_item(i)
		data[i] = data[size -i -NEXT_INDEX]
		data[size -i - NEXT_INDEX] = temp


func reverse() -> Array:
	var reverse_data := data.duplicate()
	var reverse_size := reverse_data.size()
	for i in range(reverse_size / 2):
		var temp = reverse_data[i]
		reverse_data[i] = reverse_data[reverse_size -i -NEXT_INDEX]
		reverse_data[reverse_size -i -NEXT_INDEX] = temp
	return reverse_data.values()


func pick_random():
	randomize()
	if is_empty() == true:
		return null
	var rand_index := rand_range(EMPTY_INDEX, size())
	var value = data[rand_index]
	return value


func pick_random_amount(amount: int) -> Array:
	var results := {}
	for i in range(amount):
		randomize()
		if is_empty() == true:
			break
		var value = pick_random()
		if results.has(value):
			value = pick_random()
		results[i] = value
	return results.values()


func remove_random():
	randomize()
	var rand_index := rand_range(EMPTY_INDEX, size())
	var value_removed = data[rand_index]
	var value = data[rand_index]
	remove(value)
	return value_removed


func remove_random_amount(amount: int) -> Array:
	var results := {}
	for i in range(amount):
		randomize()
		if is_empty() == true:
			break
		var value = pick_random()
		if results.has(value):
			value = pick_random()
		results[i] = value
		remove(i)
	return results.values()


func insert(index: int,value) -> void:
	if index < 0 or index > size():
		return
	for i in range(size()):
		data[i] = data[i - NEXT_INDEX]
	data[index] = value


func count(value) -> int:
	var count_amount := 0
	for item in data.values():
		if item == value:
			count_amount += 1
	return count_amount

func shuffle() -> Array:
	randomize()
	var shuffled_data := data.duplicate()
	var shuffled_size := shuffled_data.size()
	for i in range(shuffled_size - NEXT_INDEX, EMPTY_INDEX, NULL_INDEX):
		var j = randi() % (i + NEXT_INDEX)
		var temp = shuffled_data[i]
		shuffled_data[i] = shuffled_data[j]
		shuffled_data[j] = temp
	return shuffled_data.values()
	
	
func shuffle_in_place() -> void:
	randomize()
	for i in range(size() - NEXT_INDEX, EMPTY_INDEX, NULL_INDEX):
		var j := randi() % (i + NEXT_INDEX)
		var temp = data[i]
		data[i] = data[j]
		data[j] = temp


func foreach(func_ref: FuncRef) -> void:
	for item in data.values():
		func_ref.call_funcv(item)


func slice(start_index: int,end_index: int) -> Array:
	var results := {}
	for i in range(start_index, min(end_index, size())):
		results[i] = data[i]
	return results.values()


func copy() -> Dictionary:
	return data.duplicate()


func unique() -> Array:
	var unique_data := {}
	for value in data.values():
		if unique_data.has(unique_data.size()):
			unique_data[unique_data.size()] = value
	return unique_data.values()


func filter(func_ref: FuncRef) -> Array:
	var filtered_data := []
	for item in data.values():
		if func_ref.call_funcv(item):
			filtered_data.append(item)
	return filtered_data


func any(func_ref: FuncRef) -> bool:
	for item in data.values():
		if func_ref.call_funcv(item):
			return true
	return false


func all(func_ref: FuncRef) -> bool:
	for item in data.values():
		if not func_ref.call_funcv(item):
			return false
	return true


func has(index: int) -> bool:
	return data.has(index)


func has_all(array: Array) -> bool:
	return data.has_all(array)
