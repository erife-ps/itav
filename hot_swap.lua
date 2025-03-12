local hot_swap = {
    modules = {},
    last_updated = {}
}

-- Add a module to be hot swapped
function hot_swap.track(name, module_table)
    hot_swap.modules[name] = module_table
    local file_info = love.filesystem.getInfo(name .. ".lua")
    if file_info then
        hot_swap.last_updated[name] = file_info.modtime
        print("Tracking module for hot swap: " .. name)
    else
        print("Warning: Could not find module file: " .. name .. ".lua")
    end
end

-- Check for file changes and reload modules
function hot_swap.update()
    for name, module_table in pairs(hot_swap.modules) do
        local file_info = love.filesystem.getInfo(name .. ".lua")
        if file_info and file_info.modtime ~= hot_swap.last_updated[name] then
            print("Hot swapping module: " .. name)
            
            -- Store any existing module values that we want to preserve
            local preserved_values = {}
            for k, v in pairs(module_table) do
                if type(v) ~= "function" then  -- Preserve non-function values
                    preserved_values[k] = v
                end
            end
            
            -- Load the file content
            local content, size = love.filesystem.read(name .. ".lua")
            if not content then
                print("Error: Could not read " .. name .. ".lua")
                return
            end
            
            -- Create a new environment for the module
            local env = {}
            -- Copy the global environment
            for k, v in pairs(_G) do
                env[k] = v
            end
            
            -- Set up a new require function that will return our tracked modules
            env.require = function(mod)
                if hot_swap.modules[mod] then
                    return hot_swap.modules[mod]
                else
                    return _G.require(mod)
                end
            end
            
            -- Set up module environment with metatable
            local mt = {__index = _G}
            setmetatable(env, mt)
            
            -- Load the module with the new environment
            local fn, err = load(content, name .. ".lua", "bt", env)
            if not fn then
                print("Error loading module: " .. tostring(err))
                return
            end
            
            -- Execute the module
            local success, result = pcall(fn)
            if not success then
                print("Error executing module: " .. tostring(result))
                return
            end
            
            -- If module returned a table, update our module
            if type(result) == "table" then
                -- Replace functions in the original module table
                for k, v in pairs(result) do
                    module_table[k] = v
                end
                
                -- Restore preserved values that weren't explicitly set in the new module
                for k, v in pairs(preserved_values) do
                    if module_table[k] == nil then
                        module_table[k] = v
                    end
                end
                
                -- Update modification time
                hot_swap.last_updated[name] = file_info.modtime
                print("Module " .. name .. " successfully hot swapped")
            else
                print("Error: Module did not return a table")
            end
        end
    end
end

-- Force reload of a specific module or all modules
function hot_swap.force_reload(name)
    if name then
        if hot_swap.modules[name] then
            hot_swap.last_updated[name] = 0
            print("Forcing reload of module: " .. name)
        else
            print("Module not found: " .. name)
        end
    else
        -- Force reload all modules
        for module_name, _ in pairs(hot_swap.modules) do
            hot_swap.last_updated[module_name] = 0
        end
        print("Forcing reload of all modules")
    end
end

return hot_swap 