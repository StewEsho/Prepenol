--------------------------------------------------------------------------------
--
-- Base Class for all powerups
--
--------------------------------------------------------------------------------
---------------------------------- POWERUP.LUA ---------------------------------
--------------------------------------------------------------------------------

local class = require("classy");
local scene = require("scene");
local physics = require("physics");

local powerups = {};
powerups.class = class("Powerup");

function powerups.class:__init(params)
  self.x = params.x or math.random(-1000, 1000);
  self.y = params.y or math.random(-1000, 1000);
  self.width = params.width or 256;
  self.height = params.height or 256;
  self.image = params.image or "";
  self.sprite = display.newImageRect(self.image, self.width, self.height);
  self.sprite.x, self.sprite.y = self.x, self.y;
  while (self.rotationFactor == nil or self.rotationFactor == 0) do
    self.rotationFactor = math.random(-360, 360)/120
  end
  scene:addObjectToScene(self.sprite, 1);
end

function powerups.class:run(_index)
  self.sprite.rotation = self.sprite.rotation + self.rotationFactor;
end

return powerups;
