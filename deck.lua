
DeckClass = {}

function DeckClass:new() 
  local Deck = {}
  local metatable = {__index = DeckClass}
  setmetatable{deck, metatable}
  
  
  
end