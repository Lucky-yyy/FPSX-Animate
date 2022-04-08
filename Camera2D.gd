extends Camera2D

var camerapos = [640,360,1,1]

func _process(delta):
	if Input.is_action_just_pressed("Zoom1"):
		camerapos = [400,300,1,1]
	if Input.is_action_just_pressed("Zoom2"):
		camerapos = [160,122,0.4,0.4]
	var scrollspeed = 0.1
	position += Vector2(
		(camerapos[0] - position.x) * scrollspeed,
		(camerapos[1] - position.y) * scrollspeed)
	zoom += Vector2(
		(camerapos[2] - zoom.x) * scrollspeed,
		(camerapos[3] - zoom.y) * scrollspeed)
