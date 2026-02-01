extends Node

const CLOCK_1 = preload("uid://ehxw6tcev3mo")
const PISTOL = preload("uid://bgsk1pkyonm0j")
const RIFLE = preload("uid://dfrbinifbcbpn")
const CLOWNASAURUS_REX = preload("uid://cdeyutb0acpg1")
const VICTORY_TRUMPET = preload("uid://dvse2yl56vq4g")
const LOSING_HORN_313723 = preload("uid://g25lg80avo5x")

var victory : AudioStreamPlayer
var loss : AudioStreamPlayer

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
		player.volume_linear = sounds[key]
		players[key] = player
	
	victory = AudioStreamPlayer.new()
	add_child(victory)
	victory.volume_linear = 0.2
	
	loss = AudioStreamPlayer.new()
	add_child(loss)
	loss.volume_linear = 0.4
	

func play_music():
	players["music"].stream = CLOWNASAURUS_REX
	players["music"].play()
	
func play_win():
	victory.stream = VICTORY_TRUMPET
	victory.play()
	
func play_loss():
	loss.stream = LOSING_HORN_313723
	loss.play()

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
	
func get_players() -> Array[AudioStreamPlayer]:
	return players.values()
	
