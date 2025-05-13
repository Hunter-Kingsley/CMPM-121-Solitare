
require "vector"
require "holder"
require "card"

DRAW_PILE_OFFSET = 25

DeckClass = HolderClass:new()

function DeckClass:new(xPos, yPos)
  local Deck = {}
  local metatable = {__index = DeckClass}
  setmetatable(Deck, metatable)
  
  Deck.position = Vector(xPos, yPos)
  Deck.drawPile = {}
  
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
    for index, value in ipairs(values) do
      local newCard = CardClass:new(self.position.x, self.position.y, suit, index, value, false)
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

function DeckClass:getThreeCards()
  while #self.drawPile > 0 do
    local currentCard = table.remove(self.drawPile, #self.drawPile)
    table.insert(self.cards, 1, currentCard)
    currentCard.position = self.position
    currentCard.faceUp = false
    currentCard.state = CARD_STATE.IDLE
  end
  
  for i = 1, 3, 1 do
    if self.cards[#self.cards] then
      local currentCard = table.remove(self.cards, #self.cards)
      table.insert(self.drawPile, currentCard)
      currentCard.z = i
      if i ~= 3 or #self.cards < 1 then
        currentCard.state = CARD_STATE.UNGRABABLE
      end
    end
  end
  
  if #self.drawPile > 0 then
    for index, card in ipairs(self.drawPile) do
      card.position = Vector(deck.position.x + 100 + ((index - 1) * DRAW_PILE_OFFSET), deck.position.y) 
      card.faceUp = true
    end
  end
end