
ResetButtonClass = {}

function ResetButtonClass:new(xPos, yPos)
  local resetButton = {}
  local metatable = {__index = ResetButtonClass}
  setmetatable(resetButton, metatable)
  
  resetButton.position = Vector(xPos, yPos)
  resetButton.size = Vector(200, 50)
  
  return resetButton
end

function ResetButtonClass:draw()
  love.graphics.setColor(0.9, 0.9, 0.9, 1)
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.print("RESET", self.position.x + self.size.x / 2 - 28, self.position.y + self.size.y / 2 - 10, 0, 1.5, 1.5)
end

function ResetButtonClass:resetGame()
  cardTable = {}
  
  deck.cards = {}
  deck.drawPile = {}
  
  for _, holder in ipairs(holderTable) do
    holder.cards = {}
  end
end