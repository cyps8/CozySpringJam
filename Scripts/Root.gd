extends Node

var pause: bool = false

var pauseMenu: CanvasLayer

func _ready():
    pauseMenu = $Pause
    pauseMenu.visible = true
    remove_child(pauseMenu)

func TogglePause():
    pause = !pause
    get_tree().paused = pause
    if pause:
        add_child(pauseMenu)
    else:
        remove_child(pauseMenu)

func _process(_delta):
    if Input.is_action_just_pressed("Pause"):
        TogglePause()