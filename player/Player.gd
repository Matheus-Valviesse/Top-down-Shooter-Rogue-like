extends CharacterBody2D

# Variáveis para referenciar o braço e a mão do personagem
@onready var arm = $Arm
@onready var hand = $Arm/Hand

# Índice da arma atualmente equipada
var weapon_index = 0

# Caminhos das armas disponíveis
const weapon_paths = [
	'res://weapons/pistols/pistol_01/pistol_01.tscn',
]

# Lista de armas carregadas
var weapons = []

# Arma atualmente equipada e arma escondida (para trocas)
var equipped_weapon = null
var hide_weapon = null

# Variáveis de atributos base
var atributos_base = {
	"atk_base": func(): return 10,
	"speed_base": func(): return 80,
	"critical_base": func(): return 0.15,
	"critical_damage_base": func(): return 0.60,
	"bullet_size_base": func(): return equipped_weapon.bullet_size,
	"bullet_amount_base": func(): return equipped_weapon.bullet_amount,
	"bullet_spread_base": func(): return equipped_weapon.bullet_spread,
	"bullet_time_base": func(): return equipped_weapon.bullet_time,
	"bullet_speed_base": func(): return equipped_weapon.bullet_speed,
}

# Objeto e inventário (ainda não utilizados)
var obj = {}
var inventory = []

# Modificadores atuais aplicados
var modifiers = {
	"items": {
		'slot_1': {
			'slot': 'capuz',
			'item': {
				'name': 'Capuz do caçador de feras',
				'slot': 'capuz',
				'stats': {
					'atk_p': 0.10,
					'bullet_amount_f': 3,
					'bullet_size_p': 0.3,
				}
			}
		},
		'slot_2': {
			'slot': 'torso',
			'item': {}
		},
		'slot_3': {
			'slot': 'calça',
			'item': {}
		},
		'slot_4': {
			'slot': 'luva',
			'item': {}
		},
		'slot_5': {
			'slot': 'bota',
			'item': {}
		},
		'slot_6': {
			'slot': 'mascara',
			'item': {}
		},
	}
}

# Carrega as armas disponíveis
func load_weapons():
	weapons.append(preload(weapon_paths[0]))
	var weapon_instance = await weapons[0].instantiate()
	weapon_instance.global_position = self.global_position
	get_parent().add_child(weapon_instance)
	equipped_weapon = weapon_instance

# Obtém as entradas do jogador
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * stat_total('speed')
	
	# Dispara a arma ao pressionar o botão "shoot"
	if Input.is_action_just_pressed("shoot") and equipped_weapon != null:
		equipped_weapon.weapon_shoot(
			stat_total('atk'),
			stat_total('bullet_size'),
			stat_total('bullet_amount'),
			stat_total('bullet_spread'),
			stat_total('bullet_time'),
			stat_total('bullet_speed'),
		)

# Calcula o total de um atributo levando em conta os modificadores
func stat_total(stat):
	var total = atributos_base[stat+"_base"].call()
	var total_p = 0
	for modifier in modifiers["items"]:
		if modifiers["items"][modifier]['item'].has('stats'):
			if modifiers["items"][modifier]['item']['stats'].has(stat+'_f'):
				total += modifiers["items"][modifier]['item']["stats"][stat+'_f']
			if modifiers["items"][modifier]['item']['stats'].has(stat+'_p'):
				total_p +=  modifiers["items"][modifier]['item']["stats"][stat+'_p']
	return total + (total * total_p)

# Aplica um modificador
func aplicar_modificador(modificador):
	for s in modifiers['items']:
		if modifiers['items'][s]['slot'] == modificador.slot:
			if modifiers['items'][s]['item'].keys().size() == 0:
				modifiers['items'][s]['item'] = modificador
			else:
				inventory.push_back(modifiers['items'][s]['item'])
				modifiers['items'][s]['item'] = modificador

func _physics_process(delta):
	# Processa as entradas do jogador e move o personagem
	get_input()
	move_and_slide()
		
	# Mantém o braço sempre apontando para a posição do cursor
	arm.look_at(get_global_mouse_position())
	
	# Mantém a arma na mão e aponta na direção do cursor se houver uma arma equipada
	if equipped_weapon != null:
		if hide_weapon != null: hide_weapon.global_position = self.global_position
		equipped_weapon.global_position = hand.global_position
		equipped_weapon.look_at(get_global_mouse_position())
	else:
		load_weapons()
