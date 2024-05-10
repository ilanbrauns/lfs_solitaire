#lang forge/temporal

open "solitaire.frg"

// // jinho
// test suite for initial{
//     // assert wellformed_deck is necessary for initial for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation
//     // assert wellformed_card is necessary for initial for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation
//     // assert wellformed_piles is necessary for initial for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation
//     // assert wellformed_foundation is necessary for initial for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation

//     test expect {
//         valid_initial:{
//             initial          
//             all disj pile1, pile2 : Pile | {
//             // pile ids are unique
//                 pile1.id != pile2.id   
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//         invalid_initial:{
//             initial
//             some found : Foundation | {
//                 found.highest_card = 4
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         invalid_initial2:{
//             initial
//             some disj pile1, pile2 : Pile | {
//                 pile1.id = pile2.id
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }
// }

// // chloe
// test suite for wellformed_card{
//     test expect {
//         // wellformed_card1: {
          
//         // } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat

//         unmatched_color_suit: {
//             wellformed_card
//             some card: Card | {
//                 card.suit = 1
//                 card.color = 0 
//             } 
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         wrong_num_suit_allocs: {
//             wellformed_card
//             #{card : Card | card.suit = 1} = 2
//             #{card : Card | card.suit = 2} = 4
//             #{card : Card | card.suit = 3} = 1
//             #{card : Card | card.suit = 4} = 5
//         } is unsat

//         incorrect_rank: {
//             wellformed_card
//             some card: Card | {
//                 card.rank = 7
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         unused_has_next: {
//             wellformed_card
//             some disj card1, card2: Card | {
//                 card1 not in Used.cards
//                 card1.next = card2
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }
// }

// // //  some Deck.movable implies {
// // //         // Deck.movable in Used.cards
// // //         Deck.movable not in Deck.unflipped
// // //         Deck.movable in Deck.flipped
// // //     }

// // //     // non-empty deck must have some movable card
// // //    // #{Deck.flipped} > 0  implies some Deck.movable
// // //     // never exceeds 13 cards
// // //     #{Deck.unflipped} < 7

// // chloe
// test suite for wellformed_deck{
    // test expect {
    //     valid_deck1: {
    //         wellformed_deck
    //         // valid deck: two unflipped cards, 1 flipped card (movable)
    //         some disj card1, card2, card3: Card | {
    //             card1 in Deck.unflipped
    //             card2 in Deck.unflipped
    //             card3 = Deck.movable
    //             card3 not in Deck.unflipped
    //             card3 in Deck.flipped
    //         }
    //     } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat

//         valid_deck2: {
//             wellformed_deck
//             // valid deck: 6 unflipped cards, no flipped cards (initial state)
//             some disj card1, card2, card3, card4, card5, card6: Card | {
                // card1 in Deck.unflipped
                // card2 in Deck.unflipped
                // card3 in Deck.unflipped
                // card4 in Deck.unflipped
                // card5 in Deck.unflipped
                // card6 in Deck.unflipped
//                 #{Deck.flipped} = 0
//                 no Deck.movable
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat

//         too_many_cards_in_deck: {
//             wellformed_deck

//             some disj card1, card2, card3, card4, card5, card6, card7, card8: Card | {
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped
//                 card3 in Deck.unflipped
//                 card4 in Deck.unflipped
//                 card5 in Deck.unflipped
//                 card6 in Deck.unflipped
//                 card7 in Deck.unflipped
//                 card8 in Deck.unflipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         movable_in_unflipped: {
//             wellformed_deck

//             some disj card1, card2, card3, card4, card5, card6: Card | {
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped
//                 card3 in Deck.unflipped
//                 card4 in Deck.unflipped
//                 card5 in Deck.unflipped

//                 card6 = Deck.movable
//                 card6 in Deck.unflipped
//                 card6 not in Deck.flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }
// }

// jinho
// test suite for wellformed_piles{
//     test expect {
//         valid_pile1: {
//             wellformed_piles
//             some disj card1, card2, card3: Card | some pile : Pile | {
//                 card1 in pile.pile_flipped
//                 card2 in pile.pile_flipped
//                 pile.pile_unflipped > 0
//                 card3 not in pile.pile_flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//         valid_pile2: {
//             wellformed_piles
//             some disj card1,card2,card3,card4,card5: Card | some pile : Pile | {
//                 card1 in pile.pile_flipped
//                 card2 in pile.pile_flipped
//                 card3 in pile.pile_flipped
//                 pile.pile_unflipped = 0
//                 card4 not in pile.pile_flipped
//                 card5 not in pile.pile_flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//         too_many_cards_pile: {
//             initial
//             wellformed_piles
//             some disj card1, card2, card3, card4: Card | some pile : Pile | {
//                 card1 in pile.pile_flipped
//                 card2 in pile.pile_flipped
//                 card3 in pile.pile_flipped
//                 card4 in pile.pile_flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         invalid_pile_id: {
//             wellformed_piles
//             some pile : Pile | {
//                 pile.id = 6
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         invalid_pile_unflipped: {
//             initial
//             wellformed_piles
//             some pile : Pile | {
//                 pile.pile_unflipped = 10
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         card_in_multiple_piles: {
//             wellformed_piles
//             some disj pile1, pile2 : Pile | {
//                 some pile1.top_card
//                 some pile2.top_card
//                 pile1.top_card = pile2.top_card
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }
// }

//jinho
// test suite for wellformed_foundation{
//     test expect {
//         valid_foundation1: {
//             wellformed_foundation
//             all disj found1, found2 : Foundation | {
//                found1.found_suit != found2.found_suit
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 2 Foundation is sat
//         valid_foundation2: {
//             wellformed_foundation
//             all found: Foundation | {
//                 found.found_suit < 3
//                 found.found_suit > 0 
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 2 Foundation is sat
//         same_suits_foundation: {
//             wellformed_foundation
//             some disj found1,found2: Foundation | {
//                 found1.found_suit = found2.found_suit
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         invalid_highest_card_foundation: {
//             initial
//             wellformed_foundation
//             some disj found1: Foundation | {
//                 found1.highest_card < 0
//             }
//             some disj found1: Foundation | {
//                 found1.highest_card > 4
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         invalid_highest_card_foundation2: {
//             wellformed_foundation
//             some disj found1,found2: Foundation | {
//                 found1.highest_card = 12
//                 found2.highest_card = 1
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }
// }

// jinho
// test suite for draw_from_deck{
//     test expect {
//         valid_draw_from_deck1:{
//             valid_draw_from_deck
//             draw_from_deck
//             #{Deck.flipped'} = add[#{Deck.flipped},1]
//             some disj card1,card2,card3,card4,card5,card6 : Card |{
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped
//                 card3 in Deck.unflipped
//                 card4 in Deck.unflipped
//                 card5 in Deck.unflipped
//                 card6 in Deck.unflipped
//                 no Deck.movable
//                 card6 = Deck.movable'
//             }

//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//         valid_draw_from_deck2:{
//             valid_draw_from_deck
//             draw_from_deck
//             #{Deck.flipped'} = add[#{Deck.flipped},1]
//             some disj card1,card2 : Card |{
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped

//                 card1 in Deck.flipped
//                 card1 = Deck.movable

//                 card2 = Deck.movable'

//                 card1 in Deck.flipped'
//                 card2 in Deck.flipped'
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//         no_cards_in_unflipped:{
//             draw_from_deck
//             #{Deck.unflipped} = 0
//             some disj card1,card2 : Card |{
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped

//                 card1 in Deck.flipped
//                 card1 = Deck.movable

//                 card2 = Deck.movable'

//                 card1 in Deck.flipped'
//                 card2 in Deck.flipped'
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         movable_not_in_flipped:{
//             draw_from_deck
//             some disj card1,card2 : Card |{
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped

//                 card1 in Deck.flipped
//                 card1 = Deck.movable

//                 card2 = Deck.movable'

//                 card1 in Deck.flipped'
//                 card2 not in Deck.flipped'
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         used_doesnt_add_movable:{
//             draw_from_deck
//             some disj card1,card2 : Card |{
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped

//                 card1 in Deck.flipped
//                 card1 = Deck.movable

//                 card1 not in Used.cards
//                 card1 not in Used.cards'

//                 card2 = Deck.movable'

//                 card1 in Deck.flipped'
//                 card2 not in Deck.flipped'
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }   
// }

// jinho
// test suite for reset_deck{
//     test expect{
//         valid_reset_deck:{
//             reset_deck
//             #{Deck.unflipped'} = #{Deck.flipped}
//             some disj card1,card2,card3,card4,card5,card6 : Card |{
//                 card1 in Deck.unflipped'
//                 card2 in Deck.unflipped'
//                 card3 in Deck.unflipped'
//                 card4 in Deck.unflipped'
//                 card5 in Deck.unflipped'
//                 card6 in Deck.unflipped'
                
//                 card1 = Deck.movable
//                 card1 != Deck.movable'
                
//                 card1 in Deck.flipped
//                 card2 in Deck.flipped
//                 card3 in Deck.flipped
//                 card4 in Deck.flipped
//                 card5 in Deck.flipped
//                 card6 in Deck.flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//         cards_disappear_after_reset:{
//             reset_deck
//             #{Deck.unflipped'} = #{Deck.flipped}
//             #{Deck.flipped} > 0
//             some disj card1,card2,card3,card4,card5,card6 : Card |{
//                 card1 in Deck.unflipped'
//                 card2 in Deck.unflipped'
//                 card3 in Deck.unflipped'
//                 card4 in Deck.unflipped'
//                 card5 in Deck.unflipped'
//                 card6 in Deck.unflipped'
                
//                 card1 = Deck.movable
//                 card1 != Deck.movable'
                
//                 card1 not in Deck.flipped
//                 card2 in Deck.flipped
//                 card3 not in Deck.flipped
//                 card4 in Deck.flipped
//                 card5 in Deck.flipped
//                 card6 in Deck.flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         movable_not_reset:{
//             reset_deck
//             #{Deck.unflipped'} = #{Deck.flipped}
//             #{Deck.flipped} > 0
//             some disj card1,card2,card3,card4,card5,card6 : Card |{
//                 card1 in Deck.unflipped'
//                 card2 in Deck.unflipped'
//                 card3 in Deck.unflipped'
//                 card4 in Deck.unflipped'
//                 card5 in Deck.unflipped'
//                 card6 in Deck.unflipped'
                
//                 card1 = Deck.movable
//                 card1 = Deck.movable'
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//         still_a_movable:{
//             reset_deck
//             some Deck.movable'
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }
// }

// // jinho
// test suite for deck_to_pile{
//    // can't do for entire search space because takes way too long    
//     assert valid_deck_to_pile is necessary for deck_to_pile 

    // test expect {
    //     valid_deck_to_pile1:{
    //         some Deck.movable
    //         subtract[#{Deck.flipped},1] = #{Deck.flipped'}
    //         some pile: Pile | {
    //             pile.top_card.color != Deck.movable.color
    //             pile.top_card.rank = add[Deck.movable.rank, 1]
    //         }
    //         deck_to_pile
    //     } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
        
//         invalid_deck_to_pile:{
//             all pile : Pile | {
//                 pile.top_card.color = Deck.movable.color
//             }
//             deck_to_pile
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         invalid_deck_to_pile2:{
//             no Deck.movable
//             deck_to_pile
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         invalid_deck_to_pile3:{
//             wellformed
//             #{Deck.flipped} = #{Deck.flipped'}
//             valid_deck_to_pile
//             deck_to_pile
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat
//     }   
// }

// // jinho
// test suite for pile_to_pile {
//     // can't do for entire search space because takes way too long
//     assert valid_pile_to_pile is necessary for pile_to_pile 

//     test expect {
//         valid_pile_to_pile1:{
//             valid_pile_to_pile
//             pile_to_pile
//             some disj pile1, pile2 : Pile | {
//                 subtract[#{pile1.pile_flipped},1] = #{pile1.pile_flipped'}
//                 add[#{pile2.pile_flipped},1] = #{pile2.pile_flipped'} 
//                 pile1.top_card' = pile1.top_card.next
//             }

//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
        
//         invalid_pile_to_pile:{
//             wellformed
//             valid_pile_to_pile
//             all pile : Pile | {
//                 #{pile.pile_flipped} <= #{pile.pile_flipped'}
//             }
//             pile_to_pile
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is unsat

//         invalid_pile_to_pile2:{
//             wellformed
//             // valid_pile_to_pile
//             pile_to_pile
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
//     }
    
// }

// jinho
// test suite for pile_to_foundation {
//     //takes long
//     // assert valid_pile_to_foundation is necessary for pile_to_foundation
//     test expect {
//         valid_pile_to_foundation1:{
//             valid_pile_to_foundation
//             some pile: Pile | some found : Foundation | {
//                 found.highest_card = subtract[pile.top_card.rank, 1]
//                 found.highest_card' = add[found.highest_card, 1]
//                 pile.top_card.rank = found.highest_card'
//                 pile.top_card != pile.top_card'
//             }
//             pile_to_foundation
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
    
//         foundation_doesnt_change1:{
//             wellformed
//             all found : Foundation | {
//                 found.highest_card = found.highest_card'
//             }
//             pile_to_foundation
//         } is unsat

//         piles_dont_change:{
//             wellformed
//             all pile: Pile | {
//                 pile.top_card = pile.top_card
//             }
//             pile_to_foundation
//         } is unsat

//         no_movable_suit_and_rank_in_pile:{
//             wellformed
//             all pile : Pile | all found : Foundation | {
//                 found.highest_card != subtract[Pile.top_card.rank, 1] 
//             }
//             pile_to_foundation
//         } is unsat
//     }
// }

// jinho
// test suite for deck_to_foundation {
//     assert valid_deck_to_foundation is necessary for deck_to_foundation
//     test expect {
//         valid_deck_to_foundation1:{
//             valid_deck_to_foundation
//             some found : Foundation | {
//                 found.highest_card = subtract[Deck.movable.rank, 1]
//                 found.highest_card' = add[found.highest_card, 1]
//                 Deck.movable.rank = found.highest_card'
//                 Deck.movable != Deck.movable'
//             }
//             deck_to_foundation
//         } is sat
    
//         foundation_doesnt_change:{
//             wellformed
//             all found : Foundation | {
//                 found.highest_card = found.highest_card'
//             }
//             deck_to_foundation
//         } is unsat

//         deck_doesnt_change:{
//             wellformed
//             Deck.flipped = Deck.flipped'
//             Deck.movable = Deck.movable'
//             deck_to_foundation
//         } is unsat

//         no_movable_suit_and_rank:{
//             wellformed
//             Deck.flipped = Deck.flipped'
//             all found : Foundation | {
//                 found.highest_card != subtract[Deck.movable.rank, 1] 
//             }
//             deck_to_foundation
//         } is unsat
//     }
// }



test suite for random_tests{
    test expect {
        //working
        draw_from_deck_until_empty:{
            always{wellformed}
            initial
            always{valid_draw_from_deck => {draw_from_deck} else {reset_deck}}
            eventually {#{Deck.unflipped} = 0}

        } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation is sat

        //not working
        // move_to_pile_til_deck_empty:{
        //     always{wellformed}
        //     initial
        //     always{valid_deck_to_pile => {deck_to_pile} else {draw_from_deck}}
        //     eventually {#{Deck.unflipped} = 4}
        //     eventually {#{Deck.flipped} = 2}

        // } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation is sat

        //works
        move_until_game_over:{
            always{wellformed}
            initial
            always{foundation_strategy}
            eventually {game_over}

        } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation is sat

        // works
        move_until_game_over2:{
            always{wellformed}
            initial
            always{pile_buildup_strategy}
            eventually {game_over}

        } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation is sat

        //working
        pile_to_pile_until_empty:{
            always{wellformed}
            initial
            always{valid_pile_to_pile => {
                        pile_to_pile
                        } else {
                        draw_from_deck
                }}
            eventually{some p: Pile | {
                    #{p.pile_flipped} = 0
                    p.pile_unflipped = 0
                }}
        } for exactly 4 Pile, exactly 12 Card, exactly 2 Foundation is sat

    }
}