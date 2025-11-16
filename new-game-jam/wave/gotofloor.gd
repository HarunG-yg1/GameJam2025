extends Node2D
var is_onfloor := false

var array : Array
var array2 : Array
@onready var wave = $".."
@onready var wave_waveshape =$"../Area2D"
# Called when the node enters the scene tree for the first time.
# 
func _ready() -> void:
	for i in get_children():
		#print("nigger")
		i.connect("collide",_on_ray_cast_2d_collide)
		i.connect("uncollide",_on_ray_cast_2d_uncollide)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_ray_cast_2d_collide(raycast:RayCast2D,new_dir:Vector2,theColided:Node2D):
	if (theColided is TileMapLayer):
		print(new_dir)
		var dir_x : int = wave.lin_veloc.x/abs(wave.lin_veloc.x)
		
		if abs(dir_x) != 1:
			dir_x = 0
		var dir_y : int = wave.lin_veloc.y/abs(wave.lin_veloc.y)
		if abs(dir_y) != 1:
			dir_y= 0
		var adjusted_rotation =  Vector2(abs(new_dir.y)* dir_x , abs(new_dir.x)* dir_y )
		if adjusted_rotation.y ==  0:
			adjusted_rotation.y= (new_dir.x * dir_x)
		if adjusted_rotation.x ==  0:
			adjusted_rotation.x= new_dir.y * dir_y
		if wave.lin_veloc.angle() !=  adjusted_rotation.angle():
			print("lovemiggers")

			wave.lin_veloc =  adjusted_rotation.normalized() * wave.lin_veloc.length() #* dir_x * dir_y 

			if wave.lin_veloc.angle() < deg_to_rad(0) :
				print("lovemiggers1")
				if abs(rad_to_deg(wave.lin_veloc.angle())) > 90:
					wave.rotation = (((wave.lin_veloc.angle())) - deg_to_rad(180) )
					
				else:
					wave.rotation = (-((wave.lin_veloc.angle())) - deg_to_rad(90))
		
			else:
				
				print("lovemiggers2")
				#print(rad_to_deg(wave.lin_veloc.angle()))
				if rad_to_deg(wave.lin_veloc.angle()) > 90:
					wave.rotation = (-((wave.lin_veloc.angle())) + deg_to_rad(90)) 
				else:
					wave.rotation = ((wave.lin_veloc.angle())) 
			# + deg_to_rad(90)
			#wave.no_contact_list[0].hitted = false
			if new_dir.y > 0:
				wave.rotation += deg_to_rad(180)
			
			wave.position += 0.8* Vector2(cos(global_rotation + deg_to_rad(90)),sin(global_rotation + deg_to_rad(90)))
			#wave.linear_velocity *= 1.5
		
			
		is_onfloor = true
		wave.timer = 0.02
		wave.reflect_n_diffract = true
		if raycast not in array:
			array.append(raycast)
		#print('h')
		
	elif (theColided is Wave):
		#print("llaa")
		print(theColided.lin_veloc.normalized())
		print(wave.lin_veloc.normalized())
		if theColided.lin_veloc.normalized() == wave.lin_veloc.normalized()  and wave.spawn:
			wave.spawn = false
			theColided.spawn = false
			var new_wave = wave.original_wave.instantiate().duplicate()
			new_wave.rotation = (wave.lin_veloc).angle()
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
			print(80/(theColided.lin_veloc.length()+wave.lin_veloc.length()))
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
			print(i)
			i.hitted = false
	if raycast not in array2:
		array2.append(raycast)
		#print('g')
	if array.size() <=  array2.size() and is_onfloor:
		is_onfloor = false
		wave.linear_velocity *= 0
		array2.clear()
		array.clear()
