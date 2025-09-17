class_name ParticleEmitter3D
extends Node3D

signal finished

@export var particles: CPUParticles3D

var is_playing: bool


func _ready () -> void:
	is_playing = false
	particles.finished.connect(_handle_particles_finished)


func play (pos: Vector3) -> void:
	if is_playing:
		var other = Pooler.get_new(self) as ParticleEmitter3D
		var my_parent = get_parent()
		if other.get_parent() != my_parent:
			my_parent.add_child(other)
			other.owner = my_parent
		other.play(pos)
		return
	visible = true
	is_playing = true
	global_position = pos
	particles.restart()


func _handle_particles_finished ():
	particles.emitting = false
	is_playing = false
	finished.emit()
	visible = false
