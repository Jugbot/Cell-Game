
math.gratio = (1 + math.sqrt(5))/2
function math.nthgratio(itr, number)
  number = number or math.gratio
  if itr == 0 then return number end
  return math.nthgratio(itr-1, number * math.gratio)
end

function table.clone(org)
  return {unpack(org)}
end

function requiredir(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for i=1, #files do
    local file = files[i]
    local name = file:gmatch('[^%.]+')()
    local fullPath = dir .. '.' .. name
    -- print("include "..fullPath)
    if love.filesystem.getInfo(dir..'/'..file, "file") then
      require(fullPath)
    end
  end
end
