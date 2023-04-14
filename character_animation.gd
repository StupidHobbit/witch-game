extends Node

class_name CharacterAnimation

@export var animation_player: AnimationPlayer

enum MovementState {Jumping, Walking, Idle}
enum SpellState {None, Preparing, Prepared}

var movement_state: MovementState = MovementState.Idle
var spell_state: SpellState = SpellState.None
var cast_animation_time: float = 0

func be_idle():
	movement_state = MovementState.Idle

func move():
	movement_state = MovementState.Walking
	
func jump():
	movement_state = MovementState.Jumping

func start_preparing_spell(spell: String):
	spell_state = SpellState.Preparing
	animation_player.play(spell)

func prepare_spell():
	spell_state = SpellState.Prepared
	animation_player.play("prepared")
	
func break_spell():
	spell_state = SpellState.None

func cast():
	spell_state = SpellState.None
	animation_player.play("cast")
	cast_animation_time = animation_player.current_animation_length
	
func _process(delta: float):
	cast_animation_time -= delta
	if spell_state == SpellState.None and cast_animation_time <= 0:
		animation_player.play(MovementStateToAnimation[movement_state])
		return
	
		
const MovementStateToAnimation = {
	MovementState.Walking: "move",
	MovementState.Jumping: "jump",
	MovementState.Idle: "idle",
}
