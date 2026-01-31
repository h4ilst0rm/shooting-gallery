extends Node3D

@onready var crosshair: Sprite2D = %Crosshair
@onready var point_label: Label = %Points
@onready var camera_3d: Camera3D = $Camera3D

const TARGET = preload("uid://c6tt5ahixx0yr")
@onready var targets: Node = %Targets

var points : int = 0

func _ready() -> void:
	
	for entry in targets.get_children():
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
		if "collider" in raycast_result:
			points += 1
			var target = raycast_result["collider"].get_parent().get_parent().get_parent() as Target
			if target:
				target.hit.emit()
		pass
	
	pass
