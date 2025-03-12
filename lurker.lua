--
-- lurker
--
-- Copyright (c) 2018 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

-- Assumes lume is in the same directory as this file
local lume = require((...):gsub("[^/.\\]+$", "lume"))

local lurker = { _version = "1.0.1" }

-- Set a default path
lurker.path = "."  -- Default to current directory

local dir = love.filesystem.getSource()
local isWindows = love.system.getOS() == "Windows"


local function normalizePath(path)
  path = path:gsub("\\", "/")
  return path
end


local function adaptive_throttle(t)
  -- Adaptive throttle scheme:
  -- Start with no throttle and build up to the throttle progressively
  if t <= 0.005 then
    return 0
  elseif t < 0.1 then
    -- Initially linear, but slower
    return (t - 0.005) / 2
  else
    -- Eventually matches input with a maximum of 0.05s throttle
    return math.min(t / 2, 0.05)
  end
end


local function getId(file)
  return normalizePath(file)
end


function lurker.fileExists(file)
  return love.filesystem.getInfo(file) ~= nil
end


function lurker.scan()
  local files = {}
  local fileList = love.filesystem.getDirectoryItems(lurker.path)
  for _, file in ipairs(fileList) do
    if file:match("%.lua$") and
       file ~= "main.lua" and
       file ~= "conf.lua" and
       file ~= "lurker.lua" and
       file ~= "lume.lua" then
      files[getId(file)] = love.filesystem.getInfo(
        lurker.path .. "/" .. file).modtime
    end
  end
  return files
end


function lurker.modifiedFiles(files, previous)
  if not previous then return {} end
  local modified = {}
  for id, mtime in pairs(files) do
    if previous[id] ~= mtime then
      table.insert(modified, id)
    end
  end
  return modified
end


function lurker.reload(file)
  if lurker.preswap then lurker.preswap(file) end
  local success, err = pcall(love.filesystem.load, file)
  if success then
    success, err = pcall(success)
  end
  if lurker.postswap then lurker.postswap(file) end
  if not success then
    print("Error: " .. err)
  end
  return success
end


function lurker.update(dt)
  lurker.dt = lurker.dt + dt
  if lurker.dt > lurker.interval then
    lurker.dt = lurker.dt - lurker.interval
    local current = lurker.scan()
    local modified = lurker.modifiedFiles(current, lurker.last)
    for _, file in ipairs(modified) do
      lurker.reload(file)
    end
    lurker.last = current
  end
end


function lurker.init()
  lurker.timer = 0
  lurker.dt = 0
  lurker.last = lurker.scan()
  lurker.interval = .5
end


function lurker.setOptions(opts)
  for k, v in pairs(opts) do
    lurker[k] = v
  end
end


lurker.init()
return lurker 