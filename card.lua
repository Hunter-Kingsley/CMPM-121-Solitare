
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
  IDLE_IN_STACK = 3,
  UNDER_FULL_GRABBER = 4
}

CARD_SUIT = {
  SPADES = 0,
  HEARTS = 1,
  CLUBS = 2,
  DIAMONDS = 3
}

Sprites = {
    love.graphics.newImage("assets/spades.png"),
    love.graphics.newImage("assets/hearts.png"),
    love.graphics.newImage("assets/clubs.png"),
    love.graphics.newImage("assets/diamonds.png")
  }

CARD_OVERLAP_OFFSET = 20

function CardClass:new(xPos, yPos, suit, value)
  local card = {}
  local metadata = {
    __index = CardClass,
    -- Setting two cards equal returns whether or not they are the same color
    __eq = function(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then return false end
    return (a.suit % 2) == (b.suit % 2)
  end
    }
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  card.cardBelowThis = nil
  card.cardAboveThis = nil
  card.z = 1
  card.suit = suit
  card.value = value
  
  return card
end

function CardClass:update()
  if self.state == CARD_STATE.GRABBED then
    local mousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
    self.position = mousePos - (self.size / 2)
    self.z = 100
  end
  
  if self.state == CARD_STATE.IDLE and self.cardBelowThis ~= nil then
    self.state = CARD_STATE.IDLE_IN_STACK
    self.z = self.cardBelowThis.z + 1
  elseif self.state == CARD_STATE.IDLE and self.cardAboveThis ~= nil then
    self.state = CARD_STATE.IDLE_IN_STACK
  elseif self.state == CARD_STATE.IDLE then
    -- Ensure it's not falling behind the stack
    self.z = 1
  end
  
  if self.cardBelowThis ~= nil then
    self.z = self.cardBelowThis.z + 1
  else
    self.z = 1
  end
  
  if self.cardBelowThis ~= nil and self.state ~= CARD_STATE.GRABBED then
    self.position = Vector(self.cardBelowThis.position.x, self.cardBelowThis.position.y + CARD_OVERLAP_OFFSET)
  end
  
--  if self.state == CARD_STATE.GRABBED and self.cardBelowThis == nil then
--    self.z = 100
--  end
end

function CardClass:draw()
  -- NEW: drop shadow for non-idle cards
  if self.state ~= CARD_STATE.IDLE and self.state ~= CARD_STATE.IDLE_IN_STACK then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  -- fill white
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  -- black outline
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  -- place card value and suit
  if self.suit == CARD_SUIT.SPADES then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.value), self.position.x + 5, self.position.y + 0, 0, 1.2, 1.2)
    love.graphics.print(tostring(self.value), self.position.x + 37, self.position.y + 50, 0, 1.2, 1.2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Sprites[CARD_SUIT.SPADES + 1], self.position.x + 30, self.position.y + 0, 0, 0.11, 0.11)
    love.graphics.draw(Sprites[CARD_SUIT.SPADES + 1], self.position.x + 5, self.position.y + 50, 0, 0.11, 0.11)
  end
  if self.suit == CARD_SUIT.HEARTS then
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print(tostring(self.value), self.position.x + 5, self.position.y + 0, 0, 1.2, 1.2)
    love.graphics.print(tostring(self.value), self.position.x + 37, self.position.y + 50, 0, 1.2, 1.2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Sprites[CARD_SUIT.HEARTS + 1], self.position.x + 30, self.position.y + 0, 0, 0.11, 0.11)
    love.graphics.draw(Sprites[CARD_SUIT.HEARTS + 1], self.position.x + 5, self.position.y + 50, 0, 0.11, 0.11)
  end
  if self.suit == CARD_SUIT.CLUBS then
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.value), self.position.x + 5, self.position.y + 0, 0, 1.2, 1.2)
    love.graphics.print(tostring(self.value), self.position.x + 37, self.position.y + 50, 0, 1.2, 1.2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Sprites[CARD_SUIT.CLUBS + 1], self.position.x + 30, self.position.y + 0, 0, 0.11, 0.11)
    love.graphics.draw(Sprites[CARD_SUIT.CLUBS + 1], self.position.x + 5, self.position.y + 50, 0, 0.11, 0.11)
  end
  if self.suit == CARD_SUIT.DIAMONDS then
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print(tostring(self.value), self.position.x + 5, self.position.y + 0, 0, 1.2, 1.2)
    love.graphics.print(tostring(self.value), self.position.x + 37, self.position.y + 50, 0, 1.2, 1.2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Sprites[CARD_SUIT.DIAMONDS + 1], self.position.x + 30, self.position.y + 0, 0, 0.11, 0.11)
    love.graphics.draw(Sprites[CARD_SUIT.DIAMONDS + 1], self.position.x + 5, self.position.y + 50, 0, 0.11, 0.11)
  end
  
  if debug then
    -- print state, value of card under, value of card above, and z value
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print(tostring(self.z), self.position.x + 75, self.position.y)
    if self.cardBelowThis ~= nil then
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.print(tostring(self.cardBelowThis.value), self.position.x + 55, self.position.y - 20)
    end
    if self.cardAboveThis ~= nil then
      love.graphics.setColor(0, 0, 1, 1)
      love.graphics.print(tostring(self.cardAboveThis.value), self.position.x + 65, self.position.y + 20)
    end
  end
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED or self.cardBelowThis ~= nil and self.cardBelowThis.state == CARD_STATE.GRABBED then
    return
  end
  if self.cardAboveThis ~= nil and (grabber.heldObject ~= nil and self.state == CARD_STATE.IDLE) then
    return
  end
  
  local mousePos = grabber.currentMousePos
  local isMouseOver = nil
  if self.cardAboveThis ~= nil and grabber.heldObject == nil then
    isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + CARD_OVERLAP_OFFSET
  elseif self.cardAboveThis ~= nil and grabber.heldObject.cardBelowThis ~= self then
    isMouseOver = false
  else
    isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  end
  
  
  if self.state ~= CARD_STATE.GRABBED and grabber.heldObject ~= nil and isMouseOver then
    self.state = CARD_STATE.UNDER_FULL_GRABBER
    grabber.heldObject.cardBelowThis = self
    self.cardAboveThis = grabber.heldObject
    return
  end
  
--  if grabber.heldObject ~= nil and self.state ~= CARD_STATE.UNDER_FULL_GRABBER then
--    grabber.heldObject.cardBelowThis = nil
--    self.z = 1
--  end

  if grabber.heldObject ~= nil then
    if grabber.heldObject.cardBelowThis == self and self.state ~= CARD_STATE.UNDER_FULL_GRABBER then
      grabber.heldObject.cardBelowThis = nil
      self.cardAboveThis = nil
    elseif self.cardAboveThis == grabber.heldObject then
      self.cardAboveThis = nil
    end
  end
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  
  if isMouseOver then
    self.state = CARD_STATE.MOUSE_OVER
  elseif self.cardAboveThis ~= nil then
    self.state = CARD_STATE.IDLE_IN_STACK
  else
    self.state = CARD_STATE.IDLE
  end
  
  self:checkForGrabbed(grabber)
end

function CardClass:checkForGrabbed(grabber2)
  if self.state == CARD_STATE.MOUSE_OVER and grabber2.grabPos ~= nil then
    self.state = CARD_STATE.GRABBED
    grabber2.heldObject = self
  end
end