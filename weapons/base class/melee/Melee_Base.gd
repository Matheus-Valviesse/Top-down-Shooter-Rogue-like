extends Area2D

class_name MeleeWeapon

var weapon_status = 'idle'

var weapon_damage = 0
var weapon_percent = 0

var weapon_speed = 1


@onready var bullet_amount : float = 1

@onready var animation = $Animation

func weapon_attack(damage, atk_speed,bullet_amount):
	
	if weapon_status == 'idle':
		weapon_status = 'attacking'
		animation.play('atk')
		
		
		
func _on_animation_animation_finished(anim_name):
	
	match  anim_name:
		'atk':
			weapon_status = 'idle'
			animation.play('idle')
