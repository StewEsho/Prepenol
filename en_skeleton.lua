--------------------------------------------------------------------------------
--
-- ENEMY: Skeleship
--
-- en_skeleton.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy")
local class = require("classy");

local M = {};

M.class = class("Skeleship", enemyBase.BaseEnemy);
M.description = "Fast and lightweight, Skeleships will weave through the brightest stars for their bounty."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 1, self.x, self.y, 160, 200, 0, "img/sprites/skel.jpg", "Skeleship", description, 1);

  self.maxSpeed = 42;
  self.acceleration = 1;
  self.sprite.health = 30;
  self.sprite.armour = math.random(10, 13);

  physics.addBody(self.sprite, "kinematic");
end

return M;
