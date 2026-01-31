extends Node3D

@onready var crosshair: Sprite2D = %Crosshair
@onready var point_label: Label = %Points
@onready var camera_3d: Camera3D = $Camera3D
@onready var time_label: Label = %Time

const TARGET = preload("uid://c6tt5ahixx0yr")
@onready var targets: Node = %Targets
@onready var path_follow: PathFollow3D = %PathFollow
@onready var spotlights: Node = %Spotlights

@onready var game_timer: Timer = %GameTimer
@onready var shot_timer: Timer = %ShotTimer

var running : bool = false
var points : int = 0
const points_needed : int = 30
var time : int = 30
var can_shoot = true
var loss = false
@onready var game_over: TextureRect = %GameOver
@onready var retry: Button = %Retry

func _ready() -> void:
	
	SoundManager.init()
	
	for path in targets.get_children():
		for i in range(0, 5):
			var new_follow = path_follow.duplicate()
			path.add_child(new_follow)
			new_follow.progress_ratio = 0.2 * i
	
	for path in targets.get_children():
		for entry in path.get_children():
			var new_target = TARGET.instantiate()
			entry.add_child(new_target)
	
	pass


func _process(delta: float) -> void:
	
	var mouse_pos = get_viewport().get_mouse_position()
		
	crosshair.position = mouse_pos
	
	point_label.text = "points: " + str(points)
	time_label.text = "time: " + str(time)
	
	if loss:
		gameover()
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	if running:
		for entry in targets.get_children()[0].get_children():
			(entry as PathFollow3D).progress_ratio += 0.1 * delta
			
		for entry in targets.get_children()[1].get_children():
			(entry as PathFollow3D).progress_ratio += -0.2 * delta
	
	if not can_shoot:
		return
	
	if Input.is_action_just_pressed("shoot"):
		print("shot " + str(mouse_pos))
		var ray_length = 100
		var from = camera_3d.project_ray_origin(mouse_pos)
		var to = from + camera_3d.project_ray_normal(mouse_pos) * ray_length
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas = true
		var raycast_result := space.intersect_ray(ray_query)
		
		SoundManager.play_shot()
		can_shoot = false
		shot_timer.start()
		
		if "collider" in raycast_result:
			print("hit")
			var target = raycast_result["collider"].get_parent().get_parent().get_parent() as Target
			if running and target:
				print("hit2")
				if target.TargetState == Target.State.Up:
					target.hit.emit()
					points += target.get_points()
				
			target = raycast_result["collider"].get_parent().get_parent().get_parent() as Start
			if not running and target:
				target.hit.emit()
				SoundManager.play_music()
				game_timer.start()
				running = true
				for entry in spotlights.get_children():
					entry.show()
			
			target = raycast_result["collider"].get_parent().get_parent() as Gamemaster
			if target:
				loss = true


func gameover() -> void:
	SoundManager.stop()
	var tween = get_tree().create_tween()
	tween.tween_property(game_over, "modulate:a", 1, 2)
	tween.play()
	await tween.finished
	tween.kill()
	retry.show()
	pass

func _on_retry_pressed() -> void:
	print("press")
	get_tree().change_scene_to_file("res://game.tscn")
	pass # Replace with function body.

func _on_game_timer_timeout() -> void:
	SoundManager.play_clock()
	time -= 1
	
	if time == 0:
		loss = true
	
	pass # Replace with function body.


func _on_shot_timer_timeout() -> void:
	print("shot timeout")
	can_shoot = true
	pass # Replace with function body.
