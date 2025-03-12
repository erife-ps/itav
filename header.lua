local Header = {}
local Symbols = require("symbols")

function Header.load()
    Header.fonts = {
        header = love.graphics.newFont(24),
        subHeader = love.graphics.newFont(16),
        card = love.graphics.newFont(12)
    }
    
    Header.defaultFont = love.graphics.getFont()
end

function Header.draw(player, bounds)
    -- Header is already drawn in scenes.lua, just need to draw content
    love.graphics.setColor(0, 0, 0)
    
    -- Draw player name
    love.graphics.setFont(Header.fonts.header)
    love.graphics.print(player.name, bounds.x + 20, bounds.y + 10)
    
    -- Draw player stats
    love.graphics.setFont(Header.fonts.subHeader)
    love.graphics.print("Cash: $" .. player.cash, bounds.x + 20, bounds.y + 50)
    love.graphics.print("Income: $" .. player.income, bounds.x + 220, bounds.y + 50)
    
    -- Draw thrills and chills sections
    Header.drawThrills(player, bounds)
    Header.drawChills(player, bounds)
    
    -- Reset font
    love.graphics.setFont(Header.defaultFont)
end

function Header.drawThrills(player, bounds)
    -- Draw on right side of header
    local x = bounds.width - 300
    local y = bounds.y + 15
    
    love.graphics.setFont(Header.fonts.subHeader)
    love.graphics.print("Thrills:", x, y)
    
    local symbolSize = 24
    local spacing = 32
    
    for i, thrill in ipairs(player.thrills) do
        local symbolX = x + 100 + (i-1) * spacing
        local symbolY = y
        
        love.graphics.setColor(0.9, 0.9, 0.95)
        love.graphics.circle("fill", symbolX + symbolSize/2, symbolY + symbolSize/2, symbolSize/2)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", symbolX + symbolSize/2, symbolY + symbolSize/2, symbolSize/2)
        
        if thrill.known then
            love.graphics.print(string.sub(thrill.symbol, 1, 1), symbolX + 8, symbolY + 4)
        else
            love.graphics.print("?", symbolX + 10, symbolY + 4)
        end
    end
end

function Header.drawChills(player, bounds)
    -- Draw on right side of header below thrills
    local x = bounds.width - 300
    local y = bounds.y + 55
    
    love.graphics.setFont(Header.fonts.subHeader)
    love.graphics.print("Chills:", x, y)
    
    local symbolSize = 24
    local spacing = 32
    
    for i, chill in ipairs(player.chills) do
        local symbolX = x + 100 + (i-1) * spacing
        local symbolY = y
        
        love.graphics.setColor(0.95, 0.9, 0.9)
        love.graphics.circle("fill", symbolX + symbolSize/2, symbolY + symbolSize/2, symbolSize/2)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", symbolX + symbolSize/2, symbolY + symbolSize/2, symbolSize/2)
        
        if chill.known then
            love.graphics.print(string.sub(chill.symbol, 1, 1), symbolX + 8, symbolY + 4)
        else
            love.graphics.print("?", symbolX + 10, symbolY + 4)
        end
    end
end

return Header 