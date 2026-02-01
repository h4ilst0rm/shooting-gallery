class_name Target extends Marker3D

@export var animation_player: AnimationPlayer
@export var timer: Timer

enum State { Up, Down }

@export var TargetState : State = State.Up

const BLUE = preload("uid://bn57os6kngow1")
const GREEN = preload("uid://wfrjmltrypda")
const PURPLE = preload("uid://da45gjopu63yo")
const RED = preload("uid://blfjskh2at737")
const YELLOW = preload("uid://xymiwppsvpy7")

var masks = [BLUE, GREEN, PURPLE, RED]

@onready var mask: MeshInstance3D = %Mask

var my_mask : Mask = null

signal hit

func _ready() -> void:
	
	hit.connect(toggle_state)
	random_mask()
	
	pass

func _process(delta: float) -> void:
	
	pass

func random_mask() -> void:
	my_mask = masks.pick_random()
	
	if randf() < 0.1:
		my_mask = YELLOW
	
	var mat := mask.get_active_material(0) as StandardMaterial3D
	mat.albedo_texture = my_mask.sprite
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
