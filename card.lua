local UI = require("ui")

function Card(config)
    -- Simple card factory function
    local card = {
        initial_cost = config.initial_cost or 0,
        ongoing_cost = config.ongoing_cost or 0,
        symbols = config.symbols or {},
        text = config.text or "",
        recurrence = config.recurrence or "One time",
        num_tabs = math.min(math.max(config.num_tabs or 3, 2), 6), -- Clamp between 2-6
        x = config.x or 0,
        y = config.y or 0,
        width = config.width or 200,
        height = config.height or 300
    }
    
    -- Function to get proportional value based on card dimensions
    local getProportional = function(self, widthPercent, heightPercent)
        return {
            x = self.x + (self.width * widthPercent),
            y = self.y + (self.height * heightPercent),
            width = self.width * widthPercent,
            height = self.height * heightPercent
        }
    end
    
    function card:render()
        -- Card background
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

        -- Calculate font sizes based on card width
        local smallFont = love.graphics.newFont(self.width * 0.05)
        local mediumFont = love.graphics.newFont(self.width * 0.06)
        local defaultFont = love.graphics.getFont()
        
        -- Costs (top left)
        love.graphics.setFont(smallFont)
        love.graphics.print(
            "Initial: $" .. self.initial_cost, 
            self.x + (self.width * 0.05), 
            self.y + (self.height * 0.05)
        )
        love.graphics.print(
            "Ongoing: $" .. self.ongoing_cost, 
            self.x + (self.width * 0.05), 
            self.y + (self.height * 0.1)
        )

        -- Symbols (top right)
        local symbolSize = self.width * 0.1
        local symbolsPerRow = 3
        
        for i, symbol in ipairs(self.symbols) do
            local row = math.floor((i-1) / symbolsPerRow)
            local col = (i-1) % symbolsPerRow
            
            local symbolX = self.x + self.width - (symbolsPerRow - col) * (symbolSize + self.width * 0.02) - self.width * 0.05
            local symbolY = self.y + row * (symbolSize + self.height * 0.02) + self.height * 0.05
            
            love.graphics.rectangle("line", symbolX, symbolY, symbolSize, symbolSize)
            love.graphics.print(symbol, symbolX + symbolSize * 0.25, symbolY + symbolSize * 0.25)
        end

        -- Card text
        love.graphics.setFont(mediumFont)
        love.graphics.printf(
            self.text, 
            self.x + (self.width * 0.05), 
            self.y + (self.height * 0.3), 
            self.width * 0.9, 
            "left"
        )

        -- Recurrence
        love.graphics.printf(
            self.recurrence, 
            self.x + (self.width * 0.05), 
            self.y + (self.height * 0.65), 
            self.width * 0.9, 
            "center"
        )

        -- Pull-off tabs
        local tabWidth = self.width / self.num_tabs
        local tabHeight = self.height * 0.1
        
        for i = 0, self.num_tabs - 1 do
            local tabX = self.x + (i * tabWidth)
            local tabY = self.y + self.height
            
            -- Draw dashed lines
            self:drawDashedRect(tabX, tabY, tabWidth, tabHeight)
        end
        
        -- Reset font
        love.graphics.setFont(defaultFont)
    end

    function card:drawDashedRect(x, y, width, height)
        local dashLength = width * 0.025
        local spaceLength = width * 0.015
        
        -- Draw horizontal dashed lines
        for i = 0, 1 do
            local yPos = y + (i * height)
            local currentX = x
            while currentX < x + width do
                love.graphics.line(
                    currentX, 
                    yPos, 
                    math.min(currentX + dashLength, x + width), 
                    yPos
                )
                currentX = currentX + dashLength + spaceLength
            end
        end
        
        -- Draw vertical dashed lines
        for i = 0, 1 do
            local xPos = x + (i * width)
            local currentY = y
            while currentY < y + height do
                love.graphics.line(
                    xPos, 
                    currentY, 
                    xPos, 
                    math.min(currentY + dashLength, y + height)
                )
                currentY = currentY + dashLength + spaceLength
            end
        end
    end

    return card
end

return Card