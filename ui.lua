local UI = {}

-- Create a bounds object (x, y, width, height)
function UI.createBounds(x, y, width, height)
    return {
        x = x or 0,
        y = y or 0,
        width = width or 0,
        height = height or 0
    }
end

-- Calculate child bounds based on parent bounds and percentages
function UI.calculateChildBounds(parentBounds, xPercent, yPercent, widthPercent, heightPercent)
    return {
        x = parentBounds.x + (parentBounds.width * xPercent),
        y = parentBounds.y + (parentBounds.height * yPercent),
        width = parentBounds.width * widthPercent,
        height = parentBounds.height * heightPercent
    }
end

-- Convert percentage to pixels for a dimension
function UI.percentToPixels(percent, totalPixels)
    return totalPixels * percent
end

-- Calculate positions in a grid layout
function UI.calculateGridPositions(containerBounds, rows, cols, padding, items)
    local positions = {}
    
    -- Calculate item dimensions
    local paddingHorizontal = padding.x * (cols + 1)
    local paddingVertical = padding.y * (rows + 1)
    
    local itemWidth = (containerBounds.width - paddingHorizontal) / cols
    local itemHeight = (containerBounds.height - paddingVertical) / rows
    
    -- Calculate positions for each item
    for i = 1, #items do
        local row = math.floor((i-1) / cols)
        local col = (i-1) % cols
        
        local itemX = containerBounds.x + padding.x + col * (itemWidth + padding.x)
        local itemY = containerBounds.y + padding.y + row * (itemHeight + padding.y)
        
        table.insert(positions, {
            index = i,
            bounds = UI.createBounds(itemX, itemY, itemWidth, itemHeight)
        })
    end
    
    return positions, itemWidth, itemHeight
end

return UI 