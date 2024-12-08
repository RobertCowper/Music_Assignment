extends Node
@export var bus_id : int
@export var max_impulse : int
var spectrum
var DEBUG : bool = true

var frequenciesLastFrame = {}
var frequenciesThisFrame = {}

const FREQUENCY_RANGES = [
	[0, 100],
	[100, 250],
	[250, 500],
	[500, 1000],
	[1000, 2000],
	[2000, 3000],
	[3000, 5000],
	[5000, 7500],
	[7500, 10000]
]

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(bus_id, 0)

func get_impulse():
	var data = []
	var total_magnitude = 0
	var prev_hz = 0
	var highest_magnitude = 0
	var highest_hz = 0
	var pstr = ''
	for band in FREQUENCY_RANGES:
		var lo = band[0]
		var hi = band[1]
		var MIN_DB = 60
		var HEIGHT = 20
		var HEIGHT_SCALE = 16
		var magnitude = spectrum.get_magnitude_for_frequency_range(lo, hi).length()
		var energy = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		total_magnitude += energy * HEIGHT * HEIGHT_SCALE
	var impulse = remap(total_magnitude, 0, 1000, 0, max_impulse)	
	if impulse < 0:
		impulse = 0

	return impulse
