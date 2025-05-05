-- Hunter Kingsley / Zac Emerzians
-- CMPM 121 - Solitare
-- 4-21-25
io.stdout:setvbuf("no")

debug = false

require "card"
require "grabber"
require "deck"
require "holder"

TABLEAU_START_X = 73
TABLEAU_SPACING = 123
TABLEAU_Y = 200

function love.load()
  math.randomseed(os.time())
  love.window.setMode(960, 640)
  love.window.setTitle("Solitare - Hunter Kingsley")
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  grabber = GrabberClass:new()
  deck = DeckClass:new(50, 50)
  cardTable = {}
  holderTable = {}
  
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 2, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 3, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 4, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 5, TABLEAU_Y))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 6, TABLEAU_Y))
  
  table.insert(holderTable, HolderClass:new(600, 50))
  table.insert(holderTable, HolderClass:new(670, 50))
  table.insert(holderTable, HolderClass:new(740, 50))
  table.insert(holderTable, HolderClass:new(810, 50))
  
  deck:setup()
end
function love.update()
  grabber:update()
  
  checkForMouseMoving()  
  
  -- Sort the table from highest to lowest Z values to determine correct drawing order
  table.sort(cardTable, zSort)
  for _, card in ipairs(cardTable) do
    card:update()
  end
end
function love.draw()
  love.graphics.setColor(0, 0, 0, 1)
  
  deck:draw()
  
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
  
  deck:checkForMouseOver(grabber)
end

function zSort(a, b) return a.z < b.z end