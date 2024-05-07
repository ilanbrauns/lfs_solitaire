#lang forge/temporal

open "solitaire.frg"

// jinho
test suite for initial{
    assert wellformed_deck is necessary for initial
    assert wellformed_card is necessary for initial
    assert wellformed_piles is necessary for initial
    assert wellformed_foundation is necessary for initial

    test expect {
        valid_initial:{
//JUST INITIAL IS UNSAT??            
            all disj pile1, pile2 : Pile | {
            // pile ids are unique
                pile1.id != pile2.id   
            }
            // initial
        } is sat
        
        invalid_initial:{
            initial
            some found : Foundation | {
                found.highest_card = 4
            }
        } is unsat

        invalid_initial2:{
            initial
            some disj pile1, pile2 : Pile | {
                pile1.id = pile2.id
            }
        } is unsat
    }
}

// chloe
test suite for wellformed_card{

}
// chloe
test suite for wellformed_deck{
    
}

//ilan
test suite for wellformed_piles{
    
}

//ilan
test suite for wellformed_foundation{
    
}

// chloe
test suite for draw_from_deck{
    
}

// chloe
test suite for reset_deck{
    
}

// jinho
test suite for deck_to_pile{
    assert valid_deck_to_pile is necessary for deck_to_pile

    test expect {
        valid_deck_to_pile1:{
            some Deck.movable
            subtract[#{Deck.flipped},1] = #{Deck.flipped'}
            some pile: Pile | {
                pile.top_card.color != Deck.movable.color
                pile.top_card.rank = add[Deck.movable.rank, 1]
            }
            deck_to_pile
        } is sat
        
        invalid_deck_to_pile:{
            all pile : Pile | {
                pile.top_card.color = Deck.movable.color
            }
            deck_to_pile
        } is unsat

        invalid_deck_to_pile2:{
            no Deck.movable
            deck_to_pile
        } is unsat

        invalid_deck_to_pile3:{
            wellformed
            #{Deck.flipped} = #{Deck.flipped'}
            valid_deck_to_pile
            deck_to_pile
        } is unsat
    }   
}

// jinho
test suite for pile_to_pile {
    assert valid_pile_to_pile is necessary for pile_to_pile

    test expect {
        valid_pile_to_pile1:{
            valid_pile_to_pile
            pile_to_pile
            some disj pile1, pile2 : Pile | {
                subtract[#{pile1.pile_flipped},1] = #{pile1.pile_flipped'}
                add[#{pile2.pile_flipped},1] = #{pile2.pile_flipped'} 
                pile1.top_card' = pile1.top_card.next
            }

        } is sat
        
        invalid_pile_to_pile:{
            wellformed
            valid_pile_to_pile
            all pile : Pile | {
                #{pile.pile_flipped} <= #{pile.pile_flipped'}
            }
            pile_to_pile
        } is unsat

// THIS IS UNSAT??
        // invalid_pile_to_pile2:{
        //     wellformed
        //     // valid_pile_to_pile
        //     pile_to_pile
        // } is sat
    }
    
}

// ilan
test suite for pile_to_foundation {
    
}

// jinho
test suite for deck_to_foundation {
    assert valid_deck_to_foundation is necessary for deck_to_foundation
    expect {
        valid_deck_to_foundation1:{
            wellformed
            some found : Found | {
                found.highest_card = subtract[Deck.movable.rank, 1]
                found.highest_card' = add[found.highest_card, 1]
            }
            deck_to_foundation
        } is sat

        invalid_deck_to_foundation:{
            wellformed
            all found : Found | {
                found.highest_card = found.highest_card'
            }
            deck_to_foundation
        } is unsat

        invalid_deck_to_foundation2:{
            wellformed
            Deck.flipped = Deck.flipped'
            Deck.movable = Deck.movable'
            deck_to_foundation
        } is unsat
    }
}
