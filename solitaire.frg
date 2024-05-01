#lang forge/temporal

option max_tracelength 10

-- constants for card numbers
fun DECK_SIZE: one Int { 10 }
fun NUM_CARDS: one Int { 20 } // change to 28


sig Card {
    rank: one Int, 
    color: one Int,
    suit: one Int,
    next: lone Card
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
    var top_card: one Card 
}

one sig Used {
    var cards: set Card
}

sig Foundation {
    var highest_card: one Int,
    found_suit: one Int
}

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
    }

     // cards in unflipped can't be used 
    all card: Card | {
        card in Deck.unflipped implies card not in Used.cards
    }
    
    // only 5 cards used to start
    #{Used.cards} = 4
    #{Deck.flipped} = 0
    #{Deck.unflipped} = DECK_SIZE
    no Deck.movable
}   

// general well formedness for all different sigs
pred wellformed {
    wellformed_card
    wellformed_deck
    wellformed_piles
    wellformed_foundation
}

pred wellformed_foundation {
    // no two foundations have the same suit
    all disj found1, found2 : Foundation | {
        found1.found_suit != found2.found_suit
    }
    all found: Foundation | {
        found.found_suit < 5
        found.found_suit > 0 
    }
}

pred wellformed_card {
    all card : Card | {
        // card ranks are between 1-7
        card.rank > 0 && card.rank <= 5
        
        // card color is 0 (black) or 1 (red)
        card.color = 0 || card.color = 1

        // card suit is 1 (heart), 2 (spade), 3 (club), or 4 (diamond)
        card.suit > 0 && card.suit < 5

        // a card's next can't be itself
        card.next != card

        card not in Used.cards implies no card.next // a card can only have a next if it's been flipped over

       (card.suit = 1 or card.suit = 4) implies card.color = 1      
       (card.suit = 2 or card.suit = 3) implies card.color = 0

    }

    #{card : Card | card.suit = 1} = 5
    #{card : Card | card.suit = 2} = 5
    #{card : Card | card.suit = 3} = 5
    #{card : Card | card.suit = 4} = 5

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
   // #{Deck.flipped} > 0  implies some Deck.movable
    // never exceeds 13 cards
    #{Deck.unflipped} < 11
    
}

pred wellformed_piles {
    all pile : Pile | {
        pile.id >= 0 && pile.id < 4 // 4 piles; 0 indexed
        pile.top_card in pile.pile_flipped
        
        all card: Card | {
            card in pile.pile_flipped implies card in Used.cards  // a flipped card means it's in used cards
        }
    }

    all disj pile1, pile2: Pile | {
        all card: Card | {
            card in pile1.pile_flipped implies card not in pile2.pile_flipped
            card in pile2.pile_flipped implies card not in pile1.pile_flipped
        } 
    }
}

pred valid_draw_from_deck {
    #{Deck.unflipped} = 0
}

pred draw_from_deck{
    some Deck.movable implies Deck.movable'.next = Deck.movable // new movable's next is old movable
    Deck.movable' in Deck.unflipped // the new movable card came from the deck's unflipped pile
    Deck.flipped' = Deck.flipped + Deck.movable' // add new movable to flipped
    Deck.unflipped' = Deck.unflipped - Deck.movable' // remove new movable from unflipped
    Used.cards' = Used.cards + Deck.movable'
    all pile: Pile | {
        pile.pile_flipped' = pile.pile_flipped
        pile.pile_unflipped' = pile.pile_unflipped
        pile.top_card' = pile.top_card
    }
    all found: Foundation | {
        found.highest_card' = found.highest_card
    }
}

pred valid_deck_to_pile {
    some pile: Pile | {
        pile.top_card.color != Deck.movable.color // have to alternate colors
        pile.top_card.rank = add[Deck.movable.rank, 1] // need to place a card on a value one higher
    }
}

pred move_deck_to_pile {
    some pile: Pile | {
        pile.top_card.color != Deck.movable.color // have to alternate colors
        pile.top_card.rank = add[Deck.movable.rank, 1] // need to place a card on a value one higher
    
        Deck.movable' = Deck.movable.next
        pile.top_card' = Deck.movable
        //pile.unflipped' does the unflipped number icnrease?
        #{pile.pile_flipped'} = #{pile.pile_flipped}
        pile.id' = pile.id
        Deck.flipped' = Deck.flipped - Deck.movable
        Deck.unflipped' = Deck.unflipped
    
        Used.cards' = Used.cards       
    }
}

// pred pile_to_pile {

// }

-- **WORKS
pred valid_pile_to_foundation { 
    // must be some pile and foundation that have matching suit and rank
    some pile: Pile, found: Foundation | {  
        found.found_suit = pile.top_card.suit
        found.highest_card = subtract[pile.top_card.rank, 1]
    }
}

-- **WORKS
pred pile_to_foundation {
    some pile: Pile, found: Foundation | {

        // guard that the correct pile is moving to the foundation
        found.found_suit = pile.top_card.suit

        // update the foundation highest card
        found.highest_card' = pile.top_card.rank 
        
        // if there is a next flipped card in the pile
        some pile.top_card.next => {
            pile.top_card' = pile.top_card.next
            pile.pile_unflipped' = pile.pile_unflipped
            pile.pile_flipped' = pile.pile_flipped - pile.top_card
            Used.cards' = Used.cards
        } else {
            // if there is no more flipped cards in the pile and no more unflipped
            (pile.pile_unflipped = 0) => {
                no pile.top_card'
                Used.cards' = Used.cards
                pile.pile_unflipped' = pile.pile_unflipped
                #{pile.pile_flipped'} = 0
            } else {
                // if there is no more flipped cards in the pile we need to flip over an unflipped card
                pile.top_card' not in Used.cards
                pile.top_card' in Used.cards'
                pile.pile_unflipped' = subtract[pile.pile_unflipped,1]
                pile.pile_flipped' = pile.pile_flipped + pile.top_card'
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
    }

    // keep deck the same
    Deck.flipped' = Deck.flipped
    Deck.unflipped' = Deck.unflipped
    Deck.movable' = Deck.movable
}

-- **WORKS
pred valid_deck_to_foundation{
    some found: Foundation | {  
        // suit and value are equal for some foundation
        found.found_suit = Deck.movable.suit
        found.highest_card = subtract[Deck.movable.rank, 1]
    }
}

-- **WORKS
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
    
    // used cards don't change
    Used.cards' = Used.cards
}

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
}

pred game_over{

    winning_game or lost_game
}

pred winning_game {
    // all foundations have desired target value
    all found: Foundation | {
        found.highest_card = 1
    }
}

pred lost_game{
    all found: Foundation | {
        found.highest_card = 1
    }
}

// pred game_trace{
//     always {
//         move
//     }
//     eventually {
//         game_over
//     }
// }

pred valid_pile_to_pile{
    // some disj pile1, pile2 : Pile | {
    //     add[pile1.topcard,1] = pile2.topcard
    // }
}

pred do_nothing {
    Deck.flipped' = Deck.flipped
    Deck.unflipped' = Deck.unflipped
    Deck.movable' = Deck.movable

    all pile: Pile | {
        pile.pile_flipped' = pile.pile_flipped
        pile.pile_unflipped' = pile.pile_unflipped
        pile.top_card' = pile.top_card
    }

    Used.cards' = Used.cards

    all found: Foundation | {
        found.highest_card' = found.highest_card
    }
}

pred move {
    // (#{Deck.unflipped} = 0) => {
    //     reset_deck
    // } else {
    //     draw_from_deck
    // }

    valid_deck_to_foundation => {
        deck_to_foundation
    } else {
        draw_from_deck
    }

    // valid_pile_to_foundation => {
    //     pile_to_foundation 
    // } else {
    //     do_nothing 
    // }

    // some pile: Pile, found: Foundation | {
    //     valid_pile_to_foundation[pile, found] 
    //     pile_to_foundation[pile, found]
    // }  


        
    //draw_from_deck or do_nothing
    
   //  or move_pile or move_deck or move_to_foundation
}

// procedure: putting all the cards in Deck.flipped to Deck.unflipped

// prioritizes moving from a deck to a pile
pred foundation_strategy {
    valid_deck_to_foundation => {
        deck_to_foundation 
    } else (valid_pile_to_foundation) => {
        pile_to_foundation
    } else (valid_pile_to_pile) => {
        pile_to_pile
    } else (valid_deck_to_pile) => {
        move_deck_to_pile
    } else {
        valid_draw_from_deck => {
            draw_from_deck
        } else {
            reset_deck
        }
    }
}

// prioritizes moving from a deck to a pile
// pred buildup_strategy {
//     valid_pile_to_pile => {
//         pile_to_pile 
//     } else {
//         some pile: Pile | 
//             valid_deck_to_pile[pile]  => {
//                 move_deck_to_pile[pile]
//             }
//     }
//      else (valid_deck_to_foundation) => {
//         deck_to_foundation
//     } else (valid_pile_to_foundation) => {
//         pile_to_foundation
//     } else {
//         valid_draw_from_deck => {
//             draw_from_deck
//         } else {
//             reset_deck
//         }
//     }
// }

run {
    always{wellformed}
    initial
   // always {move} // real thing: change to always{move}
   // eventually {do_nothing}
  // eventually { #{Deck.unflipped} = 0}
   
   always{move}
   eventually {winning_game}
   // reset_deck
 } for 5 Int, exactly 4 Pile, exactly 20 Card, exactly 4 Foundation // increase bit width?