
require "vector"
require "holder"
require "card"

DeckClass = HolderClass:new()

function DeckClass:new(xPos, yPos)
  local Deck = {}
  local metatable = {__index = DeckClass}
  setmetatable(Deck, metatable)
  
  Deck.position = Vector(xPos, yPos)
  
  return Deck
end

function DeckClass:draw()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
  
  if debug then
    
  end 
end

function DeckClass:update()
  
end

function DeckClass:checkForMouseOver(grabber)
  if self:isMouseOver(grabber) then
    grabber.isOverDeck = true
    if grabber.deckRefrence == nil then
      grabber.deckRefrence = self
    end
  else
    grabber.isOverDeck = false
  end 
end

function DeckClass:setup()
  local values = {'A','2','3','4','5','6','7','8','9','10','J','Q','K'}
  
  for suit = 0, 3, 1 do
    print(suit)
    for _, value in ipairs(values) do
      local newCard = CardClass:new(self.position.x, self.position.y, suit, value, false)
      table.insert(cardTable, newCard)
      table.insert(self.cards, newCard)
    end
  end
  
  self:shuffle()
end

-- This funciton was given to us from lecture (Thanks Zac <3)
function DeckClass:shuffle()
  local cardCount = #self.cards
  for i = 1, cardCount do
    local randIndex = math.random(cardCount)
  local temp = self.cards[randIndex]
  self.cards[randIndex] = self.cards[cardCount]
  self.cards[cardCount] = temp
  cardCount = cardCount - 1
    end
    return deck

end