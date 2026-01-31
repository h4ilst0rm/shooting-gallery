class_name Start extends Marker3D

@export var animation_player: AnimationPlayer
@export var light: OmniLight3D

enum State { Up, Down }

@export var TargetState : State = State.Up

signal hit

func _ready() -> void:
	
	hit.connect(toggle_state)
	
	pass

func _process(delta: float) -> void:
	
	pass

func toggle_state() -> void:
	
	if TargetState == State.Up:
		animation_player.play("fall")
		light.hide()
	
	pass
