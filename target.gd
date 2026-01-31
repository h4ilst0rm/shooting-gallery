class_name Target extends Marker3D

@export var animation_player: AnimationPlayer
@export var area3d: Area3D
@export var timer: Timer

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
		TargetState = State.Down
		area3d.monitorable = false
		timer.start()
	
	pass


func _on_timer_timeout() -> void:
	
	animation_player.play("rise")
	TargetState = State.Down
	
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "rise":
		TargetState = State.Up
		area3d.monitorable = true
	
	pass # Replace with function body.
