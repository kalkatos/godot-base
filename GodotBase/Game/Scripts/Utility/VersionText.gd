extends Label

func _ready ():
    set_text(ProjectSettings.get_setting("application/config/version"))
