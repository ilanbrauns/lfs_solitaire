# lfs_solitaire
LFS Final project with Ilan, Chloe, and Jinho!

For our final project, we chose to model a game of Solitaire. Our main goal was to model a game using different movement strategies and see which strategy was most effective and efficient for solving a game. We modeled two strategies, a foundation strategy and a pile buildup strategy. The purpose of the foundation strategy was to always prioritize moving cards to the foundation when possible. The purpose of the pile buildup strategy was to always prioritize moving cards to piles to build up the stack of unflipped cards. 

Some tradeoffs we made in choosing our representation were that we knew it would be hard to model a random game in Forge. If we wanted different card layouts in the piles/decks, it would be difficult to ensure non-determinism without hard-coding each card, which would get tedious in this game. So we knew that we couldn’t necessarily model this aspect of the game, and thus we tried brainstorming properties of the game that didn’t require randomness.

Originally, we assumed that Forge would be able to handle modeling a full deck. However, we quickly realized that the run time would be way too slow for this, and so we had to scale down the scope of our model drastically. We ended up using 12 cards, with a deck size of 2 and 4 piles, resulting in 10 cards in the piles. We ended with two suits, spades and hearts, and therefore two foundations. Our highest rank was 6. Because of the limitations of Forge, our model is extremely scaled down, and therefore very limited in what we can learn from it. 

Our original goal was to model the two different strategies and see which was more effective. However, once we significantly scaled down, the results from our strategies didn’t produce much. This is because the number of cards was so small that we couldn’t effectively show how different strategies worked on the set. We stuck to our original goal, but recognized that down the line if the capabilities of Forge were expanded, we would likely be able to see meaningful results from our strategies.

We have a custom visualization for a solitaire game that can be found in the solitaire.js file. The first thing to note about understanding the visualizer is because we are in temporal forge, the list of state progressions are listed from top to bottom, with the state index in the leftmost column. In the right column we have the actual traces representing the solitaire. In the top left corner, we have the deck with three sigs: flipped, unflipped, movable. The flipped and unflipped values are numbers representing the number of cards in each part of the deck, and the movable represents the top card of the flipped pile that can be moved in the current state. To the right of the deck we have the foundation piles, which show the top card of each of the foundations. Finally, we have all of the piles, which show the number of flipped, unflipped, and top card similar to the deck. Because solitaire is a visual game, this translates pretty well to the actual solitaire game visualization. 


Collaborators: None

