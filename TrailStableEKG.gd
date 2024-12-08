extends Node2D
class_name TrailsEKG

@export var width_multiplier : float = 1.0
var queue : Array
var saved_widths : Array
@export var MAX_LENGTH : int
@export var bus_id : int
@export var max_height : int
@export var color : Color
var x_offset : float = 0
var point_every : float = 0.05
var time_since_last_point : float = 0
var y_offset : float = 50
var last_five_frames = {}
const VU_COUNT = 12
const FREQ_MAX = 8000.0
const MIN_DB = 60
var last_sign : bool = false;
var frequenciesLastFrame = {}
var frequenciesThisFrame = {}
var frequencyDiff = 0;
var queueOriginalValues : Array;
var queueRadians : Array;
var queueHowLongLived : Array;
var DEBUG = false;
var rng : RandomNumberGenerator;

var DELTA_MULTIPLIER = 4;
var last_parent : Line2D;
var last_point : Vector2;
enum DIRECTION { INC, DEC, EQU }
var current_width_direction : DIRECTION = DIRECTION.EQU;
var last_width = 2.4;
var points_left_in_direction : int = 4;

var spectrum

func _get_position():
	return get_parent().position

func _mutate_point(child: Node2D):
	var l = child as Line2D;
	if l.get_point_position(0).x < -100:

		for c2 in child.get_children():
			c2.reparent(self)

		child.queue_free()
	else:
		var p1 = l.get_point_position(0)
		p1.x = p1.x - 2
		l.set_point_position(0, p1)
		var p2 = l.get_point_position(1)
		p2.x = p2.x - 2
		l.set_point_position(1, p2)
		for c in child.get_children():
			_mutate_point(c)
		
		
func _mutate_old_points(delta):
	for child in self.get_children():
		_mutate_point(child)
	
	for i in range(1, queue.size()):
		var point = queue[i]
		point.x = point.x - 2
		queueHowLongLived[i] += 1

		queue[i] = point
		
func _compute_new_width(direction : DIRECTION):
	var new_width;
	if direction == DIRECTION.INC:
		new_width = self.last_width + ((self.points_left_in_direction/2) + rng.randf());
	elif direction == DIRECTION.DEC:
		new_width = self.last_width - ((self.points_left_in_direction/2) + rng.randf());
	else:
		new_width = self.last_width	 + (-0.5 + rng.randf());
		
	var max = 10.0
	var min = 2.0;
	if new_width < min:
		new_width = min;
	if new_width > max:
		new_width = max;
	return new_width
	
func new_line(parent_line: Line2D, fromPos: Vector2, toPos: Vector2, radians: float):
	var line = Line2D.new()
	line.begin_cap_mode = 2
	line.end_cap_mode = 2
	line.joint_mode = 2
	var maxThick = 10
	var minThick = 2

	var shouldGetThick : bool = true if toPos.y > (fromPos.y + 10) else false
	if shouldGetThick and parent_line != null and parent_line.width < maxThick:
		line.width = parent_line.width + 1.5
	if parent_line == null:
		line.width = minThick
	if not shouldGetThick:
		line.width = minThick

	line.width *= width_multiplier;
		
	self.last_width = line.width;
			
	line.antialiased = true;
	line.default_color = color;

	if line.width > minThick:
		var fudgeFactor = line.width - minThick
		fromPos.y += fudgeFactor
		toPos.y += fudgeFactor
	var points = [
		fromPos,
		toPos		
	]
	line.points = points
	if parent_line != null:
		add_child(line)
	else:
		add_child(line)
	return line

func _process(delta):
	self._mutate_old_points(delta)

	time_since_last_point += delta
	if time_since_last_point > point_every:
		time_since_last_point = 0
		var pos = _get_position()

		var impulseData = get_parent().get_impulse()
		var impulse = impulseData
		if not impulse:
			impulse = 0
		var speed = 5
		var newRadians = 0
		if queue.size() > 2:
			if DEBUG:
				print('prev radians = ' + str(queueRadians[0]))
				print('prev radians + delta = ' + str(queueRadians[0] + (delta*speed)))
				print('with sin = ' + str(sin(queueRadians[0] + (delta*speed))))
			newRadians = (sin(queueRadians[0] + (delta*speed)))
			if DEBUG:
				print("New Radians = " + str(newRadians))
			pos.y = _get_position().y + (newRadians * impulse)
		else:
			pos.y  = _get_position().y + (sin(0 + (delta*DELTA_MULTIPLIER)) * impulse)
			newRadians = 0
		if DEBUG:
			print("pushing impulse " + str(impulse) + " at y " + str(pos.y))


		var old_point = null;
		if last_parent != null:
			old_point = last_parent.get_point_position(1)
			var nl = new_line(last_parent, old_point, pos, newRadians)
			last_parent = nl;
		elif last_point != Vector2.ZERO:
			var nl = new_line(null, last_point, pos, newRadians)
			last_parent = nl;
		else:
			print('initial point = ' + str(pos))
			last_point = pos
		queueOriginalValues.insert(0, impulse)
		if DEBUG:
			print('pushing arcsin of impulse ' + str(asin(impulse)))
		queue.insert(0, pos)
		queueRadians.insert(0, asin(impulse))
		queueHowLongLived.insert(0, 0)
		if DEBUG:
			print('starting queue')
		for i in range(queue.size()):
			if DEBUG:
				print(queue[i])
				print(queueRadians[i])
		if DEBUG:
			print('ending queue')

	queue_redraw()

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(bus_id, 0)
	rng = RandomNumberGenerator.new()
