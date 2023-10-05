@tool
extends Node3D


@export var text: String
@onready var area = $area
@onready var hint_label = $HintLabel


func _ready():
	hint_label.text = text
	if not Engine.is_editor_hint():
		hint_label.hide()
		area.body_entered.connect(on_enter)
		area.body_exited.connect(on_exit)

func _process(delta):
	if Engine.is_editor_hint():
		hint_label.text = text

func on_enter(body):
	if body is Character:
		hint_label.show()
	
func on_exit(body):
	if body is Character:
		hint_label.hide()
