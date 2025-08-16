extends AudioListener2D

@export var music_channel: AudioStreamPlayer2D
@export var sfx_channel_1: AudioStreamPlayer2D
@export var sfx_channel_2: AudioStreamPlayer2D
@export var sfx_channel_3: AudioStreamPlayer2D

var sfx_channels: Array[AudioStreamPlayer2D]
var channel_index := 0
var _master_music_volume: float
var _master_sfx_volume: float

var master_music_volume := 1.0:
	get:
		return _master_music_volume
	set (val):
		_master_music_volume = val
		Storage.save("master_music_volume", val)
		SignalBus.emit_on_music_volume_set(val)

var master_sfx_volume := 1.0:
	get:
		return _master_sfx_volume
	set (val):
		_master_sfx_volume = val
		Storage.save("master_sfx_volume", val)
		SignalBus.emit_on_sfx_volume_set(val)

func _ready() -> void:
	master_music_volume = Storage.load("master_music_volume", 1.0)
	master_sfx_volume = Storage.load("master_sfx_volume", 1.0)
	sfx_channels = [
		sfx_channel_1,
		sfx_channel_2,
		sfx_channel_3
	]
	await get_tree().create_timer(0.1).timeout
	SignalBus.emit_on_music_volume_set(master_music_volume)
	SignalBus._on_music_volume_set.connect(_handle_music_volume_set)
	SignalBus.emit_on_sfx_volume_set(master_sfx_volume)
	SignalBus._on_sfx_volume_set.connect(_handle_sfx_volume_set)

func play_sfx (sfx: AudioStream):
	if is_zero_approx(master_sfx_volume):
		return
	var player = sfx_channels[channel_index]
	channel_index = (channel_index + 1) % sfx_channels.size()
	player.stream = sfx
	player.play(0)

func play_music (music: AudioStream):
	play_music_option(music, false)

func play_music_force (music: AudioStream):
	play_music_option(music, true)

func play_music_option (music: AudioStream, force: bool):
	if is_zero_approx(master_music_volume):
		return
	if music_channel.playing:
		if music_channel.stream == music and !force:
			return
		await create_tween().tween_property(music_channel, "volume_linear", 0, 0.5).finished
		music_channel.stop()
	music_channel.stream = music
	music_channel.play(0)
	if music_channel.volume_linear < master_music_volume:
		create_tween().tween_property(music_channel, "volume_linear", master_music_volume, 0.5)

func stop_music ():
	if music_channel.playing:
		await create_tween().tween_property(music_channel, "volume_linear", 0, 0.5).finished
		music_channel.stop()

func _handle_music_volume_set (value: float):
	master_music_volume = clamp(value, 0, 1)
	Storage.save("master_music_volume", master_music_volume)

func _handle_sfx_volume_set (value: float):
	master_sfx_volume = clamp(value, 0, 1)
	Storage.save("master_sfx_volume", master_sfx_volume)
