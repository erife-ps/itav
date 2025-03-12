local scene_manager = {
    current = nil,
    scenes = {},
    header = nil
}

-- Set header component (always visible)
function scene_manager.setHeader(header)
    scene_manager.header = header
end

-- Add a new scene
function scene_manager.addScene(name, scene)
    scene_manager.scenes[name] = scene
    if not scene_manager.current then
        scene_manager.current = name
    end
end

-- Switch to a scene
function scene_manager.switchTo(name)
    if scene_manager.scenes[name] then
        scene_manager.current = name
        print("Switched to scene: " .. name)
        return true
    end
    return false
end

-- Update current scene
function scene_manager.update(dt)
    if scene_manager.header and scene_manager.header.update then
        scene_manager.header:update(dt)
    end
    
    local current = scene_manager.scenes[scene_manager.current]
    if current and current.update then
        current:update(dt)
    end
end

-- Draw current scene with header
function scene_manager.draw(width, height)
    -- Draw header in the top 100px
    if scene_manager.header then
        love.graphics.setColor(1, 1, 1)
        scene_manager.header:draw(0, 0, width, 100)
    end
    
    -- Draw current scene in the remaining space
    local current = scene_manager.scenes[scene_manager.current]
    if current then
        love.graphics.setColor(1, 1, 1)
        current:draw(0, 100, width, height - 100)
    end
end

-- Handle resize events
function scene_manager.resize(width, height)
    if scene_manager.header and scene_manager.header.resize then
        scene_manager.header:resize(width, 100)
    end
    
    for _, scene in pairs(scene_manager.scenes) do
        if scene.resize then
            scene:resize(width, height - 100)
        end
    end
end

return scene_manager 