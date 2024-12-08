extends Label

func _ready():
	pass 

func _process(delta):
	var impulse = get_parent().get_impulse()
	self.text = "Impulse: " + str(impulse)
