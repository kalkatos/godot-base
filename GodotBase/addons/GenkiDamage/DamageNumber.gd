extends Node2D

class_name DamageNumber

signal finished

@export var text: Label
@export var particles: CPUParticles2D

var is_playing: bool

func _ready() -> void:
	is_playing = false
	particles.emitting = false
	var subviewport = $SubViewport
	particles.texture = subviewport.get_texture()
	particles.finished.connect(_handle_particles_finished)

func play (value: String, position: Vector2):
	if is_playing:
		Debug.logm("Getting one from pool.")
		var other = Pooler.get_new(self) as DamageNumber
		var my_parent = get_parent()
		if other.get_parent() != my_parent:
			my_parent.add_child(other)
			other.owner = my_parent
		other.play(value, position)
		return
	visible = true
	is_playing = true
	text.text = value
	set_position(position)
	particles.restart()

func _handle_particles_finished ():
	Debug.logm("Finished playing: " + str(self))
	particles.emitting = false
	is_playing = false
	finished.emit()
	visible = false
