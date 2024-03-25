extends Area2D

class_name Weapon

# Status da arma
var weapon_status = 'idle'

# Munição da arma
@onready var weapon_ammo = 0
@onready var weapon_ammo_bonus = 0
@onready var weapon_max_ammo = 0
@onready var max_ammo = 0
@onready var weapon_current_ammo = 0

# Tempo e quantidade de recarga
var reload_time : float = 1.5
var max_reload_ammo : int = 10
var reloading_ammo : int = 0

# Referência ao spawn da bala
@onready var bullet_spawn = $BulletSpawn

# Animação da arma
@onready var animation = $Animation

# Cena da bala
var bullet_scene = null

# Atributos da bala
@onready var bullet_amount : float = 1
@onready var bullet_spread  = 30
@onready var bullet_speed : float = 120
@onready var bullet_time : float = 0.8
@onready var bullet_size : float = 1

func _process(delta):
	# Verifica se está recarregando
	if weapon_status == 'reloading':
		reload_time -= delta
		if reload_time <= 0:
			weapon_ammo_amount(-reloading_ammo)
			weapon_current_ammo += reloading_ammo
			reloading_ammo = 0
			reload_time = 1.5
			weapon_status = 'idle'

func change_ammo():
	# Calcula a quantidade máxima de munição
	weapon_max_ammo = weapon_ammo + weapon_ammo_bonus
	if weapon_max_ammo <= 0:
		max_ammo = 1
	else:
		max_ammo = weapon_max_ammo
	weapon_current_ammo = max_ammo
	set_ammo()

func reload():
	# Realiza a recarga se estiver no estado 'idle' e houver munição necessária
	if weapon_status == 'idle' and weapon_current_ammo < max_ammo:
		var ammo_needed = max_ammo - weapon_current_ammo
		reloading_ammo = min(ammo_needed, max_reload_ammo)
		weapon_status = 'reloading'
		animation.play("reload")  # Aqui você pode adicionar lógica para exibir animação de recarga

func weapon_shoot(damage, size, amount, spread, time, speed):
	print('scale: ', size)
	var start_angle = -(spread ) * (amount - 1) / 2
	# Dispara a arma se houver munição suficiente e estiver no estado 'idle'
	if weapon_current_ammo > 0 and weapon_status == 'idle':
		weapon_status = 'shoot'
		for bullet in range(amount):
			var angle = deg_to_rad(start_angle + bullet * (bullet_spread ))
			var spawned_bullet = bullet_scene.instantiate()
			get_parent().add_child(spawned_bullet)
			spawned_bullet.add_scale = size
			spawned_bullet.scale = await Vector2(size , size)
			spawned_bullet.set_time(bullet_time )
			spawned_bullet.rotation = global_rotation
			spawned_bullet.position = bullet_spawn.global_position
			spawned_bullet.velocity = Vector2(bullet_speed ,0).rotated(global_rotation + angle /  amount)
			spawned_bullet.damage = damage
			spawned_bullet.bullet_speed = (bullet_speed + (bullet_speed * speed))
		weapon_ammo_amount(1)
		weapon_status = 'idle'

func set_ammo():
	# Define a munição máxima
	if weapon_max_ammo <= 0 :
		max_ammo = 1
	else :
		max_ammo = weapon_max_ammo

func weapon_ammo_amount(ammo):
	# Atualiza a quantidade de munição
	if weapon_current_ammo > 0:
		weapon_current_ammo -= ammo

# Chamada quando a animação da arma termina
func _on_animation_finished(anim_name):
	weapon_status = 'idle'
