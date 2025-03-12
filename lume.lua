--
-- lume (minimal subset for lurker)
--
-- Copyright (c) 2018 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

local lume = { _version = "2.3.0" }

function lume.isfile(filename)
  local info = love.filesystem.getInfo(filename)
  return info and info.type == "file"
end

return lume 