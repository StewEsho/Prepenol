--------------------------------------------------------------------------------
--
-- ENEMY: Aquae
--
-- en_aqua.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy")
local class = require("classy");

local M = {};

M.class = class("Aquae", enemyBase.BaseEnemy);
M.description = "Careful: Aquaes won't restrict themselves to one shape or size."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 2, self.x, self.y, math.random(100, 500), math.random(100, 500), "img/sprites/aqua.png", "Aquae", description, 1);

  self.speed = 0;
  self.maxSpeed = 25;
  self.acceleration = 0.25;
  self.sprite.health = 65;
  self.sprite.armour = math.random(12, 17);

  physics.addBody(self.sprite, "kinematic");
end

return M;
