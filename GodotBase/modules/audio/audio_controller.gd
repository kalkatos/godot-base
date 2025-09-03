extends AudioListener2D

@export var music_channel: AudioStreamPlayer2D
@export var sfx_channel_1: AudioStreamPlayer2D
@export var sfx_channel_2: AudioStreamPlayer2D
@export var sfx_channel_3: AudioStreamPlayer2D

var sfx_channels: Array[AudioStreamPlayer2D]
var channel_index: int = 0
var _master_music_volume: float = 1.0
var _master_sfx_volume: float = 1.0
var _has_loaded_volume: bool

var master_music_volume: float:
	get:
		return _master_music_volume
	set (value):
		SignalBus.emit_on_music_volume_set(value)

var master_sfx_volume: float:
	get:
		return _master_sfx_volume
	set (value):
		SignalBus.emit_on_sfx_volume_set(value)


func _ready() -> void:
	var saved_music_volume = Storage.load("master_music_volume", 1.0)
	Debug.logm("Loaded music volume: " + str(saved_music_volume))
	var saved_sfx_volume = Storage.load("master_sfx_volume", 1.0)
	Debug.logm("Loaded sfx volume: " + str(saved_sfx_volume))
	sfx_channels = [
		sfx_channel_1,
		sfx_channel_2,
		sfx_channel_3, ]
	SignalBus._on_music_volume_set.connect(_handle_music_volume_set)
	SignalBus._on_sfx_volume_set.connect(_handle_sfx_volume_set)
	await get_tree().create_timer(0.1).timeout
	master_music_volume = saved_music_volume
	master_sfx_volume = saved_sfx_volume
	_has_loaded_volume = true


func play_sfx (sfx: AudioStream):
	while !_has_loaded_volume:
		await get_tree().process_frame
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
	while not _has_loaded_volume:
		await get_tree().process_frame
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
	_master_music_volume = clamp(value, 0, 1)
	music_channel.volume_linear = _master_music_volume
	Storage.save("master_music_volume", _master_music_volume)


func _handle_sfx_volume_set (value: float):
	_master_sfx_volume = clamp(value, 0, 1)
	for channel in sfx_channels:
		channel.volume_linear = _master_sfx_volume
	Storage.save("master_sfx_volume", _master_sfx_volume)
