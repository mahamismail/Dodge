extends Area2D

signal hit
signal life_changed(player_hearts)

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# TASK: Added 3 lives for the player (MI)
# REF: https://www.youtube.com/watch?v=Mo9ZbHyl9TY (MI)
# REF: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html (MI)

var lives = MainVariables.lives # Called these vars from Main.gd using Singleton pattern. (MI)
var hearts = MainVariables.hearts 

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	connect("life_changed", get_parent().get_node("HUD/Lives"), "on_player_life_changed")
	emit_signal("life_changed", lives)

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hearts -= 1 # decrease a life everytime the player collides with a Creep (MI)
	print(hearts) # show lives left in console (MI)
	
	emit_signal("life_changed", hearts) # Emit a signal to indicate the life has decreased (MI)
	emit_signal("hit")
	
	# BUG: lives = 0 is satisfied acc to console but unsure why it won't work. (MI)
	if hearts == 0: #disable collision only when life is decreased to 0 (MI)
		$CollisionShape2D.set_deferred("disabled", true) # Must be deferred as we can't change physics properties on a physics callback.
