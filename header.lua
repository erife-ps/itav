local Header = {}
local Symbols = require("symbols")

function Header.load()
    Header.fonts = {
        header = love.graphics.newFont(16),
        subHeader = love.graphics.newFont(12),
        card = love.graphics.newFont(10)
    }
    
    Header.defaultFont = love.graphics.getFont()
end

function Header.draw(player)
    love.graphics.setColor(0.95, 0.95, 0.95)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 40)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), 40)
    love.graphics.setColor(0, 0, 0)
    
    love.graphics.setFont(Header.fonts.header)
    love.graphics.print(player.name, 10, 5)
    
    love.graphics.setFont(Header.fonts.subHeader)
    love.graphics.print("Cash: $" .. player.cash, 10, 25)
    love.graphics.print("Income: $" .. player.income, 120, 25)
    
    Header.drawThrills(player)
    Header.drawChills(player)
    
    love.graphics.setFont(Header.defaultFont)
end

function Header.drawThrills(player)
    love.graphics.setFont(Header.fonts.subHeader)
    local x = love.graphics.getWidth() - 260
    love.graphics.print("Thrills:", x, 10)
    
    for i, thrill in ipairs(player.thrills) do
        local symbolX = x + 50 + (i-1) * 20
        local symbolY = 10
        
        love.graphics.setColor(0.9, 0.9, 0.95)
        love.graphics.circle("fill", symbolX + 8, symbolY + 8, 8)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", symbolX + 8, symbolY + 8, 8)
        
        if thrill.known then
            love.graphics.print(string.sub(thrill.symbol, 1, 1), symbolX + 4, symbolY + 2)
        else
            love.graphics.print("?", symbolX + 4, symbolY + 2)
        end
    end
end

function Header.drawChills(player)
    love.graphics.setFont(Header.fonts.subHeader)
    local x = love.graphics.getWidth() - 140
    love.graphics.print("Chills:", x, 10)
    
    for i, chill in ipairs(player.chills) do
        local symbolX = x + 50 + (i-1) * 20
        local symbolY = 10
        
        love.graphics.setColor(0.95, 0.9, 0.9)
        love.graphics.circle("fill", symbolX + 8, symbolY + 8, 8)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", symbolX + 8, symbolY + 8, 8)
        
        if chill.known then
            love.graphics.print(string.sub(chill.symbol, 1, 1), symbolX + 4, symbolY + 2)
        else
            love.graphics.print("?", symbolX + 4, symbolY + 2)
        end
    end
end

return Header 