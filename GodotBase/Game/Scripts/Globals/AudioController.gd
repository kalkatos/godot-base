extends AudioListener2D

@export var master_music_volume := 1.0
@export var master_sfx_volume := 1.0
@export var music_channel: AudioStreamPlayer2D
@export var sfx_channel_1: AudioStreamPlayer2D
@export var sfx_channel_2: AudioStreamPlayer2D
@export var sfx_channel_3: AudioStreamPlayer2D

var sfx_channels: Array[AudioStreamPlayer2D]
var channel_index := 0

func _ready() -> void:
	SignalBus._on_music_volume_set.connect(_handle_music_volume_set)
	SignalBus._on_sfx_volume_set.connect(_handle_sfx_volume_set)
	sfx_channels = [
		sfx_channel_1,
		sfx_channel_2,
		sfx_channel_3
	]

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

func _handle_sfx_volume_set (value: float):
	master_sfx_volume = clamp(value, 0, 1)
