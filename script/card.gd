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
class_name Card
extends Resource

enum Suit { SPADE, HEART, DIAMOND, CLUB }
enum Rank { ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING }
enum CardColor { RED, BLACK }

@export var suit:Suit
@export var rank:Rank
@export var image:Texture2D

static func get_card_color(suit:Suit)->CardColor:
	if suit == Suit.CLUB || suit == Suit.SPADE:
		return CardColor.BLACK
	return CardColor.RED

static func prev_rank(rank:Rank)->Rank:
	return wrap(rank - 1, 0, Card.Rank.size())

static func next_rank(rank:Rank)->Rank:
	return wrap(rank + 1, 0, Card.Rank.size())
		
static func to_string_suit(suit:Suit):
	match suit:
		Suit.SPADE:
			return "Spade"
		Suit.HEART:
			return "Heart"
		Suit.DIAMOND:
			return "Diamond"
		Suit.CLUB:
			return "Club"
		
static func to_string_rank(rank:Rank):
	match rank:
		Rank.TWO:
			return "2"
		Rank.TWO:
			return "2"
		Rank.THREE:
			return "3"
		Rank.FOUR:
			return "4"
		Rank.FIVE:
			return "5"
		Rank.SIX:
			return "6"
		Rank.SEVEN:
			return "7"
		Rank.EIGHT:
			return "8"
		Rank.NINE:
			return "9"
		Rank.TEN:
			return "10"
		Rank.JACK:
			return "Jack"
		Rank.QUEEN:
			return "Queen"
		Rank.KING:
			return "King"
		Rank.ACE:
			return "Ace"
		
func _to_string():
	return "%s %s" % [to_string_suit(suit), to_string_rank(rank)]
