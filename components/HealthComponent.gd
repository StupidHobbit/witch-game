extends Node
class_name HealthComponent

signal took_damage(damage: int)
signal health_depleted()

@export var max_hp: int
var current_hp: int

# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp

func take_damage(damage: int):
	current_hp = clampi(current_hp - damage, 0, max_hp)
	took_damage.emit(damage)
	if current_hp == 0:
		health_depleted.emit()
