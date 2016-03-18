--------------------------------------------------------------------------------
--
-- Pages of Ram
--
-- By Stew Esho
--
-- main.lua
--
--------------------------------------------------------------------------------
local gameloop = require("gameloop")

gameloop.new();

gameloop:init();

local function gameLoop()
  gameloop:run();
end

Runtime:addEventListener("enterFrame", gameLoop);
