local flexbox = {}

-- Create a new flexbox layout
function flexbox.create(opts)
    local self = {}
    
    -- Default options
    self.padding = opts.padding or 10       -- Space around the container
    self.margin = opts.margin or 10         -- Space between items
    self.itemWidth = opts.itemWidth or 100  -- Default item width
    self.itemHeight = opts.itemHeight or 150 -- Default item height
    self.items = {}                         -- Items to display
    self.debug = opts.debug or false        -- Show debug outlines
    
    -- Add an item to the flexbox
    function self:addItem(item)
        table.insert(self.items, item)
    end
    
    -- Add multiple items
    function self:addItems(items)
        for _, item in ipairs(items) do
            self:addItem(item)
        end
    end
    
    -- Calculate layout based on available dimensions
    function self:layout(x, y, width, height)
        self.containerX = x + self.padding
        self.containerY = y + self.padding
        self.containerWidth = width - (self.padding * 2)
        self.containerHeight = height - (self.padding * 2)
        
        -- Calculate how many items fit per row
        local itemsPerRow = math.floor((self.containerWidth + self.margin) / (self.itemWidth + self.margin))
        if itemsPerRow < 1 then itemsPerRow = 1 end
        
        -- Position each item
        local currentX = self.containerX
        local currentY = self.containerY
        local rowHeight = 0
        
        for i, item in ipairs(self.items) do
            -- Get the item's dimensions (use default if not specified)
            local itemWidth = item.width or self.itemWidth
            local itemHeight = item.height or self.itemHeight
            rowHeight = math.max(rowHeight, itemHeight)
            
            -- Check if we need to wrap to next row
            if i > 1 and (i - 1) % itemsPerRow == 0 then
                currentX = self.containerX
                currentY = currentY + rowHeight + self.margin
                rowHeight = itemHeight
            end
            
            -- Store item position and dimensions
            item.x = currentX
            item.y = currentY
            item.width = itemWidth
            item.height = itemHeight
            
            -- Move to next position
            currentX = currentX + itemWidth + self.margin
        end
        
        -- Calculate total content height
        local rows = math.ceil(#self.items / itemsPerRow)
        self.contentHeight = (rowHeight * rows) + (self.margin * (rows - 1))
    end
    
    -- Draw the flexbox and its contents
    function self:draw()
        -- Debug: Draw container outline
        if self.debug then
            love.graphics.setColor(0.8, 0.8, 0.8, 0.5)
            love.graphics.rectangle("line", 
                self.containerX - self.margin/2, 
                self.containerY - self.margin/2, 
                self.containerWidth + self.margin, 
                self.contentHeight + self.margin
            )
        end
        
        -- Draw each item
        for _, item in ipairs(self.items) do
            if item.draw then
                -- Debug: Draw item margin
                if self.debug then
                    love.graphics.setColor(0.9, 0.7, 0.7, 0.3)
                    love.graphics.rectangle("fill", 
                        item.x - self.margin/2, 
                        item.y - self.margin/2, 
                        item.width + self.margin, 
                        item.height + self.margin
                    )
                end
                
                -- Draw the item
                item:draw(item.x, item.y, item.width, item.height)
            end
        end
    end
    
    return self
end

return flexbox 