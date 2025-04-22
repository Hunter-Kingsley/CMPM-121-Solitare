
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
  IDLE_IN_STACK = 3,
  UNDER_FULL_GRABBER = 4
}

CARD_OVERLAP_OFFSET = 30

function CardClass:new(xPos, yPos)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  card.cardBelowThis = nil
  card.z = 1
  
  return card
end

function CardClass:update()
  if self.state == CARD_STATE.GRABBED then
    local mousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
    self.position = mousePos - (self.size / 2)
  end
  
  if self.state == CARD_STATE.IDLE and self.cardBelowThis ~= nil then
    self.state = CARD_STATE.IDLE_IN_STACK
    self.z = self.cardBelowThis.z + 1
  elseif self.state == CARD_STATE.IDLE then
    -- Ensure it's not falling behind the stack
    self.z = 1
  end
  
  if self.state == CARD_STATE.IDLE_IN_STACK then
    self.position = Vector(self.cardBelowThis.position.x, self.cardBelowThis.position.y + CARD_OVERLAP_OFFSET)
  end
  
--  if self.cardBelowThis ~= nil then
--    print(self.cardBelowThis)
--  end
end

function CardClass:draw()
  -- NEW: drop shadow for non-idle cards
  if self.state == CARD_STATE.MOUSE_OVER then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED or self.cardBelowThis ~= nil and self.cardBelowThis.state == CARD_STATE.GRABBED then
    return
  end
  
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  if self.state ~= CARD_STATE.GRABBED and grabber.heldObject ~= nil and isMouseOver then
    self.state = CARD_STATE.UNDER_FULL_GRABBER
    grabber.heldObject.cardBelowThis = self
    return
  end
  
  if grabber.heldObject ~= nil and self.state ~= CARD_STATE.UNDER_FULL_GRABBER then
    grabber.heldObject.cardBelowThis = nil
    self.z = 1
  end
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  
  self:checkForGrabbed(grabber)
end

function CardClass:checkForGrabbed(grabber2)
  if self.state == CARD_STATE.MOUSE_OVER and grabber2.grabPos ~= nil then
    self.state = CARD_STATE.GRABBED
    grabber2.heldObject = self
  end
end