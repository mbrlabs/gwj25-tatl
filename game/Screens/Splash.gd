extends Control

# -------------------------------------------------------------------------------------------------
const ANIM_FADE_IN = "fade_in"
const ANIM_FADE_OUT = "fade_out"

# -------------------------------------------------------------------------------------------------
onready var fade_out_timer: Timer = $FadeOutTimer
onready var launch_timer: Timer = $LaunchTimer
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var wildjam_logo: TextureRect = $WildjamLogo

# -------------------------------------------------------------------------------------------------
func _ready():
	wildjam_logo.modulate.a = 0
	
# -------------------------------------------------------------------------------------------------
func _on_FadeInTimer_timeout():
	anim_player.play(ANIM_FADE_IN)

# -------------------------------------------------------------------------------------------------
func _on_FadeOutTimer_timeout():
	anim_player.play(ANIM_FADE_OUT)

# -------------------------------------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == ANIM_FADE_IN:
		fade_out_timer.start()
	elif anim_name == ANIM_FADE_OUT:
		launch_timer.start()

# -------------------------------------------------------------------------------------------------
func launch_game() -> void:
	get_tree().change_scene("res://Screens/MainMenu.tscn")

# -------------------------------------------------------------------------------------------------
func _on_LaunchTimer_timeout():
	launch_game()
