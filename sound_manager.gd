extends Node

const CLOCK_1 = preload("uid://ehxw6tcev3mo")
const PISTOL = preload("uid://bgsk1pkyonm0j")
const RIFLE = preload("uid://dfrbinifbcbpn")
const ROLL_UP = preload("uid://b2uf2sradq3po")
const CLOWNASAURUS_REX = preload("uid://cdeyutb0acpg1")

var sounds = {
	"clock" : 0.2, 
	"music" : 0.1,
	"pistol" : 0.2,
	"rifle" : 0.2
}
var players : Dictionary[String, AudioStreamPlayer] = {}

func init():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	# Create the pool of AudioStreamPlayer nodes.
	for key in sounds.keys():
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.bus = "master"
		player.volume_linear = sounds[key]
		players[key] = player


func play_music():
	players["music"].stream = CLOWNASAURUS_REX
	players["music"].play()

func play_shot():
	if randi_range(0, 50) == 0:
		players["rifle"].stream = RIFLE
		players["rifle"].play()
	else:
		players["pistol"].stream = PISTOL
		players["pistol"].play()

func play_clock():
	if players["clock"].playing:
		return
	players["clock"].stream = CLOCK_1
	players["clock"].play()
	
func stop() -> void:
	for key in players.keys():
		var tween = get_tree().create_tween()
		tween.tween_property(players[key], "volume_linear", 0, 2)
		tween.play()
		
	pass
	
