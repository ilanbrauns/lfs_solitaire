#lang forge/temporal

open "solitaire.frg"

-- ALL TESTS WORK: ILAN 5/7 3PM 

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
//     test expect {
//         valid_deck1: {
//             wellformed_deck
//             // valid deck: two unflipped cards, 1 flipped card (movable)
//             some disj card1, card2, card3: Card | {
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped
//                 card3 = Deck.movable
//                 card3 not in Deck.unflipped
//                 card3 in Deck.flipped
//             }
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat

//         valid_deck2: {
//             wellformed_deck
//             // valid deck: 6 unflipped cards, no flipped cards (initial state)
//             some disj card1, card2, card3, card4, card5, card6: Card | {
//                 card1 in Deck.unflipped
//                 card2 in Deck.unflipped
//                 card3 in Deck.unflipped
//                 card4 in Deck.unflipped
//                 card5 in Deck.unflipped
//                 card6 in Deck.unflipped
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

// // //ilan
// // test suite for wellformed_piles{
    
// // }

// // //ilan
// // test suite for wellformed_foundation{
    
// // }

// // // chloe
// // test suite for draw_from_deck{
    
// // }

// // // chloe
// // test suite for reset_deck{
    
// // }

// // jinho
// test suite for deck_to_pile{
//    // can't do for entire search space because takes way too long    
//     assert valid_deck_to_pile is necessary for deck_to_pile 

//     test expect {
//         valid_deck_to_pile1:{
//             some Deck.movable
//             subtract[#{Deck.flipped},1] = #{Deck.flipped'}
//             some pile: Pile | {
//                 pile.top_card.color != Deck.movable.color
//                 pile.top_card.rank = add[Deck.movable.rank, 1]
//             }
//             deck_to_pile
//         } for 5 Int, exactly 3 Pile, exactly 12 Card, exactly 4 Foundation is sat
        
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

// // ilan
// test suite for pile_to_foundation {
    
// }

// // jinho
// test suite for deck_to_foundation {
//     assert valid_deck_to_foundation is necessary for deck_to_foundation
//     expect {
//         valid_deck_to_foundation1:{
//             wellformed
//             some found : Found | {
//                 found.highest_card = subtract[Deck.movable.rank, 1]
//                 found.highest_card' = add[found.highest_card, 1]
//             }
//             deck_to_foundation
//         } is sat

//         invalid_deck_to_foundation:{
//             wellformed
//             all found : Found | {
//                 found.highest_card = found.highest_card'
//             }
//             deck_to_foundation
//         } is unsat

//         invalid_deck_to_foundation2:{
//             wellformed
//             Deck.flipped = Deck.flipped'
//             Deck.movable = Deck.movable'
//             deck_to_foundation
//         } is unsat
//     }
// }
