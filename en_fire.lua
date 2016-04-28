--------------------------------------------------------------------------------
--
-- ENEMY: Fireball
--
-- en_fire.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy")
local class = require("classy");

local M = {};

M.class = class("Fireballer", enemyBase.BaseEnemy);
M.description = "These guys are bringing and packing the heat."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 3, self.x, self.y, 100, 200, math.random(0, 359), "img/sprites/fire.jpg", "Fireballer", description, 1);

  self.maxSpeed = 40;
  self.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(12, 17);

  physics.addBody(self.sprite, "kinematic");
end

return M;
