extends PanelContainer


const Slot = preload("res://ui/spell_slot.tscn")

@onready var spell_container: HBoxContainer = $MarginContainer/SpellContainer

func set_player_spell_panel_data(spell_panel_data: SpellPanelData):
	populate_spell_container(spell_panel_data.slot_datas)

func populate_spell_container(slot_datas: Array[SpellSlotData]):
	for c in spell_container.get_children():
		c.queue_free()
	
	var index = 1
	for slot_data in slot_datas:
		var slot = Slot.instantiate()
		spell_container.add_child(slot)

		if slot_data != null:
			slot.set_slot_data(slot_data)
		slot.set_index(index)
		index += 1
