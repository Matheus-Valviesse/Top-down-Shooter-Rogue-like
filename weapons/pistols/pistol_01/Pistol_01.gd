extends Weapon

func _ready():
	reloading_ammo = 10
	bullet_size =1
	weapon_ammo = 10
	bullet_amount = 1
	bullet_spread = 80
	bullet_speed = 90
	bullet_time = 0.8
	bullet_scene = await preload("res://weapons/bullets/bullet_pistol_01/bullet_pistol_01.tscn")
	await change_ammo()
