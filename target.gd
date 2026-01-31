class_name Target extends Marker3D

@export var animation_player: AnimationPlayer
@export var timer: Timer

enum State { Up, Down }

@export var TargetState : State = State.Up

const GREEN = preload("uid://wfrjmltrypda")
const RED = preload("uid://blfjskh2at737")

@onready var mask: MeshInstance3D = %Mask

var my_mask : Mask = null

signal hit

func _ready() -> void:
	
	hit.connect(toggle_state)
	
	if randf() < 0.5:
		my_mask = GREEN
	else:
		my_mask = RED
	
	var mat := mask.get_active_material(0) as StandardMaterial3D
	mat.albedo_texture = my_mask.sprite
	
	pass

func _process(delta: float) -> void:
	
	pass

func toggle_state() -> void:
	
	if TargetState == State.Up:
		animation_player.play("fall")
		TargetState = State.Down
		timer.start()
	
	pass
	
func get_points() -> int:
	
	return my_mask.points


func _on_timer_timeout() -> void:
	
	animation_player.play("rise")
	TargetState = State.Down
	
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "rise":
		TargetState = State.Up
	
	pass # Replace with function body.
