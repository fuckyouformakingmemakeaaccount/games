extends CharacterBody3D
var SPEED = 4
var JUMP = 10
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP
		
	
	var input_dir := Input.get_vector("Left","Right","Up","Down")
	print("dir: ", input_dir)
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		print("direction: ", direction)
		rotation_degrees.y += direction.x * SPEED 
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, .1)
		velocity.z = move_toward(velocity.z, 0, .1)
		
	move_and_slide()
