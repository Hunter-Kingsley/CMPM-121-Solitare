
require "vector"

DeckClass = {}

function DeckClass:new(xPos, yPos) 
  local Deck = {}
  local metatable = {__index = DeckClass}
  setmetatable(Deck, metatable)
  
  Deck.position = Vector(xPos, yPos)
  Deck.size = Vector(50, 70)
  
  return Deck
end

function DeckClass:draw()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
  
  if debug then
    
  end 
end