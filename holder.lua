
-- TODO: make the cards snap to the position of the holder, have holder acuratley store what cards are in its pile 

require "vector"

HolderClass = {}

function HolderClass:new(xPos, yPos) 
  local Holder = {}
  local metadata = {__index = HolderClass}
  setmetatable(Holder, metadata)
  
  Holder.position = Vector(xPos, yPos)
  Holder.size = Vector(50, 70)
  Holder.cards = {}
  Holder.lastSeenCard = nil
  
  return Holder
end

function HolderClass:draw()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
  
  if debug then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(#self.cards), self.position.x + 10, self.position.y - 20)
  end
end

function HolderClass:update()
  if self.cards[1].position ~= self.position then
    self.cards[1].position = self.position
  end
end

function HolderClass:checkForMouseOver(grabber)
  if grabber.heldObject ~= nil and self:isMouseOver(grabber) then
    self.lastSeenCard = grabber.heldObject
  end
  if self.lastSeenCard ~= nil then
    if self:isMouseOver(grabber) and self.lastSeenCard.state ~= CARD_STATE.GRABBED then
      table.insert(self.cards, self.lastSeenCard)
    end
  end
  
  
  if self:isMouseOver(grabber) == false then
    self.lastSeenCard = nil
  end
end

function HolderClass:isMouseOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
    
    return isMouseOver
end