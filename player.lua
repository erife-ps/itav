local Player = {}
local Symbols = require("symbols")

function Player.create(name, cash, income)
    local player = {
        name = name or "Elaina",
        cash = cash or 12,
        income = income or 3,
        thrills = {},
        chills = {}
    }
    
    return player
end

function Player.setupDefaultPlayer()
    local player = Player.create()
    
    table.insert(player.thrills, {symbol = Symbols.types.star, known = true})
    table.insert(player.thrills, {symbol = Symbols.types.diamond, known = true})
    table.insert(player.thrills, {symbol = Symbols.types.heart, known = false})
    
    table.insert(player.chills, {symbol = Symbols.types.circle, known = false})
    table.insert(player.chills, {symbol = Symbols.types.square, known = false})
    table.insert(player.chills, {symbol = Symbols.types.triangle, known = true})
    
    return player
end

return Player 