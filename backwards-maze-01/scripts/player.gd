extends CharacterBody3D
@onready var maze_floor: MeshInstance3D = $"../EnemyNavigationRegion3D/level/Maze_Floor"
var dbugPrints = false
var SPEED = 5.0
var slide_speed = 20.0
var base_spd_flr = 5.0
var base_spd_air = 8.5
var sprint_spd = 9.5
var canOnlyMoveBackwards = true
var canLookVertical = false
@export var isAlive = true
signal playerHasBeenHit

@onready var camera : Camera3D = $Head/Camera3D

#movement 
@export var run_accel : float = 15.0
@export var run_drag : float = 15.0
@export var air_accel : float = 1.0
@export var air_drag : float = 1.0
@export var sld_accel : float = 1.0
@export var sld_drag : float = 1.0
@export var  JUMP_VELOCITY : float = 1.0
@export var  gravity : float = 10.0

# Air Strafing
@export var airStrafeCurve : Curve
const minStrafeAngle : float = 0.0
const maxStrafeAngle : float = 180.0
const airStrafeModifier : float = 1.0
var mouseSensibility = 600

@export var mar_accel_base : float = 4.0
var mario_accel : float
@export var mario_accel_decay : float = 1.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # captures mouse inside the screenspace

func _input(event):
	#Handle escape quit function
	#if event.is_action_pressed("escape"):
		#get_tree().quit()
	
	#mouse aim / camera look at 
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility 
		if canLookVertical:
			camera.rotation.x -= event.relative.y / mouseSensibility
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if dbugPrints:
		print("isAlive",isAlive)
	# Add the gravity.
	if not is_on_floor():
			velocity.y -= gravity * delta
			if Input.is_action_just_released("ui_accept") :
				mario_accel = 0.0 
	if isAlive:
		if Input.is_action_pressed("sprint") && Input.is_action_pressed("ui_up"):
			#turn this into a function
			$Head/Camera3D.fov = lerp($Head/Camera3D.fov,110.0,0.1)
			if is_on_floor():
				SPEED = sprint_spd
		else :
			#turn this into a function
			$Head/Camera3D.fov = lerp($Head/Camera3D.fov,90.5,0.1)
		
		#handle_holding_objects()
		
		
		
		
		if is_on_floor() :
			mario_accel = mar_accel_base
	
# Ha	ndle jumps
		if Input.is_action_just_pressed("ui_accept") :
			pass
			
		if Input.is_action_pressed("ui_accept"):
			if mario_accel > 0.0 : 
				velocity.y = mario_accel
				mario_accel -= mario_accel_decay*delta
	
	
		# Get the input direction and handle the movement/deceleration.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#print("Player's input_dir: ", input_dir)
		
		# If player can't move forward, change any direction keys (wsad, arrows) to moving backkward
		
		if canOnlyMoveBackwards:
			if input_dir.x:
				input_dir.x = 0
				input_dir.y = 1
			
		
			if input_dir.y == -1:
				input_dir.y = 1
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	#what do you want to take precedent, wallrunning or sliding?
	
		normal_run(input_dir,direction,delta)			
		move_and_slide()

	if is_on_floor(): #speed decay to base movement if not sprinting, etc 
		SPEED = move_toward(SPEED, base_spd_flr, 5.0 * delta)
	else :
		pass
		#SPEED = move_toward(SPEED, base_spd_air, 5.0 * delta)

func normal_run(input_dir, direction, delta) -> void : 
	
	var _vec3 : Vector3 = Vector3(direction.x,0.0,direction.z)
	var wish_vel : Vector3 = _vec3 * SPEED
	
	if is_on_floor():
		if input_dir != Vector2.ZERO:
			pass #step timer 
	
		if direction.length() > 0 :
			velocity = lerp(velocity,wish_vel,run_accel*delta)
		else :
			velocity = lerp(velocity,wish_vel,run_drag*delta)

	else:
		var angle_diff : float = rad_to_deg(getHorizontalAngle(velocity, wish_vel))
		var samplePoint := (angle_diff - minStrafeAngle) / maxStrafeAngle
		#velocity += wish_vel.normalized() * delta * airStrafeCurve.sample(samplePoint) * airSpeed
		wish_vel *= 1.0 + (airStrafeCurve.sample(samplePoint) * airStrafeModifier)
		
		if direction.length() > 0 :
			velocity = lerp(velocity,wish_vel,air_accel*delta)
		else :
			velocity = lerp(velocity,wish_vel,air_drag*delta)
			
func getHorizontalAngle(vec1 : Vector3, vec2 : Vector3) -> float:
	vec1.y = 0
	vec2.y = 0
	return abs(vec1.angle_to(vec2))
func isHit():
	if isAlive:
		emit_signal("playerHasBeenHit")
		if dbugPrints:
			print("Player: has been hit")
		dies()
func dies():
	#isAlive = false
	return true
