extends Node2D


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	
func _on_h_slider_value_changed(value: float) -> void:
	$AudioStreamPlayer2D.pitch_scale = value
	pass

func _on_h_slider_2_value_changed(value: float) -> void:
	$AudioStreamPlayer2D2.pitch_scale = value
	pass

func _on_h_slider_3_value_changed(value: float) -> void:
	$AudioStreamPlayer2D3.pitch_scale = value
	pass

func _on_h_slider_4_value_changed(value: float) -> void:
	$AudioStreamPlayer2D4.pitch_scale = value
	pass

func _on_h_slider_5_value_changed(value: float) -> void:
	$AudioStreamPlayer2D5.pitch_scale = value
	pass

func _on_h_slider_6_value_changed(value: float) -> void:
	$AudioStreamPlayer2D6.pitch_scale = value
	pass


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	pass


func _on_button_button_down() -> void:
	if $AudioStreamPlayer2D.playing:
		$Button.text = "Play"
		$AudioStreamPlayer2D.stop()
	else:
		$Button.text = "Stop"
		$AudioStreamPlayer2D.play()
	pass

func _on_button_2_button_down() -> void:
	if $AudioStreamPlayer2D2.playing:
		$Button2.text = "Play"
		$AudioStreamPlayer2D2.stop()
	else:
		$Button2.text = "Stop"
		$AudioStreamPlayer2D2.play()
	pass
	
func _on_button_3_button_down() -> void:
	if $AudioStreamPlayer2D3.playing:
		$Button3.text = "Play"
		$AudioStreamPlayer2D3.stop()
	else:
		$Button3.text = "Stop"
		$AudioStreamPlayer2D3.play()
	pass
	
func _on_button_4_button_down() -> void:
	if $AudioStreamPlayer2D4.playing:
		$Button4.text = "Play"
		$AudioStreamPlayer2D4.stop()
	else:
		$Button4.text = "Stop"
		$AudioStreamPlayer2D4.play()
	pass
	
func _on_button_5_button_down() -> void:
	if $AudioStreamPlayer2D5.playing:
		$Button5.text = "Play"
		$AudioStreamPlayer2D5.stop()
	else:
		$Button5.text = "Stop"
		$AudioStreamPlayer2D5.play()
	pass
	
func _on_button_6_button_down() -> void:
	if $AudioStreamPlayer2D6.playing:
		$Button6.text = "Play"
		$AudioStreamPlayer2D6.stop()
	else:
		$Button6.text = "Stop"
		$AudioStreamPlayer2D6.play()
	pass
