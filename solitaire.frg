#lang forge/temporal

option max_tracelength 7

-- constants for card numbers
fun DECK_SIZE: one Int { 5 }
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
    // wellformed! 
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
    #{Used.cards} = 5
    #{Deck.flipped} = 0
    #{Deck.unflipped} = 5
    no Deck.movable
}   

// general well formedness for all different sigs
pred wellformed {
    wellformed_card
    wellformed_deck
    wellformed_pile
    wellformed_foundation
}

pred wellformed_foundation {
    // no two foundations have the same suit
    all disj found1, found2 : Foundation | {
        found1.found_suit != found2.found_suit
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
    #{Deck.unflipped} < 6
    

    //deck can only decrement by 1 at a time:
}

// pred wellformed_used{
//     #{Used.cards'} >= #{Used.cards}
// }

pred wellformed_pile {
    all pile : Pile | {
        pile.id >= 0 && pile.id < 5 // 5 piles; 0 indexed
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

run {
    always{wellformed}
    initial
   // always {move} // real thing: change to always{move}
   // eventually {do_nothing}
  // eventually { #{Deck.unflipped} = 0}
  eventually {}
   always{move}
   // reset_deck
 } 
for 5 Int, exactly 5 Pile, exactly 20 Card, exactly 4 Foundation // increase bit width?

pred move {
    (#{Deck.unflipped} = 0) => {
        reset_deck
    } else {
        draw_from_deck
    }
    //draw_from_deck or do_nothing
    
   //  or move_pile or move_deck or move_to_foundation
}

pred draw_from_deck{

    // new movable card in next state 
   // Deck.movable' != Deck.movable // if we've drawn, we've changed our top card
     // some Deck.movable' 
    // some Deck.movable implies Deck.movable'.next = Deck.movable // new movable's next is old movable
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
    
}

pred move_deck_to_pile{
    //remove current movable card in deck
    // change movable card in deck to an already flipped card, or nothing
   // Deck.movable' in Deck.flipped or (#{Deck.flipped} = 0)
    // add card to pile
    some pile : Pile |
        // requirements for being able to move to a pile
        { pile.top_card.color != Deck.movable.color // have to alternate colors
        pile.top_card.rank = add[Deck.movable.rank, 1] // need to place a card on a value one higher
        } => {
            Deck.movable' = Deck.movable.next
            pile.top_card' = Deck.movable
            //pile.unflipped' does the unflipped number icnrease?
            #{pile.pile_flipped'} = #{pile.pile_flipped}
            pile.id' = pile.id
            Deck.flipped' = Deck.flipped - Deck.movable
            Deck.unflipped' = Deck.unflipped
        } else {
            pile.top_card' = pile.top_card
            pile.pile_flipped' = pile.pile_flipped
            pile.pile_unflipped' = pile.pile_unflipped
            Deck.flipped' = Deck.flipped
            Deck.unflipped' = Deck.unflipped

        }
    Used.cards' = Used.cards
            
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

// pred pile_to_pile{

// }

// pred pile_to_foundation {

//}

// pred deck_to_foundation {

// }

pred reset_deck {
    // guard
    Deck.unflipped' = Deck.flipped
    //#{Deck.flipped'} = 0
    Deck.flipped' = Deck.unflipped
    no Deck.movable' 

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

pred game_over{
    // winning_game or lost_game
    winning_game
}

// pred lost_game{
    
// }

pred winning_game {
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


// procedure: putting all the cards in Deck.flipped to Deck.unflipped

