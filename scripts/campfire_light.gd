extends OmniLight3D

# Set by campfire.gd — no need to touch these in the Inspector directly
var energy_min:    float = 1.2
var energy_max:    float = 2.8
var range_min:     float = 4.0
var range_max:     float = 7.0
var color_cool:    Color = Color(1.0, 0.3, 0.02)
var color_hot:     Color = Color(1.0, 0.85, 0.35)
var flicker_speed: float = 2.4

var _noise := FastNoiseLite.new()
var _time:   float = 0.0

const OFFSET_ENERGY: float = 0.0
const OFFSET_RANGE:  float = 17.3
const OFFSET_COLOR:  float = 41.7


func _ready() -> void:
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.frequency  = 0.8
	_noise.seed       = randi()


func _process(delta: float) -> void:
	_time += delta * flicker_speed

	var t_energy := _time + OFFSET_ENERGY
	var t_range  := _time + OFFSET_RANGE
	var t_color  := _time + OFFSET_COLOR

	var n_energy: float = (_noise.get_noise_1d(t_energy) + 1.0) * 0.5
	var n_range:  float = (_noise.get_noise_1d(t_range)  + 1.0) * 0.5
	var n_color:  float = (_noise.get_noise_1d(t_color)  + 1.0) * 0.5

	light_energy  = lerp(energy_min, energy_max, n_energy)
	omni_range    = lerp(range_min,  range_max,  n_range)
	light_color   = color_cool.lerp(color_hot,   n_color)
