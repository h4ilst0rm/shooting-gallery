extends Node3D

@onready var crosshair: Sprite2D = %Crosshair
@onready var point_label: Label = %Points
@onready var camera_3d: Camera3D = $Camera3D

const TARGET = preload("uid://c6tt5ahixx0yr")
@onready var targets: Node = %Targets
@onready var path_follow: PathFollow3D = %PathFollow
@onready var spotlights: Node = %Spotlights

const CLOWNASAURUS_REX = preload("uid://cdeyutb0acpg1")
const PISTOL = preload("uid://bgsk1pkyonm0j")
const RIFLE = preload("uid://dfrbinifbcbpn")
const CLOCK_1 = preload("uid://ehxw6tcev3mo")

var running : bool = false
var points : int = 0
var time : int = 3 * 60

func _ready() -> void:
	
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
		
		SoundManager.play(RIFLE)
		
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
				SoundManager.play(CLOWNASAURUS_REX)
				running = true
				for entry in spotlights.get_children():
					entry.show()
		pass
		
	if running:
		for entry in targets.get_children()[0].get_children():
			(entry as PathFollow3D).progress_ratio += 0.1 * delta
			
		for entry in targets.get_children()[1].get_children():
			(entry as PathFollow3D).progress_ratio += -0.2 * delta
	
	
	
	pass
	


func _on_timer_timeout() -> void:
	SoundManager.play(CLOCK_1)
	pass # Replace with function body.
