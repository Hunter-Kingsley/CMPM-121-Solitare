-- Hunter Kingsley / Zac Emerzians
-- CMPM 121 - Solitare
-- 4-21-25
io.stdout:setvbuf("no")

debug = false

require "card"
require "grabber"
require "deck"
require "holder"
require "resetButton"

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
  resetButton = ResetButtonClass:new(50, 550)
  cardTable = {}
  holderTable = {}
  
  gameSetup()
end
function love.update()
  grabber:update()
  
  checkForMouseMoving()  
  
  -- Sort the table from highest to lowest Z values to determine correct drawing order
  table.sort(cardTable, zSort)
  for _, card in ipairs(cardTable) do
    card:update()
  end
  
  for _, holder in ipairs(holderTable) do
    holder:update()
  end
  
  deck:update()
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
  
  resetButton:draw()
  
  if debug then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
  end
  
  -- Win Check
  if #deck.cards == 0 and #deck.drawPile == 0 then
      love.graphics.setColor(0, 0, 1, 1)
    love.graphics.print("You Win!", 350, 60, 0, 1.5, 1.5)
  end

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

function gameSetup()
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X, TABLEAU_Y, false))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING, TABLEAU_Y, false))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 2, TABLEAU_Y, false))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 3, TABLEAU_Y, false))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 4, TABLEAU_Y, false))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 5, TABLEAU_Y, false))
  table.insert(holderTable, HolderClass:new(TABLEAU_START_X + TABLEAU_SPACING * 6, TABLEAU_Y, false))
  
  table.insert(holderTable, HolderClass:new(600, 50, true, CARD_SUIT.SPADES))
  table.insert(holderTable, HolderClass:new(670, 50, true, CARD_SUIT.CLUBS))
  table.insert(holderTable, HolderClass:new(740, 50, true, CARD_SUIT.HEARTS))
  table.insert(holderTable, HolderClass:new(810, 50, true, CARD_SUIT.DIAMONDS))
  
  cardPlacement()
end

function cardPlacement()
  deck:setup()
  
  for i = 1, 7, 1 do
    for j = 1, i, 1 do
      local currentCard = table.remove(deck.cards, #deck.cards)
      table.insert(holderTable[i].cards, currentCard)
      if j > 1 then
        currentCard.cardBelowThis = nil
        currentCard.z = j
      end
    end
    holderTable[i]:setCardPositions()
    holderTable[i].cards[#holderTable[i].cards].faceUp = true
  end
end

function love.mousereleased(mx, my, mButton)
  if mButton == 1 and 
    mx >= resetButton.position.x and mx < resetButton.position.x + resetButton.size.x and 
    my >= resetButton.position.y and my < resetButton.position.y + resetButton.size.y then

    resetButton:resetGame()
    cardPlacement()
  end
end

function zSort(a, b) return a.z < b.z end