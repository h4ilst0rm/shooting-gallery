extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("move_animation")

func _process(delta: float) -> void:
	
	pass
