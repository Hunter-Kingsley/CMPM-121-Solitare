
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
  
  grabber.isOverDeck = false
  grabber.deckRefrence = nil
  
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
  print("GRAB - " .. tostring(self.grabPos))
  
  if self.isOverDeck == true and self.heldObject == nil and #self.deckRefrence.cards > 0 then
    print(#self.deckRefrence.cards)
    self.deckRefrence.cards[#self.deckRefrence.cards].faceUp = true
    self.deckRefrence.cards[#self.deckRefrence.cards].state = CARD_STATE.GRABBED
    print("grabbed: " .. tostring(self.deckRefrence.cards[#self.deckRefrence.cards]))
    self.heldObject = table.remove(self.deckRefrence.cards)
  end
end
function GrabberClass:release()
  print("RELEASE - ") -- WATER BUCKET
  -- NEW: some more logic stubs here
  if self.heldObject == nil then -- we have nothing to release
    self.grabPos = nil
    return
  end
  
  -- TODO: eventually check if release position is invalid and if it is
  -- return the heldObject to the grabPosition
  local isValidReleasePosition = true -- *insert actual check instead of "true"*
  if isValidReleasePosition then
    self.heldObject.position = self.currentMousePos - (self.heldObject.size / 2)
  else
    self.heldObject.position = self.grabPos - (self.heldObject.size / 2)
  end
  
  self.heldObject.state = CARD_STATE.IDLE -- it's no longer grabbed
  
  self.heldObject = nil
  self.grabPos = nil
end