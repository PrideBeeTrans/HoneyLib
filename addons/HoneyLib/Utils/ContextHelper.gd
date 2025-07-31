class_name ContextHelper
extends Object


static func create_context() -> ContextData:
	var context := ContextData.new()
	return context


class ContextData:
	
	var data := {}
		

	func set_data(key: String,value) -> ContextData:
		data[key] = value
		return self


	func get_data(key: String,default_value = null):
		return data[key] if has_data(key) else default_value


	func get_all_data() -> Dictionary:
		return data


	func has_data(key: String) -> bool:
		return data.has(key)
