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
class_name GoalStackBody

func _can_drop(drop_cards:Array[Card])->bool:
	if drop_cards.size() != 1:
		return false
	
	var drop_card:Card = drop_cards[0]
	
	if cards.is_empty():
		if drop_card.rank == Card.Rank.ACE:
			return true
	else:
		var last_card:Card = cards.back()
		if last_card.suit == drop_card.suit && last_card.rank + 1 == drop_card.rank:
			return true
		
	
	#print("can_drop_query")
	return false

func _drop(drop_stack:CardStackBody):
	var new_stack:Array[Card] = cards.duplicate()
	new_stack.append_array(drop_stack.cards)
	cards = new_stack
	dirty = true
	
	var e:Array[Card] = []
	drop_stack.cards = e
	
	

## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_drag_started(card_idx):
	print("--drag start--")
#	var card_table:CardTable = get_parent()
#
#	var drag_col:CardStackBody = card_table.get_node("drag_column")
#
#	var remain:Array[Card] = cards.slice(0, card_idx)
#	var drag_part:Array[Card] = cards.slice(card_idx)
#
#	drag_col.cards = drag_part
#	cards = remain
	
	pass # Replace with function body.


func _on_selected(card_idx):
	print("--selected--")
	pass # Replace with function body.
