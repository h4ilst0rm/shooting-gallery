class_name Gamemaster extends Marker3D

@onready var speech_bubble: MeshInstance3D = %SpeechBubble
@onready var label_3d: Label3D = $SpeechBubble/Label3D

@onready var root: MeshInstance3D = %Root
@onready var eye: MeshInstance3D = %Eye
@onready var laser: MeshInstance3D = %Laser

var eye_original : Vector3
var laser_original : Vector3

func _ready() -> void:
	eye_original = eye.position
	laser_original = laser.position

func get_eye_pos() -> Vector3:
	return root.global_position

func look_to(direction : Vector2) -> void:
	var factor = 0.02
	eye.position = eye_original + Vector3(direction.x * factor, -direction.y * factor, 0)
	laser.position = laser_original + Vector3(direction.x * factor * 2, -direction.y * factor * 2, 0)
	pass
