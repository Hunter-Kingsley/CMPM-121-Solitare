# It's Klondike Solitare!

The first programming pattern I implemented was the subclass. I thought that because the deck pile and the card holders both shared the purpose of being able to hold cards and pick up cards from them, it would be usefull to implement the base class holder, then have the deck class inherit from it. This was nice because the holder class had some class variables and a function that I was able to inhert instead of duplicating the code. I also used the state pattern within each of the cards. Every card has a state that it can be in that describes what scenario that card is in. Some examples include a state for when the card is in the grabber and whether a card is idle with or without another card on top of itself. This allows the logic within the card and holders to take different paths and cover different edge cases depending on the exact state of the card. 

Reviewers:
- Jason Rangel-Martinez
- Ronan Tsoi
- Phineas Asmelash

# Postmortem
This project definetly became a pain towards the end, but I'm still proud of how it turned out because I was able to get all of the functionality in. My main struggle as I got farther and farther in was how the logic for card placement became spread out among multiple different files. A certain level of this is unavoidable though with the nature of Love2D not having built in collision detection. Drawing was also a major pain point. At first I had a lot of redundant code, but I was able to condense much of it down, seperate duplicate code into a function, and make it more readable by defining variables for colors. One thing that I think bogged me down and made me waste time was fixing immediate problems instead of getting all of the correct card placement logic in before handling the edge cases. This resulted in me spending a lot of time either reworking or completley deleting old checks because they only were applicable in a previous set of circumstances with different "rules" for what it allowed and restricted.

Sprites:
- Spades PNG: https://en.wikipedia.org/wiki/File:Card_spade.svg
- Clubs PNG: https://en.wikipedia.org/wiki/File:Card_club.svg
- Hearts PNG: https://en.wikipedia.org/wiki/File:Card_heart.svg
- Diamonds PNG: https://en.wikipedia.org/wiki/File:Card_diamond.svg