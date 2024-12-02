extends Node2D

var pattern = []
var steps = 16

func _ready() -> void:
	num_samples = get_child_count() - 1
	
	for i in range(steps):
		pattern.push_back(randi_range(0, num_samples -1))
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

var current:int
var num_samples:int

var dir = 1

func _on_timer_timeout() -> void:
	var sn = pattern[current]
	if sn != -1:
		var s = get_child(sn)
		s.play()
		print(current)
	current = current + dir
	if current == steps:
		current = current - 1 
		dir =- dir
	if current == -1:
		current = 0
		dir =- dir
	
