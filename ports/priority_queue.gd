class_name PriorityQueue
#
# Originally implemented for `Graph` Dijsktra's algorithm in Goost:
# https://github.com/goostengine/goost/blob/9045aaedc/core/types/templates/priority_queue.h
#
#===============================================================================
# Public
#===============================================================================

# Always prefer to initialize the priority queue via constructor,
# as it takes O(n) time in order to build the binary heap this way.
func _init(elements: Array = []):
	initialize(elements)


func initialize(elements: Array = []):
	array.clear()
	if elements.empty():
		return
	array = elements

	var i = array.size() / 2
	while i >= 0:
		sift_down(i)
		i -= 1


func insert(value):
	array.push_back(value)
	var n = array.size() - 1
	bubble_up(n)


func pop():
	var root = array[0]
	array[0] = array[array.size() - 1]
	array.pop_back()
	sift_down(0)
	return root


func empty():
	return array.empty()


func top():
	return array[0] if not array.empty() else null


# Override this for either min or max heap (min by default).
func compare(a, b):
	return a < b

#===============================================================================
# Private
#===============================================================================
var array = []


func parent(i):
	return (i - 1) / 2


func left(i):
	return i * 2 + 1


func right(i):
	return i * 2 + 2


func swap(i, j):
	var tmp = array[i]
	array[i] = array[j]
	array[j] = tmp


func bubble_up(i):
	while i > 0 and compare(array[i], array[parent(i)]):
		swap(i, parent(i))
		i = parent(i)


func sift_down(i):
	while left(i) < array.size():
		var c
		if right(i) > array.size() - 1:
			c = left(i)
		elif compare(array[left(i)], array[right(i)]):
			c = left(i)
		else:
			c = right(i)

		if compare(array[c], array[i]):
			swap(c, i)
		i = c
