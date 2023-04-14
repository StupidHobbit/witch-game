extends Node

class_name SpellcraftComponent

@export var statuses_component: StatusesComponent
@export var particles: GPUParticles3D
@export var animation_component: CharacterAnimation
@export var light: Light3D
@export var spell_panel_data: SpellPanelData

@onready var spell_panel = $SpellPanelInterface/SpellPanel

var chosen_spell: SpellData
var is_preparing: bool = false
var prepared: bool = false
var current_preparation_time: float 
var material: ShaderMaterial

func _ready():
	spell_panel.set_player_spell_panel_data(spell_panel_data)
	material = particles.draw_pass_1.surface_get_material(0)
	if not material is ShaderMaterial:
		push_error("Material for Wand's particles is supposed to be a shader")
	choose_spell(spell_panel_data.slot_datas[0].spell_data)
	set_particles_power(0)

func _process(delta: float):
	check_spell_choice()
	if Input.is_action_just_pressed("cast"):
		start_preparation()
	if Input.is_action_just_released("cast"):
		stop_preparation()
	update_spell(delta)
	
		
func check_spell_choice():
	var index = 1
	for spell_slot_data in spell_panel_data.slot_datas:
		if spell_slot_data == null:
			continue
		if Input.is_action_just_pressed("hotbar%d" % index):
			choose_spell(spell_slot_data.spell_data)
		index += 1
		
func choose_spell(spell_data: SpellData):
	chosen_spell = spell_data
	set_particles_color(chosen_spell.color)
	set_light_intensity(chosen_spell.light_intensity)
	
func update_spell(delta: float):
	if is_preparing and not prepared:
		update_preparation(delta)
	if not is_preparing and prepared:
		cast()
	return

func update_preparation(delta: float):
	current_preparation_time += delta
	var preparation_percent = clampf(current_preparation_time / chosen_spell.prepare_time, 0, 1)
	set_particles_power(preparation_percent)
	if preparation_percent == 1 and prepared == false:
		prepared = true
		animation_component.prepare_spell()

func cast():
	stop_preparation()
	prepared = false
	animation_component.cast()
	
func start_preparation():
	current_preparation_time = 0
	set_particles_power(0)
	is_preparing = true
	animation_component.start_preparing_spell(chosen_spell.slug)

func stop_preparation():
	set_particles_power(0)
	animation_component.break_spell()	
	is_preparing = false
	
func set_particles_power(power: float):
	if light != null:
		light.light_energy = power * chosen_spell.light_intensity
	material.set_shader_parameter("power", power)

func set_light_intensity(intensity: float):
	material.set_shader_parameter("light_intensity", intensity)

func set_particles_color(color: Color):
	if light != null:
		light.light_color = color
	material.set_shader_parameter("light_color", Vector3(color.r, color.g, color.b))
