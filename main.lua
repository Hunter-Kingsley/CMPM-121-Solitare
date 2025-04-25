-- Hunter Kingsley / Zac Emerzians
-- CMPM 121 - Solitare
-- 4-21-25
io.stdout:setvbuf("no")

require "card"
require "grabber"

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  table.insert(cardTable, CardClass:new(100, 100, CARD_SUIT.SPADES, 2))
  table.insert(cardTable, CardClass:new(200, 200, CARD_SUIT.HEARTS, 3))
  table.insert(cardTable, CardClass:new(300, 300, CARD_SUIT.CLUBS, 4))
  table.insert(cardTable, CardClass:new(400, 400, CARD_SUIT.DIAMONDS, 5))
  
end
function love.update()
  grabber:update()
  
  checkForMouseMoving()  
  
  table.sort(cardTable, zSort)
  for _, card in ipairs(cardTable) do
    card:update()
  end
end
function love.draw()
  for _, card in ipairs(cardTable) do
    card:draw() --card.draw(card)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end

function zSort(a, b) return a.z < b.z end