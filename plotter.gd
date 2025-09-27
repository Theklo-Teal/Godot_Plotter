extends VBoxContainer
class_name Plotter

signal selected_sample(idx:int) # A sample was clicked and what is its index

@export var editable : bool = true
@export_range(0, 1, 0.01) var sample_clearance : float = 0.8 ## Space around each sample where they shouldn't overlap others.
@export_group("Axles")
@export var Horiz_Title : String
@export var Horiz_Pref : String
@export var Horiz_Suff : String
@export var Verti_Title : String
@export var Verti_Pref : String
@export var Verti_Suff : String

func _ready() -> void:
	%Plot.selected_sample.connect(func(idx):selected_sample.emit(idx))

## Get on-canvas coordinate of a sample coordinate.
func sample_coord(sample:Vector2) -> Vector2:
	sample.x = remap(sample.x, %HZoom.lower, %HZoom.upper, 0, size.x)
	sample.y = remap(sample.y, %VZoom.lower, %VZoom.upper, 0, size.y)
	return sample

## What is the sample coordinate of a spot on the canvas.
func coord_sample(coord:Vector2) -> Vector2:
	coord.x = remap(coord.x, 0, size.x, %HZoom.lower, %HZoom.upper)
	coord.y = remap(coord.y, 0, size.y, %VZoom.lower, %VZoom.upper)
	return coord

## «data» is the coordinates of samples, while «info» defines what to show on tooltip for mouse-over.
func set_plot(data:Array[Vector2], info:Array[Array] = [], id:Array[int] = []):
	%Plot.samples.clear()
	%Plot.tooltip.clear()
	%Plot.samp_id.clear()
	var index := range(data.size())
	index.sort_custom(func(a,b): return data[a].x < data[b].x)
	for i in index:
		%Plot.samples.append(data[i])
		if info.is_empty():
			%Plot.tooltip.append([data[i][0], data[i][1]])
		else:
			%Plot.tooltip.append(info[i])
		if id.is_empty():
			%Plot.samp_id.append(i)
		else:
			%Plot.samp_id.append(id[i])
	_on_fit_zoom_pressed()

func _on_fit_zoom_pressed() -> void:
	var small : float = %Plot.samples[0].y
	var large : float = %Plot.samples[0].y
	for each in %Plot.samples:
		small = min(small, each.y)
		large = max(large, each.y)
	
	var y_span = (large - small)
	## «large» and «small» are inversed and negated to make vertical axis direction from down to up.
	small *= -1
	large *= -1
	
	%VZoom.minim = large - y_span
	%VZoom.maxim = small + y_span
	%VZoom.lower = large - y_span * 0.1
	%VZoom.upper = small + y_span * 0.1
	
	var right = %Plot.samples[-1].x
	var left = %Plot.samples[0].x
	var x_span = right - left
	%Plot.margin = (%Plot.size.x / x_span) * sample_clearance
	
	%HZoom.minim = left - x_span
	%HZoom.maxim = right + x_span
	%HZoom.lower = left - x_span * 0.1
	%HZoom.upper = right + x_span * 0.1
	
	%Plot.queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		var crements = %Plot.margin * 0.01
		match event.button_index:
			MOUSE_BUTTON_WHEEL_LEFT:
				%HZoom.lower += crements
				%HZoom.upper += crements
				%Plot.queue_redraw()
			MOUSE_BUTTON_WHEEL_RIGHT:
				%HZoom.lower -= crements
				%HZoom.upper -= crements
				%Plot.queue_redraw()
			MOUSE_BUTTON_WHEEL_DOWN:
				%VZoom.lower += crements
				%VZoom.upper += crements
				%Plot.queue_redraw()
			MOUSE_BUTTON_WHEEL_UP:
				%VZoom.lower -= crements
				%VZoom.upper -= crements
				%Plot.queue_redraw()
