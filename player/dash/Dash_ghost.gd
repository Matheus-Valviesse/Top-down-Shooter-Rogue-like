extends Sprite2D

func _ready():
	ghost()
	
func set_props(pos,scale,texture):
	position = pos
	scale = scale

func ghost():
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self,'self_modulate',Color(100,100,100,0),0.45)
	await tween_fade.finished
	queue_free()

