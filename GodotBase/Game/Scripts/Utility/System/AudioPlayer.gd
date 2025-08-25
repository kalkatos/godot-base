class_name AudioPlayer
extends Node

@export var audio: AudioStream


func play_global_sfx ():
    AudioController.play_sfx(audio)


func play_global_music (force: bool = false):
    AudioController.play_music_option(audio, force)


func stop_music ():
    AudioController.stop_music()
