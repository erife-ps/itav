local renderer = {}

-- Dependencies
local content = require("content")
local colors = require("colors")

-- Store fonts globally to preserve across hot swaps
if not _G.renderer_fonts then
    _G.renderer_fonts = {
        title = nil,
        help = nil
    }
end
local fonts = _G.renderer_fonts

-- Initialize the renderer
function renderer.init()
    -- Only initialize fonts if they don't exist yet
    if not fonts.title then
        fonts.title = love.graphics.newFont(32)
    end
    if not fonts.help then
        fonts.help = love.graphics.newFont(16)
    end
    print("Renderer initialized")
end

-- Draw the main scene
function renderer.draw(windowWidth, windowHeight, scale)
    -- Clear screen with background color
    love.graphics.setBackgroundColor(colors.getBackgroundColor())
    
    -- Draw the main title
    renderer.drawTitle(windowWidth, windowHeight, scale)
    
    -- Draw help text at the bottom
    renderer.drawHelpText(windowWidth, windowHeight)
    
    -- Draw any additional elements
    renderer.drawExtras(windowWidth, windowHeight, scale)
end

-- Draw the main title
function renderer.drawTitle(windowWidth, windowHeight, scale)
    -- Ensure fonts exist before using them
    if not fonts.title then
        renderer.init()  -- Re-initialize if fonts are missing
    end
    
    love.graphics.setFont(fonts.title)
    love.graphics.setColor(1, 1, 1)
    
    local text = content.getText()
    local textWidth = fonts.title:getWidth(text)
    local textHeight = fonts.title:getHeight()
    
    love.graphics.print(
        text,
        windowWidth / 2 - textWidth / 2 * scale,
        windowHeight / 2 - textHeight / 2 * scale,
        0,  -- rotation
        scale, scale  -- scale x, scale y
    )
end

-- Draw help text
function renderer.drawHelpText(windowWidth, windowHeight)
    -- Ensure fonts exist before using them
    if not fonts.help then
        renderer.init()  -- Re-initialize if fonts are missing
    end
    
    love.graphics.setFont(fonts.help)
    love.graphics.setColor(0.8, 0.8, 0.8)
    
    local helpText = content.getHelpText()
    for i, line in ipairs(helpText) do
        love.graphics.print(line, 20, windowHeight - (40 - (i-1) * 20))
    end
end

-- Draw additional elements (can be modified for hot swapping)
function renderer.drawExtras(windowWidth, windowHeight, scale)
    -- Add a decorative element that can be modified during hot swapping
    love.graphics.setColor(0.9, 0.9, 0.8, 0.5)
    love.graphics.circle("line", windowWidth / 2, windowHeight / 4, 50 * scale)

    -- Add a rectangle frame
    love.graphics.setColor(0.7, 0.7, 0.9, 0.3)
    love.graphics.rectangle("fill", 
        windowWidth / 2 - 150 * scale, 
        windowHeight / 2 - 100 * scale,
        300 * scale, 
        200 * scale
    )
    
    -- Add another rectangle (with proper parameters)
    love.graphics.setColor(0.9, 0.9, 0.3, 0.5)
    love.graphics.rectangle("fill", 
        windowWidth / 4,
        windowHeight * 3/4,
        100 * scale,
        50 * scale
    )
end

return renderer 