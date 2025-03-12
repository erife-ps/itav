local grid = {}

-- Create a new grid layout with specified rows, columns, and options
function grid.create(opts)
    local self = {}
    
    -- Default options
    self.rows = opts.rows or 1
    self.cols = opts.cols or 1
    self.padding = opts.padding or 0
    self.spacing = opts.spacing or 0
    self.cells = {}
    
    -- Initialize empty cells
    for i = 1, self.rows * self.cols do
        self.cells[i] = {
            content = nil,
            x = 0,
            y = 0,
            width = 0,
            height = 0
        }
    end
    
    -- Add content to a specific cell
    function self:addContent(row, col, content)
        local index = (row - 1) * self.cols + col
        if index > 0 and index <= #self.cells then
            self.cells[index].content = content
        end
    end
    
    -- Calculate grid layout based on available dimensions
    function self:layout(x, y, width, height)
        -- Calculate cell sizes
        local cellWidth = (width - self.padding * 2 - self.spacing * (self.cols - 1)) / self.cols
        local cellHeight = (height - self.padding * 2 - self.spacing * (self.rows - 1)) / self.rows
        
        -- Set positions for each cell
        for row = 1, self.rows do
            for col = 1, self.cols do
                local index = (row - 1) * self.cols + col
                local cell = self.cells[index]
                
                cell.x = x + self.padding + (col - 1) * (cellWidth + self.spacing)
                cell.y = y + self.padding + (row - 1) * (cellHeight + self.spacing)
                cell.width = cellWidth
                cell.height = cellHeight
            end
        end
    end
    
    -- Draw the grid and its contents
    function self:draw()
        for _, cell in ipairs(self.cells) do
            -- Draw cell content if it exists and has a draw method
            if cell.content and cell.content.draw then
                cell.content:draw(cell.x, cell.y, cell.width, cell.height)
            end
        end
    end
    
    -- Get dimensions of a specific cell
    function self:getCell(row, col)
        local index = (row - 1) * self.cols + col
        if index > 0 and index <= #self.cells then
            return self.cells[index]
        end
        return nil
    end
    
    return self
end

return grid 