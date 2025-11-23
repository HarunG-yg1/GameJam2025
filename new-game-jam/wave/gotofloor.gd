extends Node2D
var is_onfloor := false
var original_down_rotation : float
var array : Array
var array2 : Array
@onready var wave = $".."
@onready var wave_waveshape =$"../Area2D"
# Called when the node enters the scene tree for the first time.
# 
func _ready() -> void:
	original_down_rotation = wave.rotation + deg_to_rad(90)
	for i in get_children():
		#print("nigger")
		i.connect("collide",_on_ray_cast_2d_collide)
		i.connect("uncollide",_on_ray_cast_2d_uncollide)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_ray_cast_2d_collide(raycast:RayCast2D,new_dir:Vector2,theColided:Node2D):
	if (theColided is TileMapLayer):

	
		wave.rotation = new_dir.angle() + deg_to_rad(90)
		var angle_diff : int = rad_to_deg(wave.rotation - wave.lin_veloc.angle())
		
		
		
		if floor(abs(angle_diff)) != 360 and floor(abs(angle_diff)) != 0 and (ceil(abs(angle_diff))) != 180 and  (ceil(abs(angle_diff))) != 179:
			
			

			
			wave.linear_velocity *= 0
			if abs(angle_diff) < 90:
				wave.lin_veloc =  Vector2(cos(wave.rotation),sin(wave.rotation)).normalized() * wave.lin_veloc.length() #* dir_x * dir_y 
			else:
				wave.lin_veloc =  Vector2(cos(wave.rotation+deg_to_rad(180)),sin(wave.rotation+deg_to_rad(180))).normalized() * wave.lin_veloc.length() #* dir_x * dir_y 
			
			if abs((rad_to_deg(abs(original_down_rotation - (wave.lin_veloc.angle()))))) < 90:
				wave.speed_modifier = 1 + abs((rad_to_deg(abs(original_down_rotation - (wave.lin_veloc.angle())))))/90
				
			else:
				wave.speed_modifier = 1 / (abs((rad_to_deg(abs(original_down_rotation - (wave.lin_veloc.angle())))))/90)
			wave.position += wave.lin_veloc.normalized()*2
			wave_waveshape.get_size()
		
			
		is_onfloor = true
		wave.timer = 0.02
		wave.reflect_n_diffract = true
		if raycast not in array:
			array.append(raycast)
		#print('h')
		
	elif (theColided is Wave):
		#print("llaa")
		#print(theColided.lin_veloc.normalized())
		#print(wave.lin_veloc.normalized())
		if theColided.lin_veloc.normalized() == wave.lin_veloc.normalized()  and wave.spawn:
			wave.spawn = false
			theColided.spawn = false
			var new_wave = wave.original_wave.instantiate().duplicate()
			new_wave.rotation = (wave.rotation)
			new_wave.global_position = theColided.global_position# - wave.lin_veloc.normalized()*16 
			
			new_wave.size = wave.size + theColided.size
			new_wave.lin_veloc = (wave.lin_veloc + theColided.lin_veloc)/2
			theColided.queue_free()
			wave.get_parent().add_child(new_wave)
			wave.queue_free()
		else:
			#print("nigg")
			
			#wave.position += 4*new_dir

			wave.set_collision_layer_value(1,false)
			theColided.set_collision_layer_value(1,false)

			#wave.move =false
			#print(80/(theColided.lin_veloc.length()+wave.lin_veloc.length()))
			await get_tree().create_timer(80/(theColided.lin_veloc.length()+wave.lin_veloc.length())).timeout 
			
			wave.set_collision_layer_value(1,true)
			if "lin_veloc" in theColided:
				theColided.set_collision_layer_value(1,true)
			#wave.move =true
			for i in get_children():
				i.hitted = false
				array2.clear()
				array.clear()
			is_onfloor = true
			
	
	
	
func _on_ray_cast_2d_uncollide(raycast:RayCast2D,new_dir:Vector2):
	for i in get_children():
		if i.is_colliding():
			#print(i)
			i.hitted = false
			
	if raycast not in array2:
		array2.append(raycast)
		#print('g')
	if array.size() <=  array2.size() and is_onfloor:
		is_onfloor = false
		wave.linear_velocity *= 0
		array2.clear()
		array.clear()
