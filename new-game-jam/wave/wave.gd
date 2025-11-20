class_name Wave
extends RigidBody2D
var contact_list : Array
var spawn : = true
var no_contact_list : Array
var original_wave = preload("res://wave/wave.tscn")
var reflect_n_diffract := false
var timer : float
var speed_modifier := 1.0
var floor_time := 0.0
var dir : Vector2 

@export var lin_veloc : Vector2
@export var size : float = 16
@onready var gotofloor = $gotofloor
@onready var collision = $CollisionShape2D
@onready var wave_shape = $Area2D
@onready var raycast = $Raycasts/RayCast2D
@onready var raycast_group = $Raycasts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = 10/lin_veloc.length()
	print()
	$Label.text = name
	collision.shape = collision.shape.duplicate(true)
	collision.shape.size.y = size
	var angle_diff : int = rad_to_deg(rotation - lin_veloc.angle())
	if angle_diff != 0 and angle_diff != 180:
			
			
			if abs(angle_diff) < 90:
				raycast.global_rotation =  rotation + deg_to_rad(-90)
			else:
				raycast.global_rotation =  rotation + deg_to_rad(-90) +deg_to_rad(180)
	#raycast.global_rotation = (lin_veloc.angle()) + deg_to_rad(-90)

	collision.position.y = -collision.shape.size.y/2 +8
	for i in range(0,size,16):
		if i >0:
			var new_raycast = raycast.duplicate()
			raycast_group.add_child(new_raycast)
			new_raycast.order = raycast_group.get_child_count() - 1
			
			new_raycast.position.y -= i
			#print("nigger")
			
	no_contact_list = raycast_group.get_children()
	for i in no_contact_list:
		i.connect("collide",_on_ray_cast_2d_collide)
	
	add_collision_exception_with(%CharacterBody2D)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	


		#print(lin_veloc)
		
	if reflect_n_diffract:
		timer -= delta
		if timer <=0:
			#print(contact_list.size())
			if contact_list.size() > 0:
				size = contact_list.size() * 16 
				collision.shape.size.y = contact_list.size() * 16 
				collision.position.y = -collision.shape.size.y/2 +8
				$Area2D.get_size()
				
			for i in range(no_contact_list.size()):
				if no_contact_list[i] != null:
					if lin_veloc.length()> 0:
						no_contact_list[i].global_rotation = (lin_veloc.angle()) + deg_to_rad(-90)
					if !no_contact_list[i].hitted and no_contact_list[i].spawn and contact_list.size() > 0:
						var new_size = 16.0
						for j in range(i+1,no_contact_list.size()):
							if "hitted" in no_contact_list[j]  and !no_contact_list[j].hitted:
								new_size += 16
								
								no_contact_list[j].spawn = false
								
							else:
								break
						if no_contact_list[i].spawn:
							no_contact_list[i].spawn = false
							var new_wave = original_wave.instantiate().duplicate()
							
							new_wave.global_position =  no_contact_list[i].global_position - lin_veloc.normalized()*16 # - 2.5* Vector2(cos(gotofloor.rotation + deg_to_rad(90)),sin(gotofloor.rotation + deg_to_rad(90))) 
							new_wave.rotation = rotation#(-lin_veloc).angle()
							new_wave.size = new_size
							new_wave.lin_veloc = -lin_veloc
							
							get_parent().add_child(new_wave)
							new_wave.apply_impulse(-lin_veloc)
					if i >= contact_list.size() and contact_list.size() > 0:
						
						no_contact_list[i].queue_free()
						no_contact_list[i] = null
			
			no_contact_list = raycast_group.get_children()
			contact_list.clear()
			for i in no_contact_list:
				i.hitted = false
				i.spawn = true
			reflect_n_diffract = false
			timer = 10/lin_veloc.length()
	

func _physics_process(delta: float) -> void:
	if get_colliding_bodies().size() > 0 and raycast.get_collider() is TileMapLayer:
		global_position += (raycast.get_collision_point()-global_position).normalized() * 8
	if get_colliding_bodies().size() > 0 and gotofloor.is_onfloor and contact_list.size() == 0 :
		
			
		#print(get_colliding_bodies())
		global_position +=   Vector2(cos(gotofloor.global_rotation + deg_to_rad(90)),sin(gotofloor.global_rotation + deg_to_rad(90)))
		#gotofloor.is_onfloor = true
		
	if !gotofloor.is_onfloor:
		
		#collision.disabled = false
		#floor_time = 0
		#print(name + str(gotofloor.is_onfloor))

		if linear_velocity.length() < 600:
			
			apply_impulse(-150*Vector2(cos(gotofloor.global_rotation + deg_to_rad(90)),sin(gotofloor.global_rotation + deg_to_rad(90))))
		#constant_force=(4000* Vector2(cos(gotofloor.rotation + deg_to_rad(90)),sin(gotofloor.rotation + deg_to_rad(90))))

			
	else:
		
		floor_time += delta
		if linear_velocity.length() < (lin_veloc.length() * speed_modifier):

			apply_impulse(lin_veloc * speed_modifier)
			#print(lin_veloc * speed_modifier)
		#linear_velocity = lin_veloc

	#else:
		#



	


func _on_ray_cast_2d_collide(the_raycast:RayCast2D,new_dir:Vector2,theColided:Node2D) -> void:
	
	if (theColided is TileMapLayer) and gotofloor.is_onfloor:
		
		#print(the_raycast.order)
		
		lin_veloc = new_dir*lin_veloc.length()
		var angle_diff : int = rad_to_deg(rotation - lin_veloc.angle())
		if angle_diff != 0 and  angle_diff != 180:
			if abs(angle_diff) < 90:
				lin_veloc =  Vector2(cos(rotation),sin(rotation)).normalized() * lin_veloc.length()
				
			else:
				lin_veloc =  Vector2(cos(rotation+deg_to_rad(180)),sin(rotation+deg_to_rad(180))).normalized() * lin_veloc.length() #* dir_x * dir_y 
		contact_list.append(the_raycast)
		reflect_n_diffract = true

	elif (theColided is Wave):

		if theColided.lin_veloc.angle() == lin_veloc.angle() and spawn:
			spawn = false
			theColided.spawn = false
			var new_wave = original_wave.instantiate().duplicate()
			new_wave.rotation = rotation
			new_wave.global_position =  theColided.global_position 
			
			new_wave.size = size + theColided.size
			new_wave.lin_veloc = (lin_veloc + theColided.lin_veloc)/2
			
			theColided.queue_free()
			get_parent().add_child(new_wave)
			new_wave.apply_impulse(lin_veloc)
			queue_free()
		else:
	
			#print("nigger")
			set_collision_mask_value(1,false)
			set_collision_layer_value(1,false)
			if theColided.size < size:
				theColided.lin_veloc += lin_veloc/5
				#if theColided.lin_veloc.length() < lin_veloc.length()/2 and theColided.lin_veloc.normalized() != lin_veloc.normalized():
				#	theColided.lin_veloc = -new_dir*lin_veloc.length()/2
			#print(40/(theColided.lin_veloc.length()+lin_veloc.length()))
			
			await get_tree().create_timer(70/(theColided.lin_veloc.length()+lin_veloc.length())).timeout 
			
			for i in no_contact_list :
				#print("migga hitam")

				if "hitted" in i and !get_collision_layer_value(1):
					i.hitted = false
			set_collision_layer_value(1,true)
			set_collision_mask_value(1,true)
			contact_list.clear()
			

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#queue_free()
	pass # Replace with function body.


	
	
