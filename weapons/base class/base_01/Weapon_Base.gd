extends Area2D

class_name Weapon

var weapon_status = 'idle'

@onready var weapon_ammo = 0
@onready var weapon_ammo_bonus = 0
@onready var weapon_max_ammo = 0
@onready var max_ammo = 0
@onready var weapon_current_ammo = 0

var reload_time : float = 1.5
var max_reload_ammo : int = 10
var reloading_ammo : int = 0

@onready var bullet_spawn = $BulletSpawn
@onready var animation = $Animation

var bullet_scene = null

@onready var bullet_amount : float = 1
@onready var bullet_spread  = 30
@onready var bullet_speed : float = 120
@onready var bullet_time : float = 0.8
@onready var bullet_size : float = 1

func _process(delta):
	if weapon_status == 'reloading':
		reload_time -= delta
		if reload_time <= 0:
			weapon_ammo_amount(-reloading_ammo)
			weapon_current_ammo += reloading_ammo
			reloading_ammo = 0
			reload_time = 1.5
			weapon_status = 'idle'

func change_ammo():
	weapon_max_ammo = weapon_ammo + weapon_ammo_bonus
	if weapon_max_ammo <= 0:
		max_ammo = 1
	else:
		max_ammo = weapon_max_ammo
	weapon_current_ammo = max_ammo
	set_ammo()
	
func reload():
	if weapon_status == 'idle' and weapon_current_ammo < max_ammo:
		var ammo_needed = max_ammo - weapon_current_ammo
		reloading_ammo = min(ammo_needed, max_reload_ammo)
		weapon_status = 'reloading'
		animation.play("reload")
		# Você pode adicionar lógica aqui para exibir animação de recarga

func weapon_shoot(damage,size,amount,spread,time,speed):
	
	var start_angle = -(bullet_spread + bullet_spread * spread) * (bullet_amount + amount - 1) / 2
	
	if weapon_current_ammo > 0 and weapon_status == 'idle':
		weapon_status = 'shoot'
		for bullet in range(bullet_amount + amount):
			
			var angle = deg_to_rad(start_angle + bullet * (bullet_spread + bullet_spread * spread))
			var spawned_bullet = bullet_scene.instantiate()
			
			get_parent().add_child(spawned_bullet)
			spawned_bullet.add_scale = size
			spawned_bullet.scale = await Vector2(bullet_size + bullet_size * size, bullet_size + bullet_size * size)
			spawned_bullet.set_time(bullet_time + bullet_time * time)
			spawned_bullet.rotation = global_rotation
			spawned_bullet.position = bullet_spawn.global_position
			spawned_bullet.velocity = Vector2(bullet_speed + (bullet_speed * speed) ,0).rotated(global_rotation + angle / (bullet_amount + amount))
			spawned_bullet.damage = damage
			spawned_bullet.bullet_speed = (bullet_speed + (bullet_speed * speed))
		#animation.play("shoot_1")
		weapon_ammo_amount(1)
		weapon_status = 'idle'
func set_ammo():
	
	if weapon_max_ammo <= 0 :
		max_ammo = 1
	else : 
		max_ammo = weapon_max_ammo
	
func weapon_ammo_amount(ammo):
	if weapon_current_ammo > 0:
		weapon_current_ammo -= ammo
	
func _on_animation_finished(anim_name):
	weapon_status = 'idle'
	
	
