class_name Gamemaster extends Marker3D

@onready var speech_bubble: MeshInstance3D = %SpeechBubble
@onready var label_3d: Label3D = $SpeechBubble/Label3D

func hide_bubble():
	speech_bubble.hide()
	label_3d.hide()
