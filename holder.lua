
-- TODO: make the cards snap to the position of the holder, have holder acuratley store what cards are in its pile 

require "vector"

HolderClass = {}

function HolderClass:new(xPos, yPos, t, suit) 
  local Holder = {}
  local metadata = {__index = HolderClass}
  setmetatable(Holder, metadata)
  
  Holder.position = Vector(xPos, yPos)
  Holder.size = Vector(50, 70)
  Holder.cards = {}
  Holder.lastSeenCard = nil
  Holder.suit = suit
  
  Holder.isTableau = t
  
  return Holder
end

function HolderClass:draw()
  love.graphics.setColor(black)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
  
  -- Draw suit icons if the suit is set
  if self.suit and Sprites[self.suit + 1] then
    love.graphics.setColor(white)
    local sprite = Sprites[self.suit + 1]
    love.graphics.draw(sprite, self.position.x + 30, self.position.y + 2, 0, 0.11, 0.11)
    love.graphics.draw(sprite, self.position.x + 5, self.position.y + 50, 0, 0.11, 0.11)
  end
  
  if debug then
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(tostring(#self.cards), self.position.x + 10, self.position.y - 20)
  end
end

function HolderClass:update()
  if self.isTableau then
    for _, card in ipairs(self.cards) do
      if card.state == CARD_STATE.IDLE then
        card.state = CARD_STATE.UNGRABABLE
      end
    end
    
--    if self.cards[#self.cards] ~= nil then
--      if (self.cards[#self.cards].cardBelowThis ~= nil and (self.cards[#self.cards].state ~= CARD_STATE.GRABBED) or (self.cards[#self.cards].state == CARD_STATE.UNGRABABLE)) then
--        table.remove(self.cards, #self.cards)
--      end
--    end
  else
    if self.cards[#self.cards] ~= nil then
      if (self.cards[#self.cards].cardBelowThis ~= nil and (self.cards[#self.cards].state ~= CARD_STATE.GRABBED) or (self.cards[#self.cards].state == CARD_STATE.UNGRABABLE)) then
        table.remove(self.cards, #self.cards)
        if #self.cards > 0 then
          self.cards[#self.cards].faceUp = true
        end
      end
    end
    
    if #self.cards == 1 and self.cards[#self.cards].value == 13 then
      for _, holder in ipairs(holderTable) do
        if holder.cards[#holder.cards] == self.cards[#self.cards] and #holder.cards > 1 then
          table.remove(holder.cards, #holder.cards)
          if #holder.cards > 0 then
            holder.cards[#holder.cards].faceUp = true
          end
        end
      end
    end
  end
  
--  if #self.cards > 0 then
--    if self.cards[#self.cards].state == CARD_STATE.UNGRABABLE or self.cards[#self.cards].state == CARD_STATE.IDLE_IN_STACK then
--      local currentCard = table.remove(self.drawPile, #self.drawPile)
--      self.drawPile[#self.drawPile].state = CARD_STATE.IDLE
--    end
--  end
end

function HolderClass:checkForMouseOver(grabber)
  if self.isTableau == true then
    if self:isMouseOver(grabber) then
      grabber.tableauRefrence = self
    end
    if grabber.tableauRefrence == self then
      if self:isMouseOver(grabber) then
        grabber.isOverTableau = true
      else
        grabber.isOverTableau = false
      end
    end
  end
  
  if grabber.heldObject ~= nil and self:isMouseOver(grabber) then
    if self.isTableau then
      if grabber.heldObject.value == #self.cards + 1 and grabber.heldObject.suit == self.suit and grabber.heldObject.cardAboveThis == nil then
          self.lastSeenCard = grabber.heldObject
      end
      
    else
      if grabber.heldObject.value == 13 then
        self.lastSeenCard = grabber.heldObject
      end
    end
  end
  
  if self.lastSeenCard ~= nil then
    if self:isMouseOver(grabber) and self.lastSeenCard.state ~= CARD_STATE.GRABBED then
      if self.cards[#self.cards] ~= self.lastSeenCard then
        table.insert(self.cards, self.lastSeenCard)
        self.cards[#self.cards].z = #self.cards
        if self.isTableau then
          self.cards[#self.cards].state = CARD_STATE.UNGRABABLE
          self.cards[#self.cards].position = self.position
        end
      end
    end
    
    if grabber.heldObject == nil then
      if self.lastSeenCard ~= nil and self.lastSeenCard.state == CARD_STATE.GRABBED then
        self.lastSeenCard = nil
        table.remove(self.cards, #self.cards)
      end
    end
    
    if self.cards[1] ~= nil and self.cards[1].position ~= self.position then
      self.cards[1].position = self.position
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

function HolderClass:setCardPositions()
  for index, card in ipairs(self.cards) do
    card.position.x = self.position.x
    card.position.y = self.position.y + (index - 1) * CARD_OVERLAP_OFFSET
  end
end