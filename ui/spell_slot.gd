extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var index_label = $IndexLabel

func set_slot_data(slot_data: SpellSlotData):
	var spell_data = slot_data.spell_data
	texture_rect.texture = spell_data.texture
	tooltip_text = "%s\n%s" % [spell_data.name, spell_data.description]

func set_index(index: int):
	index_label.text = " %d" % index
