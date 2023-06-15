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
class_name CardStackBody

# -1 if selection when stack is empty
signal selected(card_idx:int)
signal drag_started(card_idx:int)
#signal drop()


@export var card_width:float = 60:
	get:
		return card_width
	set(value):
		card_width = value
		dirty = true

@export var card_height:float = 90:
	get:
		return card_height
	set(value):
		card_height = value
		dirty = true

@export var cards:Array[Card]:
	get:
		return cards
	set(value):
		print("setting cards %s: %s" % [name, str(value)])
		cards = value
		dirty = true

@export var card_back:Texture2D:
	get:
		return card_back
	set(value):
		card_back = value
		dirty = true
		
@export var card_offset:Vector2 = Vector2(16, 0):
	get:
		return card_offset
	set(value):
		card_offset = value
		dirty = true

@export var face_up:bool = true:
	get:
		return face_up
	set(value):
		face_up = value
		dirty = true

@export var pickable:bool = true:
	get:
		return pickable
	set(value):
		pickable = value
		dirty = true

var dirty:bool = true
var mouse_down_pos:Vector2
var drag_start_pos:Vector2

enum State { IDLE, READY, DRAGGING }
var state = State.IDLE

func _can_drop(drop_cards:Array[Card])->bool:
	return false

func _drop(drop_stack:CardStackBody):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dirty:
		dirty = false
		
		#print("laying out stack")
		#$EmptyArea.input_pickable = pickable
		
		print("laying out stack %s" % name)
		for child in $cards.get_children():
			child.queue_free()
		
		#$EmptyArea.input_pickable = cards.is_empty()
		#$EmptyArea.visible = cards.is_empty()
		
		var shape:RectangleShape2D = RectangleShape2D.new()
		shape.size = Vector2(card_width, card_height)
		#$EmptyArea/CollisionShape2D.shape = shape
		#$EmptyArea/CollisionShape2D.position = shape.size / 2
		
		
		for c_idx in cards.size():
			var card:Card = cards[c_idx]
			print("place card %s" % card)
			
			if card:
				var card_body:CardBody = preload("res://scene/card_body.tscn").instantiate()
				
				$cards.add_child(card_body)
				card_body.card = card
				card_body.card_width = card_width
				card_body.card_height = card_height
				card_body.card_back = card_back
				card_body.face_up = face_up
				card_body.pickable = pickable
				card_body.name = str(Card.to_string_suit(card.suit)) + "_" + str(Card.to_string_rank(card.rank))
				
				#card_body.get_node("Area2D").process_priority = c_idx
				card_body.get_node("Area2D").z_index = c_idx
				
#				card_body.position = Vector2(card_width, card_height) / 2 + card_offset * c_idx
				card_body.position = card_offset * c_idx
				
				card_body.selected.connect(func(): on_card_selected(c_idx))
				card_body.drag_start.connect(func(): on_card_drag_started(c_idx))
			
			
#func pick_top_card(pos_world:Vector2)->Card:
#	for child in get_children():
#		if child is CardBody:
#			var body:CardBody = child
#			var local_pos:Vector2 = body.global_transform.affine_inverse() * pos_world
#			if local_pos.x >= 0 && 
	

func notify_card_selected(child):
	
	var count:int = 0
	for cur_child in $cards.get_children():
		if cur_child == child:
			selected.emit(count)
			return
		count = count + 1
		
	selected.emit(-1)
		
func notify_card_drag_started(child):
		
	var count:int = 0
	for cur_child in $cards.get_children():
		if cur_child == child:
			#var conns = drag_started.get_connections()
			
			drag_started.emit(count)
			return
		count = count + 1

	selected.emit(-1)


#func notify_dropped():
#
#	drop.emit()
	
func on_card_selected(index:int):
	print("selected %s" % index)
	pass

func on_card_drag_started(index:int):
	print("drag start %s" % index)
	pass

