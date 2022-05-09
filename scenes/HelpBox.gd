extends Area2D


var is_in_area = false

onready var body = get_parent().get_node("player/CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_area_entered")
	connect("body_exited", self, "_area_exited")

func _process(delta):
	if is_in_area == true:
		$CanvasLayer/HelpBoxText.show()
		$CanvasLayer/HelpBoxText.percent_visible += 0.01
	else:
		if $CanvasLayer/HelpBoxText.percent_visible <= 0.01:
			$CanvasLayer/HelpBoxText.hide()
			$CanvasLayer/HelpBoxText.percent_visible = 0
		elif $CanvasLayer/HelpBoxText.percent_visible > 0.01:
			$CanvasLayer/HelpBoxText.percent_visible -= 0.01

func _area_entered(object):
	if object.name == "player":
		is_in_area = true
		

func _area_exited(object):
	if object.name == "player":
		is_in_area = false
