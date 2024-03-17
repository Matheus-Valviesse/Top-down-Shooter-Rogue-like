extends Node2D

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

# função para remover
func remove_modifier(type,name):
	var target
	for data in range(modificadores[type].size()):
		if modificadores[type][data].name == name:
			target = data
		
	if target != null:
		modificadores[type].remove_at(target)

	
