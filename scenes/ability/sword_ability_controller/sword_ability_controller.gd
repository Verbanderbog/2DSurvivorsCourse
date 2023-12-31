extends Node

const MAX_RANGE_SQUARED = pow(150,2)

@export var sword_ability: PackedScene
var damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	enemies = enemies.filter(func (enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < MAX_RANGE_SQUARED
	)
	if enemies.size() == 0:
		return
	enemies.sort_custom(func(a:Node2D, b:Node2D):
		return a.global_position.distance_squared_to(player.global_position) < b.global_position.distance_squared_to(player.global_position)
	)
	var sword_instance = sword_ability.instantiate() as SwordAbility1
	player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
