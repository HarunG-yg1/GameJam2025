extends Area2D
var hittedArray : Array
@onready var wave = $".."
@onready var raycast = $RayCast2D
@onready var gotofloor = $"../gotofloor"
var added_size :float
var opposite_inteference_time : float
var decrement_added_size : float
var new_polygon
var new_collision 
var half_width

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast.add_exception(wave)
	raycast.add_exception(%CharacterBody2D/CollisionShape2D)
	new_polygon =$Polygon2D.duplicate()
	new_collision = $CollisionPolygon2D.duplicate() #= .BUILD_SEGMENTS.duplicate(true)
	$".".add_child(new_polygon) 
	$".".add_child(new_collision) 
	$Polygon2D.queue_free()
	$CollisionPolygon2D.queue_free()
	get_size()
	pass # Replace with function body.

func get_size():
	new_polygon.polygon[0] = wave.size * Vector2(cos(gotofloor.rotation + deg_to_rad(-90)),sin(gotofloor.rotation + deg_to_rad(-90))) 
	new_polygon.polygon[1] = -(wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
	new_polygon.polygon[2] = (wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
	new_collision.polygon[0] = wave.size * Vector2(cos(gotofloor.rotation + deg_to_rad(-90)),sin(gotofloor.rotation + deg_to_rad(-90))) 
	new_collision.polygon[1] = -(wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
	new_collision.polygon[2] = (wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
	half_width = (wave.lin_veloc * wave.speed_modifier).length()/4
	raycast.global_rotation = (wave.lin_veloc.angle()) - deg_to_rad(90)
	
	raycast.target_position.y = (wave.lin_veloc * wave.speed_modifier).length()/4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if wave.floor_time > 0.15:
		monitoring = true
	for i in hittedArray:
		#print(hittedArray)
		#print("half_width")
		#print(abs(wave.global_position - i).x)
		#print(half_width)
		if abs(wave.global_position - i).length() <= half_width:
			new_collision.polygon[0] = 2*wave.size * (half_width/(half_width + abs(wave.global_position - i).x)) * Vector2(cos(gotofloor.rotation + deg_to_rad(-90)),sin(gotofloor.rotation + deg_to_rad(-90))) 
			new_polygon.polygon[0] = 2*wave.size * (half_width/(half_width + abs(wave.global_position - i).x)) * Vector2(cos(gotofloor.rotation + deg_to_rad(-90)),sin(gotofloor.rotation + deg_to_rad(-90))) 
		#	if wave.global_position.length()< i.length():
			new_polygon.polygon[2] = ((wave.global_position - i ).length() + 8 ) * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
			new_collision.polygon[2] = ((wave.global_position - i ).length() + 8) * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
			#elif wave.global_position.length() > i.length():
			new_polygon.polygon[1] = -((wave.global_position - i).length() + 8) * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
			new_collision.polygon[1] = -((wave.global_position - i).length() + 8 )* Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 

				
		else:
			new_collision.polygon[0] = wave.size  * Vector2(cos(gotofloor.rotation + deg_to_rad(-90)),sin(gotofloor.rotation + deg_to_rad(-90))) 
			new_polygon.polygon[0] = wave.size  * Vector2(cos(gotofloor.rotation + deg_to_rad(-90)),sin(gotofloor.rotation + deg_to_rad(-90))) 
			#if wave.global_position.length()< i.length():
			new_polygon.polygon[2] = (wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
			new_collision.polygon[2] = (wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
			#elif wave.global_position.length() > i.length():
			new_polygon.polygon[1] = -(wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 
			new_collision.polygon[1] =  -(wave.lin_veloc * wave.speed_modifier).length()/4 * Vector2(cos(gotofloor.rotation),sin(gotofloor.rotation)) 

			hittedArray.erase(i)
			
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player and wave.gotofloor.is_onfloor and body.statemachine.state is not harpooning:
		
		body.on_wave = wave
		if (body.velocity.normalized()- wave.linear_velocity.normalized()).length() < 1.414 and (body.velocity + wave.linear_velocity * 0.8).length() > body.MAX_SPEED * 0.8:
			body.velocity = wave.linear_velocity * 0.8 + (wave.size)/2 * (-body.grav_dir)
		elif (wave.linear_velocity * 0.8).length() > body.MAX_SPEED * 0.8:
			
			body.velocity += wave.linear_velocity * 0.8 + (wave.size)/2 * (-body.grav_dir)
	if body is fish and wave.gotofloor.is_onfloor and body.weight_priority <= wave.size and !body.sleep_queue:
		if wave.origin_summon != "fish":
			body.wave = wave 
		else:
			body.statemachine.state_enterer(falling_enemy)
			body.velocity *= 0
			body.velocity += (wave.size*16/(body.weight_priority)) * 2 * (-body.grav_dir)
		if (body.velocity.normalized()+ wave.linear_velocity.normalized()).length() > 0.8:
			body.velocity += wave.linear_velocity * 0.8
		else:
			body.velocity = wave.linear_velocity * 0.8
	if body is TileMapLayer || (body is Wave and body.lin_veloc.angle() != wave.lin_veloc.angle()):
		hittedArray.append(raycast.get_collision_point())




func _on_body_exited(body: Node2D) -> void:
	if body is Player:

		body.on_wave = null
	if body is fish:
		body.wave = null
	pass # Replace with function body.
