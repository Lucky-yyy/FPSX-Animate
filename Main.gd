extends Node2D

var test = [[0,0,0,0],[0,0]]
var animation = false
var animationcount = 0
var animationfps = 0

var fullscreen = false

func _Animation(delta):
	if $ItemList.get_item_count() == 0:
		animation = false
		return
	if animationfps > 0:
		animationfps -= 1 * (delta / 0.016667)
	if animationfps <= 0:
		animationfps = (60 - $SpinBox.value) * 0.1
		animationcount += 1
		if $ItemList.get_item_count() <= animationcount:
			animationcount = 0
		var array = str2var($ItemList.get_item_text(animationcount))
		$Texture.region_rect.position.x = array[0][0]
		$Texture.region_rect.position.y = array[0][1]
		$Texture.region_rect.size.x = array[0][2]
		$Texture.region_rect.size.y = array[0][3]
		$Texture.position.x = array[1][0]
		$Texture.position.y = array[1][1]

func _ready():
	$OffX.value = $Texture.region_rect.position.x
	$OffY.value = $Texture.region_rect.position.y
	$OffWidth.value = $Texture.region_rect.size.x
	$OffHeight.value = $Texture.region_rect.size.y

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		match fullscreen:
			false:
				fullscreen = true
			true:
				fullscreen = false
	OS.window_fullscreen = fullscreen
	var MousePos = Vector2(floor(get_local_mouse_position().x / 2), floor(get_local_mouse_position().y / 2))
	$Label.text = "Mouse: " + "x: " + str(MousePos.x) + " | y: " + str(MousePos.y)
	$Label.text += "   Texture: " + "x: " + str($Texture.position.x / 2) + " | y: " + str($Texture.position.y / 2)
	$Label.text += "   x: " + str($Texture.region_rect.position.x) + " | y: " + str($Texture.region_rect.position.y)
	$Label.text += "   Width: " + str($Texture.region_rect.size.x) + " | Height: " + str($Texture.region_rect.size.y)
	if animation == true:
		_Animation(delta)
		$Texture3.visible = false
	else:
		if itemselected > -1:
			$Texture3.visible = true
		else:
			$Texture3.visible = false
		_Positioning(delta)

func _Positioning(delta):
	var MousePos = Vector2(floor(get_local_mouse_position().x / 2) * 2, floor(get_local_mouse_position().y / 2) * 2)
	if Input.is_action_pressed("MouseLeft") and get_local_mouse_position().x < 640 and get_local_mouse_position().y < 488:
		$Texture.position = MousePos
	MousePos = Vector2(floor(get_local_mouse_position().x), floor(get_local_mouse_position().y))
	$Offsets/Hx.position.x = 0 + $Texture.region_rect.position.x
	$Offsets/Hy.position.y = 0 + $Texture.region_rect.position.y
	$Offsets/Vx.position.x = 0 + $Texture.region_rect.position.x + $Texture.region_rect.size.x
	$Offsets/Vy.position.y = 0 + $Texture.region_rect.position.y + $Texture.region_rect.size.y
	if Input.is_action_pressed("MouseLeft") and get_local_mouse_position().x > $Offsets.position.x and get_local_mouse_position().y > $Offsets.position.y and get_local_mouse_position().x < $Offsets.position.x + 256 and get_local_mouse_position().y < $Offsets.position.y + 256:
		$Texture.region_rect.position.x = MousePos.x - $Offsets.position.x
		$Texture.region_rect.position.y = MousePos.y - $Offsets.position.y
		$OffX.value = $Texture.region_rect.position.x
		$OffY.value = $Texture.region_rect.position.y
		$OffWidth.value = $Texture.region_rect.size.x
		$OffHeight.value = $Texture.region_rect.size.y
	else: if Input.is_action_pressed("MouseRight") and get_local_mouse_position().x > $Offsets.position.x and get_local_mouse_position().y > $Offsets.position.y and get_local_mouse_position().x < $Offsets.position.x + 256 and get_local_mouse_position().y < $Offsets.position.y + 256:
		$Texture.region_rect.size.x = MousePos.x - $Offsets.position.x - $Texture.region_rect.position.x
		$Texture.region_rect.size.y = MousePos.y - $Offsets.position.y - $Texture.region_rect.position.y
		$OffX.value = $Texture.region_rect.position.x
		$OffY.value = $Texture.region_rect.position.y
		$OffWidth.value = $Texture.region_rect.size.x
		$OffHeight.value = $Texture.region_rect.size.y
	else:
		$Texture.region_rect.position.x = $OffX.value
		$Texture.region_rect.position.y = $OffY.value
		$Texture.region_rect.size.x = $OffWidth.value
		$Texture.region_rect.size.y = $OffHeight.value
	if itemselected > -1:
		var array = str2var($ItemList.get_item_text(itemselected))
		$Texture3.region_rect.position.x = array[0][0]
		$Texture3.region_rect.position.y = array[0][1]
		$Texture3.region_rect.size.x = array[0][2]
		$Texture3.region_rect.size.y = array[0][3]
		$Texture3.position.x = array[1][0]
		$Texture3.position.y = array[1][1]

func _on_Load_Texture_pressed():
	$FileDialogPos/LoadTexture.popup()

func _on_LoadTexture_file_selected(path):
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		pass
	$Texture.texture = ImageTexture.new()
	$Texture2.texture = ImageTexture.new()
	$Texture3.texture = ImageTexture.new()
	$Texture.texture.create_from_image(image, 0)
	$Texture2.texture.create_from_image(image, 0)
	$Texture3.texture.create_from_image(image, 0)

func _on_LoadAnimation_file_selected(path):
	var file = File.new()
	file.open(path, File.READ)
	var text = file.get_as_text()
	$ItemList.clear()
	for i in len(text.split("\n", true)):
		var lines = file.get_line()
		$ItemList.add_item(lines)
	file.close()

func _on_Load_Animation_File_pressed():
	$FileDialogPos/LoadAnimation.popup()

func _on_Add_Frame_pressed():
	$ItemList.add_item(str([[$Texture.region_rect.position.x,$Texture.region_rect.position.y,$Texture.region_rect.size.x,$Texture.region_rect.size.y],[$Texture.position.x,$Texture.position.y]]))

func _on_Remove_Frame_pressed():
	if itemselected > -1:
		$ItemList.remove_item(itemselected)
		itemselected = -1

var itemselected = -1
var oitemselected = -1

func _on_ItemList_item_selected(index):
	itemselected = index

func _on_Play_pressed():
	animationcount = 0
	animation = true

func _on_Stop_pressed():
	animation = false

func _on_Load_Frame_pressed():
	if itemselected > -1:
		var array = str2var($ItemList.get_item_text(itemselected))
		$Texture.position.x = array[1][0]
		$Texture.position.y = array[1][1]
		$OffX.value = array[0][0]
		$OffY.value = array[0][1]
		$OffWidth.value = array[0][2]
		$OffHeight.value = array[0][3]

func _on_Add_Offset_pressed():
	$ItemList2.add_item(str([$Texture.region_rect.position.x,$Texture.region_rect.position.y,$Texture.region_rect.size.x,$Texture.region_rect.size.y]))

func _on_Remove_Offset_pressed():
	if oitemselected > -1:
		$ItemList2.remove_item(oitemselected)
		oitemselected = -1

func _on_Load_Offset_pressed():
	if oitemselected > -1:
		var array = str2var($ItemList2.get_item_text(oitemselected))
		$OffX.value = array[0]
		$OffY.value = array[1]
		$OffWidth.value = array[2]
		$OffHeight.value = array[3]

func _on_ItemList2_item_selected(index):
	oitemselected = index

func _on_Save_Animation_pressed():
	$FileDialogPos/SaveAnimation.popup()

func _on_SaveAnimation_file_selected(path):
	var file = File.new()
	var text = ""
	for i in $ItemList.get_item_count():
		text += str($ItemList.get_item_text(i)) + "\n"
	file.open(path, file.WRITE)
	assert(file.is_open())
	file.store_string(text)
	file.close()
