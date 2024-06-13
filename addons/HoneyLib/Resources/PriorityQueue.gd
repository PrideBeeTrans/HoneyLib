class_name PriorityQueue
extends List


func enqueue(item, priority):
	var index = 0
	for i in range(data.size()):
		if priority < data[i]["priority"]:
			break
		index += 1
	insert(index, {"item": item, "priority": priority})


func dequeue():
	return pop_front()["item"]


func peek():
	return front()["item"]
