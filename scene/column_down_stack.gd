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
extends CardStackBody
class_name ColumnDownStack

@export var up_stack:NodePath

func _can_drop(cards:Array[Card])->bool:
	if !cards.is_empty():
		return false
	
	if cards[0].rank == Card.Rank.KING:
		return true
	
	return false
	

func _drop(drop_stack:CardStackBody):
	var card_stack:Array[Card] = drop_stack.cards
	
	var e:Array[Card] = []
	drop_stack.cards = e
	cards = card_stack
	
	
	

func _on_selected(card_idx):
	if cards.is_empty():
		return
	
	var up_stack:CardStackBody = get_node(up_stack)
	
	if up_stack.cards.is_empty():
		var cur_stack:Array[Card] = cards
		
		var new_card = cur_stack.pop_back()
		up_stack.cards = [new_card]
		cards = cur_stack
		



