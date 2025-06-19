extends Node
class_name Utils

func find_parent_with_type(node, type):
	var cursor = node
	while cursor.get_parent() != get_node('/root'):
		cursor = cursor.get_parent()
		if is_instance_of(cursor, type):
			return cursor
	return null

func to_unscaled_delta_time(delta_time: float):
	var multiplyer = 1 / Engine.time_scale
	return delta_time * multiplyer
