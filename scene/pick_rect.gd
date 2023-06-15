# MIT License
#
# Copyright (c) 2023 Mark McKay
# https://github.com/blackears/godotSolitaire
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


@tool
extends Node2D
class_name PickRect

@export var width:float = 60:
	get:
		return width
	set(value):
		width = value
		dirty = true

@export var height:float = 90:
	get:
		return height
	set(value):
		height = value
		dirty = true

@export var color:Color = Color.WHITE:
	get:
		return color
	set(value):
		color = value
		dirty = true

@export var filled:bool = true:
	get:
		return filled
	set(value):
		filled = value
		dirty = true

@export var pickable:bool = true

var dirty:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_pick(pos_local:Vector2)->bool:
	return pickable && Rect2(0, 0, width, height).has_point(pos_local)

func _draw():
	draw_rect(Rect2(0, 0, width, height), color, filled)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dirty:
		queue_redraw()
		
		dirty = false
	pass
