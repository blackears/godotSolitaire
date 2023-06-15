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
class_name CardStack
extends Resource

@export var cards:Array[Card]

func shuffle():
	var new_cards:Array[Card] = []
	
	while !cards.is_empty():
		var idx:int = randi_range(0, cards.size() - 1)
		new_cards.append(cards[idx])
		cards.remove_at(idx)
	
	#print("--shuffle")
#	for c in new_cards:
#		print("c %s" % str(c))
	cards = new_cards
	
func draw_cards(num_cards:int)->Array[Card]:
	var result:Array[Card] = cards.slice(0, num_cards)
	cards = cards.slice(num_cards)
	return result
