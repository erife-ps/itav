-- Enable printing to console
io.stdout:setvbuf("no")

-- Global variables
local scale = 1
local hot_swap = require("hot_swap")
local renderer = require("renderer")
local content = require("content")
local colors = require("colors")

function love.load()
    -- Set up window properties
    love.window.setTitle("Hot Swappable Renderer Demo")
    love.window.setMode(800, 600, {
        resizable = true,
        minwidth = 400,
        minheight = 300
    })
    
    -- Initialize the renderer
    renderer.init()
    
    -- Track modules for hot swapping
    hot_swap.track("renderer", renderer)
    hot_swap.track("content", content)
    hot_swap.track("colors", colors)
    
    print("Application loaded successfully!")
end

function love.update(dt)
    -- Check for hot swappable modules
    hot_swap.update()
end

function love.draw()
    -- Calculate window dimensions for responsive layout
    local windowWidth, windowHeight = love.graphics.getDimensions()
    
    -- Scale based on window size
    local baseWidth = 800
    local baseHeight = 600
    scale = math.min(windowWidth / baseWidth, windowHeight / baseHeight)
    
    -- Use the renderer to draw everything
    renderer.draw(windowWidth, windowHeight, scale)
    
    -- Draw debug info
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Hot swapping enabled - edit renderer.lua, content.lua, or colors.lua", 10, 10)
end

function love.resize(w, h)
    print("Window resized to: " .. w .. "x" .. h)
    -- No explicit action needed as our draw function is responsive
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "r" then
        -- Force reload of all modules
        hot_swap.force_reload()
    end
end 