-- Enable printing to console
io.stdout:setvbuf("no")

-- Global variables
local scale = 1
local hot_swap = require("hot_swap")
local renderer = require("renderer")
local content = require("content")
local colors = require("colors")

-- Main entry point for LÖVE application
local scene_manager = require("scene_manager")
local header = require("header")
local bulletin_scene = require("bulletin_scene")
local event_scene = require("event_scene")

function love.load()
    -- Set window properties
    love.window.setTitle("Community Hub")
    love.window.setMode(800, 600, {
        resizable = true,
        minwidth = 640,
        minheight = 480
    })
    
    -- Initialize components
    header:init()
    bulletin_scene:init()
    event_scene:init()
    
    -- Set up scene manager
    scene_manager.setHeader(header)
    scene_manager.addScene("bulletin", bulletin_scene)
    scene_manager.addScene("event", event_scene)
    scene_manager.switchTo("bulletin")
    
    -- Initial layout based on window size
    local width, height = love.graphics.getDimensions()
    scene_manager.resize(width, height)
    
    -- Track modules for hot swapping
    hot_swap.track("flexbox", require("flexbox"))
    hot_swap.track("bulletin_scene", bulletin_scene)
    hot_swap.track("scene_manager", scene_manager)
    
    print("Application loaded successfully!")
end

function love.update(dt)
    -- Update current scene
    scene_manager.update(dt)
end

function love.draw()
    -- Get current dimensions
    local width, height = love.graphics.getDimensions()
    
    -- Draw the scene
    scene_manager.draw(width, height)
end

function love.resize(width, height)
    -- Handle window resize
    scene_manager.resize(width, height)
    print("Window resized to: " .. width .. "x" .. height)
end

function love.mousepressed(x, y, button)
    -- Pass mouse events to header for button handling
    if y < 100 then
        header:mousepressed(x, y, button)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "b" then
        scene_manager.switchTo("bulletin")
    elseif key == "e" then
        scene_manager.switchTo("event")
    end
end 