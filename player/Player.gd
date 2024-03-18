extends CharacterBody2D

@onready var arm = $Arm
@onready var hand = $Arm/Hand

var weapon_index = 0

const weapon_paths = [
	'res://weapons/pistols/pistol_01/pistol_01.tscn',
]

# Lista de armas carregadas
var weapons = []

# Arma atualmente equipada
var equipped_weapon = null
var hide_weapon = null


var atributos_base = {
	"atk_base": 10,
	"speed_base":80,
	"critical_base":0.15,
	"critical_damage_base":0.60
}

var obj = {}

var iventory = []

# Modificadores atuais aplicados
var modificadores = {
	"items": {
		'slot_1':{
			'slot':'capuz',
			'item':{}
		},
		'slot_2':{
			'slot':'torso',
			'item':{}
		},
		'slot_3':{
			'slot':'calça',
			'item':{}
		},
		'slot_4':{
			'slot':'luva',
			'item':{}
		},
		'slot_5':{
			'slot':'bota',
			'item':{}
		},
		'slot_6':{
			'slot':'mascara',
			'item':{}
		},
	}
}


# Carrega as armas disponíveis
func load_weapons():
	weapons.append( preload(weapon_paths[0]))
	var weapon_instance = await weapons[0].instantiate()
	weapon_instance.global_position = self.global_position
	get_parent().add_child(weapon_instance)
	equipped_weapon = weapon_instance
	

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * stat_total('speed')

# Função para selecionar um status com todos os bonus
func stat_total(stat):
	var total = atributos_base[stat+"_base"]
	var total_p = 0
	for modificador in modificadores["items"]:
		if modificadores["items"][modificador]['item'].has('stats'):
			if modificadores["items"][modificador]['item']['stats'].has(stat+'_f'):
				total += modificadores["items"][modificador]['item']["stats"][stat+'_f']
			if modificadores["items"][modificador]['item']['stats'].has(stat+'_p'):
				total_p +=  modificadores["items"][modificador]['item']["stats"][stat+'_p']
	return total + (total * total_p)

# Função para aplicar modificadores
func aplicar_modificador(modificador):
	for s in modificadores['items']:
		if modificadores['items'][s]['slot'] == modificador.slot:
			if modificadores['items'][s]['item'].keys().size() == 0:
				
				modificadores['items'][s]['item'] = modificador
			else:
				iventory.push_back(modificadores['items'][s]['item'])
				modificadores['items'][s]['item'] = modificador

# função para remover@onready var hand = $Arm/Hand

	if equipped_weapon !=  null:
		hide_weapon.global_position = self.global_position
		equipped_weapon.global_position = hand.global_position
		equipped_weapon.look_at(get_global_mouse_position())

func _physics_process(delta):
	# Processa as entradas do jogador e move o personagem
	get_input()
	move_and_slide()
		
	# Mantém o braço sempre apontando para a posição do cursor
	arm.look_at(get_global_mouse_position())
	
	# Se houver uma arma equipada, mantém ela na mão e aponta na direção do cursor
	if equipped_weapon != null:
		print(equipped_weapon)
		if hide_weapon != null: hide_weapon.global_position = self.global_position
		equipped_weapon.global_position = hand.global_position
		equipped_weapon.look_at(get_global_mouse_position())
	else:
		load_weapons()
