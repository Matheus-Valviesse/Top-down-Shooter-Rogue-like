extends  Area2D
class_name Bullet


@onready var time = 0

var damage = 0
var bullet = self
var bullet_speed  

var add_scale = 0

var line
var trail
var set_trail =  true

var velocity = Vector2.RIGHT

func set_time(t):
	time += t
	await get_tree().create_timer(time * 0.6).timeout
	await get_tree().create_timer(time * 0.4).timeout

	queue_free()
	# if set_trail == true :
		# line= preload("res://trail/trail.tscn")
		#trail = line.instantiate()
		#trail.bullet = self
		#get_parent().add_child(trail)
		#trail.width += trail.width * add_scale
		
	
	
	#if trail != null: trail.MAX_LENGTH = 0

	
func _physics_process(delta):
	position +=  velocity * delta
	
func _on_VisibilityNotifier2D_screen_exited():
	if trail != null:
		trail.queue_free()
	queue_free()
	
func cal_chance(val)->bool:
	if val >= randf():
		return true
	else:
		return false
		
func _on_body_entered(body):
	pass
	#if thunder_bolt == true and cal_chance(thunder_bolt_chance) and body.is_in_group('enemy'):
		#var thunder = preload("res://effects/thunder_bolt/thunder_bolt.tscn")
		#var i_thunder = thunder.instantiate()
		#get_parent().add_child(i_thunder)
		#i_thunder.global_position = self.position






