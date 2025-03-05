function Card(config)
    local card = {
        initial_cost = config.initial_cost or 0,
        ongoing_cost = config.ongoing_cost or 0,
        symbols = config.symbols or {},
        text = config.text or "",
        recurrence = config.recurrence or "One time",
        num_tabs = math.min(math.max(config.num_tabs or 3, 2), 6), -- Clamp between 2-6
        x = config.x or 0,
        y = config.y or 0,
        width = 200,
        height = 300
    }

    function card:render()
        -- Card background
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

        -- Costs (top left)
        love.graphics.print("Initial: $" .. self.initial_cost, self.x + 10, self.y + 10)
        love.graphics.print("Ongoing: $" .. self.ongoing_cost, self.x + 10, self.y + 30)

        -- Symbols (top right)
        local symbol_size = 20
        local symbols_per_row = 3
        for i, symbol in ipairs(self.symbols) do
            local row = math.floor((i-1) / symbols_per_row)
            local col = (i-1) % symbols_per_row
            local symbol_x = self.x + self.width - (symbols_per_row - col) * (symbol_size + 5) - 10
            local symbol_y = self.y + row * (symbol_size + 5) + 10
            love.graphics.rectangle("line", symbol_x, symbol_y, symbol_size, symbol_size)
            love.graphics.print(symbol, symbol_x + 5, symbol_y + 5)
        end

        -- Card text
        love.graphics.printf(self.text, self.x + 10, self.y + 100, self.width - 20, "left")

        -- Recurrence
        love.graphics.printf(self.recurrence, self.x + 10, self.y + 200, self.width - 20, "center")

        -- Pull-off tabs
        local tab_width = self.width / self.num_tabs
        local tab_height = 30
        for i = 0, self.num_tabs - 1 do
            local tab_x = self.x + (i * tab_width)
            local tab_y = self.y + self.height
            
            -- Draw dashed lines
            self:drawDashedRect(tab_x, tab_y, tab_width, tab_height)
        end
    end

    function card:drawDashedRect(x, y, width, height)
        local dash_length = 5
        local space_length = 3
        
        -- Draw horizontal dashed lines
        for i = 0, 1 do
            local y_pos = y + (i * height)
            local current_x = x
            while current_x < x + width do
                love.graphics.line(current_x, y_pos, 
                    math.min(current_x + dash_length, x + width), y_pos)
                current_x = current_x + dash_length + space_length
            end
        end
        
        -- Draw vertical dashed lines
        for i = 0, 1 do
            local x_pos = x + (i * width)
            local current_y = y
            while current_y < y + height do
                love.graphics.line(x_pos, current_y, 
                    x_pos, math.min(current_y + dash_length, y + height))
                current_y = current_y + dash_length + space_length
            end
        end
    end

    return card
end

return Card