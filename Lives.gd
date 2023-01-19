extends Control

#This script alloctes a length to the Hearts node so that it displays exactly 3 hearts. (MI)
# REF: https://www.youtube.com/watch?v=Mo9ZbHyl9TY (MI)

var heart_size: int = 125 

func on_player_life_changed(player_hearts: float) -> void:
	$Hearts.rect_size.x = player_hearts * heart_size # this reduces the objects length, so hearts on display decrease. (MI)
