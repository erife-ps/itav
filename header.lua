local Header = {}
local Symbols = require("symbols")

function Header.load()
    Header.fonts = {
        header = love.graphics.newFont(24),
        subHeader = love.graphics.newFont(18)
    }
end

function Header.draw(player)
    love.graphics.setFont(Header.fonts.header)
    love.graphics.print(player.name, 50, 70)
    
    love.graphics.setFont(Header.fonts.subHeader)
    love.graphics.print("Cash: " .. player.cash, 50, 100)
    love.graphics.print("Income: " .. player.income, 50, 120)
    
    Header.drawThrills(player)
    Header.drawChills(player)
end

function Header.drawThrills(player)
    love.graphics.setFont(Header.fonts.subHeader)
    local x = love.graphics.getWidth() * 0.7
    love.graphics.print("Thrills: ", x, 70)
    
    for i, thrill in ipairs(player.thrills) do
        Symbols.drawSymbol(thrill.symbol, x - 20 + i * 20, 95, thrill.known)
    end
end

function Header.drawChills(player)
    love.graphics.setFont(Header.fonts.subHeader)
    local x = love.graphics.getWidth() * 0.8
    love.graphics.print("Chills: ", x, 70)
    
    for i, chill in ipairs(player.chills) do
        Symbols.drawSymbol(chill.symbol, x - 20 + i * 20, 95, chill.known)
    end
end

return Header 