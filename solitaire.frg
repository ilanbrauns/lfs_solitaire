#lang forge/temporal

option max_tracelength 12
option min_tracelength 12

sig Card {
    rank: one Int, 
    color: one Int,
    suit: one Int,
    next: lone Card
}

one sig Deck {
    var flipped: set Card,
    var unflipped: set Card,
    movable: lone Card
}

sig Pile {
    id: one Int,
    var pile_flipped: set Card,
    var pile_unflipped: one Int,
    top_card: one Card 
}

one sig Used {
    var cards: set Card
}

sig Foundation {
    highest_card: one Int,
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
    all disj card1, card2 : Card | {
        // no two equal cards
        (card1.rank != card2.rank) or (card1.suit != card2.suit)
    }
    // only 5 cards used to start
    #{Used.cards} = 5
    #{Deck.flipped} = 0
    #{Deck.unflipped} = 13
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
        card.rank > 0 && card.rank <= 7
        
        // card color is 0 (black) or 1 (red)
        card.color = 0 || card.color = 1

        // card suit is 1 (heart), 2 (spade), 3 (club), or 4 (diamond)
        card.suit > 0 && card.suit < 5

        // a card's next can't be itself
        card.next != card

       (card.suit = 1 or card.suit = 4) implies card.color = 1      
       (card.suit = 2 or card.suit = 3) implies card.color = 0

    // do we need this?
    //    card.suit = card.suit'
    //    card.color = card.color'
    //    card.rank = card.rank'
    }

    #{card : Card | card.suit = 1} = 7
    #{card : Card | card.suit = 2} = 7
    #{card : Card | card.suit = 3} = 7
    #{card : Card | card.suit = 4} = 7
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
    #{Deck.unflipped} < 14
    

    //deck can only decrement by 1 at a time:
}

pred wellformed_used{
    #{Used.cards'} >= #{Used.cards}
}

pred wellformed_pile {
    all pile : Pile | {
        pile.id >= 0 && pile.id < 5 // 5 piles; 0 indexed
        pile.top_card in Used.cards 
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
    always{draw_from_deck} // real thing: change to always{move}
 } 
for 5 Int, exactly 5 Pile, exactly 28 Card, 4 Foundation 

// pred move {
//     draw_from_deck or move_pile or move_deck or move_to_foundation
// }

pred draw_from_deck{
    // size only changes by 1
    
    // #{Deck.unflipped'} = subtract[#{Deck.unflipped}, 1]  // size of unflipped decreases by 1
    // #{Deck.flipped'} = add[#{Deck.flipped}, 1] // size of flipped increases by 1
    // new movable card in next state 
    // Deck.movable != Deck.movable'
    //some Deck.movable'
    Deck.movable'.next = Deck.movable // new movable's next is old movable
    Deck.movable' in Deck.unflipped // the next movable cared came from our prior state's unfliip
    Deck.flipped' = Deck.flipped + Deck.movable' // add new movable to flipped
    Deck.unflipped' = Deck.unflipped - Deck.movable' // remove new movable from unflipped
    all pile: Pile | {
        #{pile.pile_flipped'} = #{pile.pile_flipped}
        pile.pile_unflipped' = pile.pile_unflipped

    }
}

// pred move_deck{
//     //remove current movable card in deck
//     Deck.movable' != Deck.movable
//     // change movable card in deck to an already flipped card, or nothing
//     Deck.movable' in Deck.flipped or (#{Deck.flipped} = 0)
//     // add card to pile
//     some pile : Pile |{
//         //............ idk
//     }
// }

// pred move_pile{

// }

// pred move_to_foundation {

//}

// pred game_over{
//     winning_game or lost_game
// }

// pred lost_game{

// }

// pred winning_game {
    
// }

// pred game_trace{
//     always {
//         move
//     }
//     eventually {
//         game_over
//     }
// }


// procedure: putting all the cards in Deck.flipped to Deck.unflipped

