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


extends Node2D
class_name CardTable

enum State { IDLE, READY, DRAGGING }
var state = State.IDLE

var mouse_down_pos:Vector2
var chosen_card:CardBody
var chosen_card_stack:CardStackBody

# Called when the node enters the scene tree for the first time.
func _ready():
	#$draw_pile.selected.connect()
	
	#print("rank: %s" % rank)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pick_card_or_pile(pos_world:Vector2)->Node:
	var picked_obj:PickRect = GeneralUtil.node_depth_search_first(self, func(node:Node):
			if node is PickRect:
				var pr:PickRect = node
				var pos_local:Vector2 = pr.global_transform.affine_inverse() * pos_world
				return pr.can_pick(pos_local)
			return false,
		func (node:Node) :
			if !node.visible:
				return false
			if node == $drag_column:
				return false
			return true,
		true)
		
	return picked_obj.get_parent() if picked_obj else null
	

func intersect(pos:Vector2):
	#$Area2D/CollisionShape2D.get_poly
	
	var space_rid:RID = get_world_2d().space
	var space_state:PhysicsDirectSpaceState2D = PhysicsServer2D.space_get_direct_state(space_rid)
	
	var query:PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.position = pos
	#query.collision_mask = 0x02
	var results:Array[Dictionary] = space_state.intersect_point(query)
	
	var best_collider = null
	var best_z:int = -1
	for r in results:
		var collider = r["collider"]
		if !collider.input_pickable:
			continue
			
		if collider.z_index >= best_z:
			best_z = collider.z_index
			best_collider = collider
		#print("z index %s" % collider.z_index)
		#return collider.get_parent()
	
	return best_collider.get_parent() if best_collider else null


#var chosen_stack:CardStackBody

func _unhandled_input(event):
	
	if event is InputEventMouseButton:
		var e:InputEventMouseButton = event

		if e.is_pressed():
			#if state == State.IDLE:
			var chosen_obj = pick_card_or_pile(e.position)
			if chosen_obj:
				print("picked mask %s " % chosen_obj.get_path())
			
#			var chosen_obj = picked_mask.get_parent()
			#var chosen_obj = intersect(e.position)
			if chosen_obj is CardStackBody:
				chosen_card_stack = chosen_obj
				chosen_card = null
				state = State.READY
				mouse_down_pos = e.position
				
			elif chosen_obj is CardBody:
				chosen_card = chosen_obj
				chosen_card_stack = chosen_card.get_parent_stack()
				state = State.READY
				mouse_down_pos = e.position
					
		else:
			if state == State.READY:
				state = State.IDLE
				if chosen_card_stack:
					#var chosen_stack:CardStackBody = chosen_card.get_parent_stack()
					chosen_card_stack.notify_card_selected(chosen_card)
#					print("hit: %s" % collider.get_path())
#					if chosen_card:
#						print("hit: %s" % str(chosen_card.card))
#					else:
#						print("hit: %s" % str(chosen_card_stack.name))

			elif state == State.DRAGGING:
				var drop_obj = pick_card_or_pile(e.position)
				#var drop_obj = picked_mask.get_parent()
				
#				var drop_obj = intersect(e.position)
				var stack:CardStackBody
				
				if drop_obj is CardStackBody:
					stack = drop_obj
					#drop_obj.notify_dropped()
					#print("dropping on %s" % drop_obj.name)
				elif drop_obj is CardBody:
					var drop_card:CardBody = drop_obj
					stack = drop_card.get_parent_stack()

				if stack:
					var drag_cards:Array[Card] = $drag_column.cards
					if stack._can_drop(drag_cards):
						stack._drop($drag_column)
						#stack.notify_dropped()
					
						print("dropping on %s" % stack.name)
					else:
						cancel_drop()
				else:
					cancel_drop()
				
				state = State.IDLE
#				if chosen_card_stack:
#					#var chosen_stack:CardStackBody = chosen_card.get_parent_stack()
#					chosen_card_stack.notify_dropped()
#				
		get_viewport().set_input_as_handled()


	elif event is InputEventMouseMotion:
		var e:InputEventMouseMotion = event
		
		if state == State.READY:
			if e.position.distance_to(mouse_down_pos) > 6:
				state = State.DRAGGING
#				state = State.IDLE
				if chosen_card_stack:
					#var chosen_stack:CardStackBody = chosen_card.get_parent_stack()
					chosen_card_stack.notify_card_drag_started(chosen_card)
					$drag_column.position = e.position

#					if chosen_card:
#						print("drag: %s" % str(chosen_card.card))
#					else:
#						print("drag: %s" % str(chosen_card_stack.name))
		elif state == State.DRAGGING:
			$drag_column.position = e.position
			
		get_viewport().set_input_as_handled()


func cancel_drop():
	var col_cards:Array[Card] = $drag_column.cards
	
	if !col_cards.is_empty():
		
		var source_cards:Array[Card] = chosen_card_stack.cards
		source_cards.append_array(col_cards)
		chosen_card_stack.cards = source_cards
		
		col_cards.clear()
		$drag_column.cards = col_cards
		

func _on_draw_pile_selected(card_idx):
	var draw_cards:Array[Card] = $draw_pile.cards
	if draw_cards.is_empty():

		var draw_new:Array[Card] = $discard_pile.cards.duplicate()
		draw_new.append_array($hand.cards)
		$draw_pile.cards = draw_new
		
		var e0:Array[Card] = []
		$hand.cards = e0
		var e1:Array[Card] = []
		$discard_pile.cards = e1
	
	else:
		#print("discard %s" % str($discard_pile.cards))
		var new_discard:Array[Card] = $discard_pile.cards.duplicate()
		new_discard.append_array($hand.cards)
		$discard_pile.cards = new_discard
	
		if draw_cards.size() <= 3:
			$hand.cards = draw_cards
			var e:Array[Card] = []
			$draw_pile.cards = e
		else:
			$hand.cards = draw_cards.slice(0, 3)
#			$draw_pile.cards = draw_cards.slice(0, draw_cards.size() - 3)
			$draw_pile.cards = draw_cards.slice(3)
			
		#print("discard after %s" % str($discard_pile.cards))
			
			
	
	print("draw pile sel %s" % card_idx)


func _on_draw_pile_drag_started(card_idx):
	print("draw pile drag %s" % card_idx)


func _on_hand_drag_started(card_idx):
	var cur_hand:Array[Card] = $hand.cards.duplicate()
	if !cur_hand.is_empty():
		var drag_col:Array[Card] = [cur_hand.pop_back()]
		#var new_hand = cur_hand
		$hand.cards = cur_hand
		$drag_column.cards = drag_col
		
	#$drag_column.cards
	print("hand pile sel %s" % card_idx)


func _on_hand_selected(card_idx):
	print("hand pile drag %s" % card_idx)


func _on_draw_pile_drop():
	print("draw pile drop")


func _on_bn_new_game_pressed():
	var deck:CardStack = preload("res://data/standard_deck.tres")
	
	var local_deck:CardStack = deck.duplicate()
	local_deck.shuffle()
	
	$col_down_0.cards = local_deck.draw_cards(1)
	$col_down_1.cards = local_deck.draw_cards(2)
	$col_down_2.cards = local_deck.draw_cards(3)
	$col_down_3.cards = local_deck.draw_cards(4)
	$col_down_4.cards = local_deck.draw_cards(5)
	$col_down_5.cards = local_deck.draw_cards(6)
	
	$col_up_0.cards = local_deck.draw_cards(1)
	$col_up_1.cards = local_deck.draw_cards(1)
	$col_up_2.cards = local_deck.draw_cards(1)
	$col_up_3.cards = local_deck.draw_cards(1)
	$col_up_4.cards = local_deck.draw_cards(1)
	$col_up_5.cards = local_deck.draw_cards(1)
	$col_up_6.cards = local_deck.draw_cards(1)
	
	var e:Array[Card] = []
	$goal_0.cards = e.duplicate()
	$goal_1.cards = e.duplicate()
	$goal_2.cards = e.duplicate()
	$goal_3.cards = e.duplicate()
	$discard_pile.cards = e.duplicate()
	$hand.cards = e.duplicate()
	$drag_column.cards = e.duplicate()
	
	$draw_pile.cards = local_deck.cards
	
	pass
