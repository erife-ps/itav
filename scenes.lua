local Scenes = {}
local Header = require("header")
local Card = require("card")
local UI = require("ui")

function Scenes.load()
    Scenes.current = "bulletinBoard"
    
    Scenes.draw = {
        bulletinBoard = Scenes.drawBulletinBoard,
        event = Scenes.drawEvent
    }
    
    -- Store cards for the bulletin board
    Scenes.bulletinCards = {}
    
    -- Fixed header height
    Scenes.headerHeight = 100
    
    -- Margin for bulletin board
    Scenes.margin = 10
    
    -- Height reserved for bulletin board title
    Scenes.boardTitleHeight = 50
end

function Scenes.addCardToBulletin(card)
    table.insert(Scenes.bulletinCards, card)
    Scenes.arrangeCards()
end

function Scenes.arrangeCards()
    -- Get screen dimensions
    local screenWidth, screenHeight = love.graphics.getDimensions()
    
    -- Calculate bulletin board area with fixed margins
    local boardX = Scenes.margin
    local boardY = Scenes.headerHeight + Scenes.margin
    local boardWidth = screenWidth - (Scenes.margin * 2)
    local boardHeight = screenHeight - Scenes.headerHeight - (Scenes.margin * 2)
    
    -- Store bulletin board dimensions for drawing
    Scenes.bulletinBounds = {
        x = boardX,
        y = boardY,
        width = boardWidth,
        height = boardHeight
    }
    
    -- Define the title area at the top of the bulletin board
    Scenes.boardTitleBounds = {
        x = boardX,
        y = boardY,
        width = boardWidth,
        height = Scenes.boardTitleHeight
    }
    
    -- Define the cards area (below the title with bottom margin)
    local bottomMargin = 30 -- Extra margin at the bottom of the board
    Scenes.cardsAreaBounds = {
        x = boardX,
        y = boardY + Scenes.boardTitleHeight,
        width = boardWidth,
        height = boardHeight - Scenes.boardTitleHeight - bottomMargin
    }
    
    -- Calculate number of cards per row and column (5 across, 2 down)
    local cols = 5
    local rows = 2
    
    -- Account for pull-off tabs in the cards
    local tabHeight = 30 -- Fixed height for tabs in pixels
    
    -- Enforce minimum card margin of 10px
    local minCardMargin = 15 -- Increased from 10 to 15 for more space
    
    -- Calculate maximum card width (1/5 of card area width minus margins)
    local maxCardWidth = (Scenes.cardsAreaBounds.width / cols) - (minCardMargin * 2)
    
    -- Calculate maximum card height (1/2 of card area height minus margins)
    -- Reserve space for the tabs below each card
    local maxCardHeight = (Scenes.cardsAreaBounds.height - tabHeight) / rows - (minCardMargin * 2)
    
    -- Calculate actual card dimensions (maintain aspect ratio)
    local cardWidth, cardHeight
    
    -- Use 1.4 aspect ratio (height = 1.4 * width)
    if maxCardHeight / maxCardWidth > 1.4 then
        -- Width is the limiting factor
        cardWidth = maxCardWidth
        cardHeight = cardWidth * 1.4
    else
        -- Height is the limiting factor
        cardHeight = maxCardHeight
        cardWidth = cardHeight / 1.4
    end
    
    -- Calculate actual horizontal and vertical spacing
    local horizontalSpacing = (Scenes.cardsAreaBounds.width - (cols * cardWidth)) / (cols + 1)
    local verticalSpacing = (Scenes.cardsAreaBounds.height - (rows * cardHeight) - tabHeight) / (rows + 1)
    
    -- Make sure spacing is at least the minimum margin
    horizontalSpacing = math.max(horizontalSpacing, minCardMargin)
    verticalSpacing = math.max(verticalSpacing, minCardMargin)
    
    -- Position each card
    for i, card in ipairs(Scenes.bulletinCards) do
        -- Calculate row and column (0-indexed)
        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        
        -- Stop positioning if we've filled the grid
        if row >= rows then break end
        
        -- Set card dimensions
        card.width = cardWidth
        card.height = cardHeight
        
        -- Calculate position (using the cardsAreaBounds coordinates)
        card.x = Scenes.cardsAreaBounds.x + horizontalSpacing + col * (cardWidth + horizontalSpacing)
        card.y = Scenes.cardsAreaBounds.y + verticalSpacing + row * (cardHeight + verticalSpacing + tabHeight)
    end
end

function Scenes.drawBulletinBoardTitle()
    -- Get title bounds
    local bounds = Scenes.boardTitleBounds
    
    -- Draw title with proper centering
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(28))
    
    -- Calculate text width for proper centering
    local titleText = "COMMUNITY BULLETIN BOARD"
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(titleText)
    
    -- Center text horizontally in the title area
    local textX = bounds.x + (bounds.width - textWidth) / 2
    
    -- Center text vertically in the title area
    local textHeight = font:getHeight()
    local textY = bounds.y + (bounds.height - textHeight) / 2
    
    -- Draw centered text
    love.graphics.print(titleText, textX, textY)
    
    -- Reset font
    love.graphics.setFont(love.graphics.getFont())
    
    -- Optional: Draw a decorative line under the title
    love.graphics.setColor(0.7, 0.6, 0.5)
    love.graphics.line(
        bounds.x + bounds.width * 0.1,
        bounds.y + bounds.height - 5,
        bounds.x + bounds.width * 0.9,
        bounds.y + bounds.height - 5
    )
end

function Scenes.drawBulletinBoard()
    -- Get bulletin board bounds
    local bounds = Scenes.bulletinBounds
    
    -- Draw bulletin board background
    love.graphics.setColor(0.9, 0.8, 0.7)
    love.graphics.rectangle("fill", bounds.x, bounds.y, bounds.width, bounds.height)
    love.graphics.setColor(0.6, 0.5, 0.4)
    love.graphics.rectangle("line", bounds.x, bounds.y, bounds.width, bounds.height)
    
    -- Add cork-board texture (optional)
    love.graphics.setColor(0.85, 0.75, 0.65, 0.3)
    for i = 0, bounds.width / 20 do
        for j = 0, bounds.height / 20 do
            love.graphics.rectangle("fill", bounds.x + i * 20, bounds.y + j * 20, 10, 10)
        end
    end
    
    -- Draw pushpins at corners
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.circle("fill", bounds.x + 15, bounds.y + 15, 5)
    love.graphics.circle("fill", bounds.x + bounds.width - 15, bounds.y + 15, 5)
    love.graphics.circle("fill", bounds.x + 15, bounds.y + bounds.height - 15, 5)
    love.graphics.circle("fill", bounds.x + bounds.width - 15, bounds.y + bounds.height - 15, 5)
    
    -- Draw the bulletin board title (as a separate component)
    Scenes.drawBulletinBoardTitle()
    
    -- Draw all cards in the bulletin board
    for _, card in ipairs(Scenes.bulletinCards) do
        card:render()
    end
end

function Scenes.drawEvent()
    love.graphics.print("Event View", 100, 100)
    -- Event view content would go here
end

function Scenes.drawCurrentScene(player)
    -- Reset color
    love.graphics.setColor(1, 1, 1)
    
    -- Draw the header with fixed height
    love.graphics.setColor(0.95, 0.95, 0.95)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), Scenes.headerHeight)
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), Scenes.headerHeight)
    
    -- Draw header content
    Header.draw(player, {x = 0, y = 0, width = love.graphics.getWidth(), height = Scenes.headerHeight})
    
    -- Then draw the current scene content
    love.graphics.setColor(1, 1, 1)
    Scenes.draw[Scenes.current]()
end

function Scenes.changeScene(sceneName)
    if Scenes.draw[sceneName] then
        Scenes.current = sceneName
        return true
    end
    return false
end

function Scenes.clearBulletinCards()
    Scenes.bulletinCards = {}
end

function Scenes.resize()
    Scenes.arrangeCards()
end

return Scenes 