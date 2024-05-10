#lang forge/temporal

option run_sterling "solitaire.js"

option max_tracelength 25

-- constants for card numbers
fun DECK_SIZE: one Int { 2 }
fun NUM_CARDS: one Int { 12 } 


sig Card {
    rank: one Int, 
    color: one Int,
    suit: one Int,
    var next: lone Card
}

one sig Deck {
    var flipped: set Card,
    var unflipped: set Card,
    var movable: lone Card
}

sig Pile {
    id: one Int,
    var pile_flipped: set Card,
    var pile_unflipped: one Int,
    var top_card: lone Card 
}

one sig Used {
    var cards: set Card
}

sig Foundation {
    var highest_card: one Int,
    found_suit: one Int
}

// inst optimizer {
//     Card = `Card1 + `Card2 + `Card3 + `Card4 + `Card5 + `Card6 + `Card7 + `Card8
//     Pile = `Pile1 + `Pile2

//     -- Just 2 board states (don't name the atoms the same as the sigs)
//     PuzzleState = `PuzzleState0
//     SolvedState = `SolvedState0
//     BoardState = PuzzleState + SolvedState
//     -- Upper-bound on the board relation: don't even try to use
//     -- a row, column, or value that's outside the interval [1, 9]
//     board in BoardState -> 
//              (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9) -> 
//              (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9) -> 
//              (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9)

// }


pred initial {
    all found : Foundation | {
        // no cards in foundation for now
        found.highest_card = 0
    }
    all disj pile1, pile2 : Pile | {
        // pile ids are unique
        pile1.id != pile2.id   
    }
    all pile : Pile {
        // number of unflipped cards equals the pile id
        pile.pile_unflipped = pile.id
        // only one flipped card per pile to start
        #{pile.pile_flipped} = 1
        // no pile.top_card.next
        pile.top_card in pile.pile_flipped
    }

     // cards in unflipped can't be used 
    all card: Card | {
        card in Deck.unflipped implies card not in Used.cards
        no card.next
    }
    
    // only 3 cards used to start
    #{Used.cards} = 4
    #{Deck.flipped} = 0
    #{Deck.unflipped} = DECK_SIZE
    no Deck.movable
}   

pred wellformed_foundation {
    // no two foundations have the same suit
    all disj found1, found2 : Foundation | {
        found1.found_suit != found2.found_suit
    }
    all found: Foundation | {
        found.found_suit < 3
        found.found_suit > 0 
    }
}

pred wellformed_card {
    all card : Card | {
        // card ranks are between 1-6
        card.rank > 0 && card.rank <= 6
        
        // card color is 0 (black) or 1 (red)
        card.color = 0 || card.color = 1

        // card suit is 1 (heart), 2 (spade), 3 (club), or 4 (diamond)
        card.suit > 0 && card.suit < 3

        // a card's next can't be itself
        card.next != card

       // some card.next iff card in Used.cards  // a card can only have a next if it's been flipped over
    
    //     // version for entire game
    //    (card.suit = 1 or card.suit = 4) implies card.color = 1      
    //    (card.suit = 2 or card.suit = 3) implies card.color = 0

    card.suit = 1 implies card.color = 1 
    card.suit = 2 implies card.color = 0 

    }

    #{card : Card | card.suit = 1} = 6
    #{card : Card | card.suit = 2} = 6
    // #{card : Card | card.suit = 3} = 3
    // #{card : Card | card.suit = 4} = 3

    all disj card1, card2 : Card | {
        // no two equal cards
        (card1.rank != card2.rank) or (card1.suit != card2.suit)
    }
}

pred wellformed_deck {
    // cards in a deck must not be anywhere else
    some Deck.movable implies {
        // Deck.movable in Used.cards
        Deck.movable not in Deck.unflipped
        Deck.movable in Deck.flipped
    }

    // non-empty deck must have some movable card
    #{Deck.flipped} > 0  implies some Deck.movable
    // never exceeds 13 cards
    #{Deck.unflipped} < add[DECK_SIZE, 1]
    
}

pred wellformed_piles {
    all pile : Pile | {
        pile.id >= 0 && pile.id < 4 // 4 piles; 0 indexed
        some pile.top_card implies pile.top_card in pile.pile_flipped
        
        all card: Card | {
            card in pile.pile_flipped implies card in Used.cards  // a flipped card means it's in used cards
        }

        #{pile.pile_flipped} >= 1 implies some pile.top_card
    }

    all disj pile1, pile2: Pile | {
        all card: Card | {
            card in pile1.pile_flipped implies card not in pile2.pile_flipped
            card in pile2.pile_flipped implies card not in pile1.pile_flipped
        } 
        (some pile1.top_card and some pile2.top_card) implies (pile1.top_card != pile2.top_card)
    }
}

// general well formedness for all different sigs
pred wellformed {
    wellformed_card
    wellformed_deck
    wellformed_piles
    wellformed_foundation
}

-- **WORKS**
pred valid_draw_from_deck {
    #{Deck.unflipped} > 0
}

-- **WORKS**
pred draw_from_deck{
    Deck.movable' in Deck.unflipped // the new movable card came from the deck's unflipped pile
    Deck.movable'.next' = Deck.movable // new movable's next is old movable
    Deck.flipped' = Deck.flipped + Deck.movable' // add new movable to flipped
    Deck.unflipped' = Deck.unflipped - Deck.movable' // remove new movable from unflipped
   
    Deck.movable' not in Used.cards implies Used.cards' = Used.cards + Deck.movable'
    
    all pile: Pile | {
        pile.pile_flipped' = pile.pile_flipped
        pile.pile_unflipped' = pile.pile_unflipped
        pile.top_card' = pile.top_card
    }
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }
    // keep all cards next var the same
    all other_c: Card | {
        (other_c.rank != Deck.movable'.rank or other_c.suit != Deck.movable'.suit) implies {
            other_c.next' = other_c.next
        }
    }
}

-- **READY TO TEST**
pred reset_deck {

    // swap unflipped and flipped, no movable
    Deck.unflipped' = Deck.flipped
    Deck.flipped' = Deck.unflipped
    no Deck.movable' 

    // all piles stay the same
    all pile: Pile | {
        pile.pile_flipped' = pile.pile_flipped
        pile.pile_unflipped' = pile.pile_unflipped
        pile.top_card' = pile.top_card
    }

    // used cards stay the same
    Used.cards' = Used.cards

    // foundation stays the same
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }

    // keep all cards next var the same
    all cards: Card | {
        cards.next' = cards.next
        }
}

-- **WORKS**
pred valid_deck_to_pile {
    some pile: Pile | {
        some Deck.movable
        pile.top_card.color != Deck.movable.color // have to alternate colors
        pile.top_card.rank = add[Deck.movable.rank, 1] // need to place a card on a value one higher
    }
}

-- **WORKS BESIDES ONE STUPID LINE**
pred deck_to_pile {
    some pile: Pile | {
        // guard
        some Deck.movable
        pile.top_card.color != Deck.movable.color // have to alternate colors
        pile.top_card.rank = add[Deck.movable.rank, 1] // need to place a card on a value one higher
        
        // update the deck
        some Deck.movable.next implies Deck.movable' = Deck.movable.next else no Deck.movable' // fine if movable is none
        Deck.flipped' = Deck.flipped - Deck.movable
        Deck.unflipped' = Deck.unflipped

        // update the pile
        pile.pile_flipped' = pile.pile_flipped + Deck.movable 
        pile.pile_unflipped' = pile.pile_unflipped
        pile.top_card' = Deck.movable
        pile.top_card'.next' = pile.top_card
            
        // keep all the other piles the same
        all other_p: Pile | {
            other_p.id != pile.id implies {
                other_p.pile_flipped' = other_p.pile_flipped
                other_p.pile_unflipped' = other_p.pile_unflipped
                other_p.top_card' = other_p.top_card
            }  
        }  
        // keep all cards next var the same
    all other_c: Card | {
        (other_c.rank != pile.top_card'.rank or other_c.suit != pile.top_card'.suit) implies {
            other_c.next' = other_c.next
        }
    }
    }


    // All foundations stay the same
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }
    
    // Used cards don't change
    Used.cards' = Used.cards
}

-- **READY TO TEST**
pred valid_pile_to_pile{
    some disj pile1, pile2 : Pile | {
        add[pile1.top_card.rank,1] = pile2.top_card.rank
        pile1.top_card.color != pile2.top_card.color
    }
}

-- **READY TO TEST**
pred pile_to_pile {
    // top card from pile 1 to pile 2
    some disj pile1, pile2 : Pile | {
        // guard
        pile2.top_card.rank = add[pile1.top_card.rank,1]
        pile1.top_card.color != pile2.top_card.color 

        // pile 2 updates 
        pile2.top_card' = pile1.top_card
        pile2.top_card'.next' = pile2.top_card
        pile2.pile_unflipped' = pile2.pile_unflipped
        pile2.pile_flipped' = pile2.pile_flipped + pile1.top_card
        
        // pile 1 cases
        // there is a flipped card to replace the leaving card
        some pile1.top_card.next => {

            // update the top card, flipped, and unflipped
            pile1.top_card' = pile1.top_card.next
            pile1.pile_unflipped' = pile1.pile_unflipped
            pile1.pile_flipped' = pile1.pile_flipped - pile1.top_card

            Used.cards' = Used.cards
        } else {
            // if there is no more flipped cards in the pile and no more unflipped
            (pile1.pile_unflipped = 0) => {
                // update the top card, flipped, and unflipped
                no pile1.top_card'
                pile1.pile_unflipped' = pile1.pile_unflipped
                // #{pile1.pile_flipped'} = 0
                pile1.pile_flipped' = pile1.pile_flipped - pile1.top_card

                Used.cards' = Used.cards
            // if there is no more flipped cards in the pile we need to flip over an unflipped card
            } else {
                // update the top card, flipped, and unflipped
                pile1.top_card' not in Used.cards
                pile1.pile_unflipped' = subtract[pile1.pile_unflipped,1]
                pile1.pile_flipped' = pile1.pile_flipped + pile1.top_card' - pile1.top_card

                // pile1.top_card' in Used.cards'
                Used.cards' = Used.cards + pile1.top_card'
            }
        }

    //keep all the other piles the same
    all other_p: Pile | {
        (other_p.id != pile1.id and other_p.id != pile2.id) implies {
            other_p.pile_flipped' = other_p.pile_flipped
            other_p.pile_unflipped' = other_p.pile_unflipped
            other_p.top_card' = other_p.top_card
        }  
    }
    // keep all cards next var the same
    all other_c: Card | {
        (other_c.rank != pile2.top_card'.rank or other_c.suit != pile2.top_card'.suit) implies {
            other_c.next' = other_c.next
        }
    }
}
    //keep all the foundations the same
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }

    // keep deck the same
    Deck.flipped' = Deck.flipped
    Deck.unflipped' = Deck.unflipped
    Deck.movable' = Deck.movable
}

-- **WORKS**
pred valid_pile_to_foundation { 
    // must be some pile and foundation that have matching suit and rank
    some pile: Pile, found: Foundation | {  
        found.found_suit = pile.top_card.suit
        found.highest_card = subtract[pile.top_card.rank, 1]
    }
}

-- **WORKS**
pred pile_to_foundation {
    some pile: Pile, found: Foundation | {

        // guard that the correct pile is moving to the foundation
        found.found_suit = pile.top_card.suit

        // update the foundation highest card
        found.highest_card = subtract[pile.top_card.rank, 1]
        found.highest_card' = pile.top_card.rank
        
        // if there is a next flipped card in the pile
        some pile.top_card.next => {

            // update the top card, flipped, and unflipped
            pile.top_card' = pile.top_card.next
            pile.pile_unflipped' = pile.pile_unflipped
            pile.pile_flipped' = pile.pile_flipped - pile.top_card

            Used.cards' = Used.cards
        } else {
            // if there is no more flipped cards in the pile and no more unflipped
            (pile.pile_unflipped = 0) => {

                // update the top card, flipped, and unflipped
                no pile.top_card'
                pile.pile_unflipped' = pile.pile_unflipped
                pile.pile_flipped' = pile.pile_flipped - pile.top_card

                Used.cards' = Used.cards
            // if there is no more flipped cards in the pile we need to flip over an unflipped card
            } else {
                
                // update the top card, flipped, and unflipped
                pile.top_card' not in Used.cards
                pile.pile_unflipped' = subtract[pile.pile_unflipped,1]
                pile.pile_flipped' = pile.pile_flipped + pile.top_card' - pile.top_card
            
                // pile.top_card' in Used.cards'
                Used.cards' = Used.cards + pile.top_card'
            }
        }

    //keep all the other piles the same
    all other_p: Pile | {
        other_p != pile implies {
            other_p.pile_flipped' = other_p.pile_flipped
            other_p.pile_unflipped' = other_p.pile_unflipped
            other_p.top_card' = other_p.top_card
        }  
    }
    //keep all the other foundations the same
    all other_f: Foundation | {
        other_f != found implies {
            other_f.highest_card' = other_f.highest_card
            }
        }

    // keep all cards next var the same
    all cards: Card | {
            cards.next' = cards.next
        }
    }

    // keep deck the same
    Deck.flipped' = Deck.flipped
    Deck.unflipped' = Deck.unflipped
    Deck.movable' = Deck.movable
}

-- **WORKS**
pred valid_deck_to_foundation{
    some found: Foundation | {  
        // suit and value are equal for some foundation
        found.found_suit = Deck.movable.suit
        found.highest_card = subtract[Deck.movable.rank, 1]
    }
}

-- **WORKS**
pred deck_to_foundation {
    some found: Foundation | { 
        // guard
        found.found_suit = Deck.movable.suit
        found.highest_card = subtract[Deck.movable.rank, 1]

        // update the foundation
        found.highest_card' = Deck.movable.rank 
          
        // update the deck
        Deck.flipped' = Deck.flipped  - Deck.movable
        Deck.unflipped' = Deck.unflipped
        Deck.movable' = Deck.movable.next

        // All other foundations stay the same
        all other_f: Foundation | {
            other_f != found implies {
                other_f.highest_card' = other_f.highest_card
            }
        }
    }

    // keep all piles the same
    all pile: Pile | {
        pile.pile_flipped' = pile.pile_flipped
        pile.pile_unflipped' = pile.pile_unflipped
        pile.top_card' = pile.top_card
    }

    // keep all cards next var the same
    all cards: Card | {
            cards.next' = cards.next
        }
    
    // used cards don't change
    Used.cards' = Used.cards
}

-- FINSIHED BUT NOT TESTED: LOWKEY DON'T INTED TO ACTUALLY USE SO MIGHT NOT BE WORTH TIME TESTING
pred valid_multi_pile_to_pile {
    some disj pile1, pile2 : Pile | {
        some card : Card | {
            card in pile1.pile_flipped
            add[card.rank, 1] = pile2.top_card.rank
            card.color != pile2.top_card.color
        }
    }
}

-- FINSIHED BUT NOT TESTED: LOWKEY DON'T INTED TO ACTUALLY USE SO MIGHT NOT BE WORTH TIME TESTING
-- jinho: tested, works for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation
pred multi_pile_to_pile {
    // top card from pile 1 to pile 2
    some disj pile1, pile2 : Pile | {
        some card : Card | {
            // guard
            card in pile1.pile_flipped
            add[card.rank, 1] = pile2.top_card.rank
            card.color != pile2.top_card.color

            // pile 2 updates 
            pile2.top_card' = pile1.top_card
            card.next' = pile2.top_card
            pile2.pile_unflipped' = pile2.pile_unflipped
            // pile2.pile_flipped' = pile2.pile_flipped 
            //                     + {all moved : card | { card in pile1.pile_flipped and reachable[moved, pile1.top_card, next] and not reachable[moved, card, next]}}
            all moved : card | {
                moved in pile1.pile_flipped
                reachable[moved, pile1.top_card, next]
                not reachable[moved, card, next]
                moved in pile2.pile_flipped'
            }            
            // pile 1 cases
            // there is a flipped card to replace the leaving card
            some card.next => {

                // update the top card, flipped, and unflipped
                pile1.top_card' = card.next
                pile1.pile_unflipped' = pile1.pile_unflipped
                all moved : card | {
                    card in pile1.pile_flipped
                    reachable[moved, pile1.top_card, next]
                    not reachable[moved, card, next]
                    moved not in pile1.pile_flipped'
                }
                // pile1.pile_flipped' = pile1.pile_flipped 
                //                     - {all moved : card | card in pile1.pile_flipped and reachable[moved, pile1.top_card, next] and not reachable[moved, card, next]}

                Used.cards' = Used.cards
            } else {
                // if there is no more flipped cards in the pile and no more unflipped
                (pile1.pile_unflipped = 0) => {
                    // update the top card, flipped, and unflipped
                    no pile1.top_card'
                    pile1.pile_unflipped' = pile1.pile_unflipped
                    all moved : card | {
                        card in pile1.pile_flipped
                        reachable[moved, pile1.top_card, next]
                        not reachable[moved, card, next]
                        moved not in pile1.pile_flipped'
                    }
                    // pile1.pile_flipped' = pile1.pile_flipped 
                    //                     - {all moved : card | card in pile1.pile_flipped and reachable[moved, pile1.top_card, next] and not reachable[moved, card, next]}

                    Used.cards' = Used.cards
                // if there is no more flipped cards in the pile we need to flip over an unflipped card
                } else {
                    // update the top card, flipped, and unflipped
                    pile1.top_card' not in Used.cards
                    pile1.pile_unflipped' = subtract[pile1.pile_unflipped,1]

                    all moved : card | {
                        card in pile1.pile_flipped
                        reachable[moved, pile1.top_card, next]
                        not reachable[moved, card, next]
                        moved not in pile1.pile_flipped'
                    }
                    // pile1.pile_flipped' = pile1.pile_flipped + pile1.top_card' 
                    //                     - {all moved : card | card in pile1.pile_flipped and reachable[moved, pile1.top_card, next] and not reachable[moved, card, next]}

                    // pile1.top_card' in Used.cards'
                    Used.cards' = Used.cards + pile1.top_card'
                }
            }

        //keep all the other piles the same
        all other_p: Pile | {
            (other_p.id != pile1.id and other_p.id != pile2.id) implies {
                other_p.pile_flipped' = other_p.pile_flipped
                other_p.pile_unflipped' = other_p.pile_unflipped
                other_p.top_card' = other_p.top_card
            }  
        }
        // keep all cards next var the same
        all other_c: Card | {
            (other_c.rank != card.rank or other_c.suit != card.suit) implies {
                other_c.next' = other_c.next
            }
        }
    }
}
    //keep all the foundations the same
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }

    // keep deck the same
    Deck.flipped' = Deck.flipped
    Deck.unflipped' = Deck.unflipped
    Deck.movable' = Deck.movable
}

-- FINSIHED BUT NOT TESTED: LOWKEY DON'T INTED TO ACTUALLY USE SO MIGHT NOT BE WORTH TIME TESTING
pred valid_pile_to_empty {
    some disj pile1, pile2 : Pile | {
        some pile1.top_card
        no pile2.top_card
        pile1.pile_unflipped != 0
    }
}

-- FINSIHED BUT NOT TESTED: LOWKEY DON'T INTED TO ACTUALLY USE SO MIGHT NOT BE WORTH TIME TESTING
pred pile_to_empty {
    some disj pile1, pile2 : Pile | {
        some card : Card | {
            some pile1.top_card
            no pile2.top_card
            card in pile1.flipped and no card.next

            // pile 2 updates 
            pile2.top_card' = pile1.top_card
            no card.next'
            pile2.pile_unflipped' = pile2.pile_unflipped
            // pile2.pile_flipped' = 
            all moved : card | {
                card in pile1.pile_flipped
                reachable[moved, pile1.top_card, next]
                not reachable[moved, card, next]
                moved in pile2.pile_flipped'
                }
            
            // update the top card, flipped, and unflipped
            pile1.top_card' not in Used.cards
            pile1.pile_unflipped' = subtract[pile1.pile_unflipped,1]
            all moved: card | {
                card in pile1.pile_flipped
                reachable[moved, pile1.top_card, next]
                not reachable[moved, card, next]
                moved not in pile1.pile_flipped'
            }
            // pile1.pile_flipped' = pile1.pile_flipped + pile1.top_card' 
            //                     - {all moved : card | card in pile1.pile_flipped and reachable[moved, pile1.top_card, next] and not reachable[moved, card, next]}

            // pile1.top_card' in Used.cards'
            Used.cards' = Used.cards + pile1.top_card'
                

            //keep all the other piles the same
            all other_p: Pile | {
                (other_p.id != pile1.id and other_p.id != pile2.id) implies {
                    other_p.pile_flipped' = other_p.pile_flipped
                    other_p.pile_unflipped' = other_p.pile_unflipped
                    other_p.top_card' = other_p.top_card
                }  
            }
        }
    }

    // keep all cards next var the same
    all card: Card | {
        card.next' = card.next
    }
        
    //keep all the foundations the same
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }

    // keep deck the same
    Deck.flipped' = Deck.flipped
    Deck.unflipped' = Deck.unflipped
    Deck.movable' = Deck.movable
}

-- DONE
pred winning_game {
    // all foundations have desired target value
    all found : Foundation | {
        found.highest_card = 6
    }
}

-- PHYSICALLY IMPOSSIBLE TO HAVE LOSING GAME WITH 8 CARDS I THINK - UNTESTED ON BIGGER CARD VALUES
pred losing_game{
    not winning_game
    all card : Card | {
        card in Deck.flipped or card in Deck.unflipped
        all found: Foundation | {  
            found.found_suit != Deck.movable.suit or found.highest_card != subtract[Deck.movable.rank, 1]
        }
    }
    not valid_pile_to_foundation
    not valid_deck_to_pile
    not valid_pile_to_empty
    all disj pile1, pile2 : Pile | {
        add[pile1.top_card.rank,1] != pile2.top_card.rank or pile1.top_card.color = pile2.top_card.color or #{pile1.pile_flipped} > 1
    }
}

pred game_over{
    // losing_game
    winning_game
    // winning_game or lost_game
}

// -- **WORKS**
// pred do_nothing {
//     Deck.flipped' = Deck.flipped
//     Deck.unflipped' = Deck.unflipped
//     Deck.movable' = Deck.movable

//     all pile: Pile | {
//         pile.pile_flipped' = pile.pile_flipped
//         pile.pile_unflipped' = pile.pile_unflipped
//         pile.top_card' = pile.top_card
//     }

//     Used.cards' = Used.cards

//     all found: Foundation | {
//         found.highest_card' = found.highest_card
//     }
    
//     all card: Card | {
//         card.next' = card.next
//     }
// }

pred move {
    // (#{Deck.unflipped} = 0) => {
    //     reset_deck
    // } else {
    //     draw_from_deck
    // }

    // valid_deck_to_foundation => {
    //     deck_to_foundation
    // } else {
    //     draw_from_deck
    // }

    // valid_pile_to_pile => {
    //     pile_to_pile
    // } else {
    //     draw_from_deck
    // }

       // draw_from_deck
    // valid_pile_to_foundation => {
    //     pile_to_foundation 
    // } else {
    //     do_nothing 
    // }

    // valid_deck_to_pile => {
    //    deck_to_pile
    // } else {
    //     draw_from_deck
    // }

    // valid_deck_to_pile => {
    //     deck_to_pile
    // } else {
    //     draw_from_deck
    // }

    // some pile: Pile, found: Foundation | {
    //     valid_pile_to_foundation[pile, found] 
    //     pile_to_foundation[pile, found]
    // }  

}

// procedure: putting all the cards in Deck.flipped to Deck.unflipped

// prioritizes moving from a deck to a pile
pred foundation_strategy {
    valid_deck_to_foundation => {
        deck_to_foundation 
    } else (valid_pile_to_foundation) => {
        pile_to_foundation 
    } else (valid_multi_pile_to_pile) => {
        multi_pile_to_pile
    } else (valid_pile_to_pile) => {
        pile_to_pile
    } else (valid_deck_to_pile) => {
        deck_to_pile
    } else {
        valid_draw_from_deck => {
            draw_from_deck
        } else {
            reset_deck
        }
    }
}

// prioritizes moving from a deck to a pile
pred pile_buildup_strategy {
    valid_multi_pile_to_pile => {
        multi_pile_to_pile 
    } else (valid_pile_to_pile) => {
        pile_to_pile
    } else (valid_deck_to_pile) => {
        deck_to_pile
    } else (valid_deck_to_foundation) => {
        deck_to_foundation
    } else (valid_pile_to_foundation) => {
        pile_to_foundation
    } else {
        valid_draw_from_deck => {
            draw_from_deck
        } else {
            reset_deck
        }
    }
}

// run {
//     always{wellformed}
//     initial
//     always{foundation_strategy}
//     eventually {game_over}
//     // eventually{some p: Pile | {
//     //         #{p.pile_flipped} = 0
//     //         p.pile_unflipped = 0
//     //     }}
//     //eventually {Deck.unflipped}
//     // eventually {#{Deck.unflipped} = 4}    
//     // eventually {#{Deck.flipped} = 2}
//     //     some p: Pile | {
//     //         #{p.pile_flipped} = 0
//     //         p.pile_unflipped = 0
//     //     }
//     // }
//     //eventually {#{Deck.flipped} = 0}

//  } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation

// -- Run command for traces following the foundation strategy
//  run {
//     always{wellformed}
//     initial
//     always{foundation_strategy}
//     eventually {game_over}
//  } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation

--foundation strat works for this:
// run{
//     always{wellformed}
//     initial
//     always{foundation_strategy}
//     eventually {game_over}

// } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation

-- Run command for traces following the buildup strategy
-- changed from 4 foundations to 2.. is working
 run {
    always{wellformed}
    initial
    always{pile_buildup_strategy}
    eventually {game_over}
 } for 5 Int, exactly 4 Pile, exactly 12 Card, exactly 2 Foundation