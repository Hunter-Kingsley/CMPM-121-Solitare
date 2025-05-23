
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  -- NEW: we'll want to keep track of the object (ie. card) we're holding
  grabber.heldObject = nil
  grabber.oldHeldAbove = nil
  grabber.oldHeldBelow = nil
  
  grabber.isOverDeck = false
  grabber.deckRefrence = nil
  grabber.isOverTableau = false
  grabber.tableauRefrence = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil and self.heldObject == nil then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end  
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  
  if self.isOverDeck == true and self.heldObject == nil and #self.deckRefrence.cards > 0 then
    self.deckRefrence:getThreeCards()
  end
  
  if self.isOverTableau then
    self.grabPos = self.tableauRefrence.position + (Vector(50, 70) / 2)
  end
  
  if self.isOverTableau == true and self.heldObject == nil and #self.tableauRefrence.cards > 0 then
    self.tableauRefrence.cards[#self.tableauRefrence.cards].faceUp = true
    self.tableauRefrence.cards[#self.tableauRefrence.cards].state = CARD_STATE.GRABBED
    --self.heldObject = table.remove(self.tableauRefrence.cards, #self.tableauRefrence.cards)
    self.heldObject = self.tableauRefrence.cards[#self.tableauRefrence.cards]
  end
end
function GrabberClass:release()
  if self.heldObject == nil then -- we have nothing to release
    self.grabPos = nil
    return
  end
  
  -- TODO: eventually check if release position is invalid and if it is
  -- return the heldObject to the grabPosition
  local isValidReleasePosition = self:checkValidReleasePosition()
  if isValidReleasePosition then
    self.heldObject.position = self.currentMousePos - (self.heldObject.size / 2)
    if self.tableauRefrence ~= nil then
      if self.tableauRefrence.cards[#self.tableauRefrence.cards] == self.heldObject then
        table.remove(self.tableauRefrence.cards, #self.tableauRefrence.cards)
      end
    end
  else
    self.heldObject.position = self.grabPos - (self.heldObject.size / 2)
  end
  
  self.heldObject.state = CARD_STATE.IDLE -- it's no longer grabbed
  
  self.heldObject = nil
  self.grabPos = nil
end

function GrabberClass:checkValidReleasePosition()
  if self.heldObject == nil then
    return false
  end
  
  if self.heldObject.cardBelowThis == nil then
    return false
  end
  
  if debug then
    --print("my value: " .. self.heldObject.value .. ", below value: " .. self.heldObject.cardBelowThis.value)
    --print("my color: " .. self.heldObject.suit % 2 .. ", below color: " .. self.heldObject.cardBelowThis.suit % 2)
  end
  if self.heldObject.value == self.heldObject.cardBelowThis.value - 1 and (self.heldObject ~= self.heldObject.cardBelowThis) then
    return true
  end
  
  return false
end