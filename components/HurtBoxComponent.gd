extends Area3D


@export var health: HealthComponent

var parent 

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	area_entered.connect(_process_collision)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_collision(o: Node3D):
	if not o is Projectile:
		return
	var projectile_stats: ProjectileData = o.get_stats() 
	health.take_damage(projectile_stats.damage)
