extends Control

@onready var spell_panel = $SpellPanel


func set_player_spell_panel_data(spell_panel_data: SpellPanelData):
	  spell_panel.set_player_spell_panel_data(spell_panel_data)
