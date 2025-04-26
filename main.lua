-- Hunter Kingsley / Zac Emerzians
-- CMPM 121 - Solitare
-- 4-21-25
io.stdout:setvbuf("no")

debug = true

require "card"
require "grabber"
require "deck"
require "holder"

TABLEAU_START_X = 73
TABLEAU_SPACING = 123
TABLEAU_Y = 200

function love.load()
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  grabber = GrabberClass:new()
  cardTable = {}
  holderTable = {}
  
  table.insert(cardTable, CardClass:new(100, 100, CARD_SUIT.SPADES, 2))
  table.insert(cardTable, CardClass:new(200, 200, CARD_SUIT.HEARTS, 3))
  table.insert(cardTable, CardClass:new(300, 300, CARD_SUIT.CLUBS, 4))
  table.insert(cardTable, CardClass:new(400, 400, CARD_SUIT.DIAMONDS, 5))
  
  --table.insert(holderTable, DeckClass:new(50, 50))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 2, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 3, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 4, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 5, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 6, TABLEAU_Y))
  
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
  love.graphics.setColor(0, 0, 0, 1)
  
  for _, holder in ipairs(holderTable) do
    holder:draw()
  end
  
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
  
  for _, holder in ipairs(holderTable) do
    holder:checkForMouseOver(grabber)
  end
end

function zSort(a, b) return a.z < b.z end