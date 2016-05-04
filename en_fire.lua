--------------------------------------------------------------------------------
--
-- ENEMY: Fireball
--
-- en_fire.lua
--
------------------------------- Private Fields ---------------------------------
local enemyBase = require("baseEnemy");
local class = require("classy");
local physics = require("physics");
physics.start();

local M = {};

M.class = class("Fireballer", enemyBase.BaseEnemy);
M.description = "These guys are bringing and packing the heat."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 3, self.x, self.y, 175, 250, math.random(0, 359), "img/sprites/fire.jpg", "Fireballer", description, 1);

  self.sprite.maxSpeed = 800;
  self.sprite.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(12, 17)
end

function M.class:runCoroutine()
  --Add enemytype specific run routines here
end

return M;
