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

function M.class:__init(_x, _y, newIndex, params)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 2, self.x, self.y, math.random(100, 500), math.random(100, 500), 45, "img/sprites/aqua.png", "Aquae", description, 0, newIndex, params);

  self.sprite.maxSpeed = 200;
  self.sprite.acceleration = 0.25;
  self.sprite.healthBar.maxHealth = 55;
  self.sprite.healthBar.health = self.sprite.healthBar.maxHealth;
  self.sprite.healthBar.armour = (self.sprite.width + self.sprite.height)/2020; --armour can never be 100% resistance
  self.sprite.damage = math.random(5, 12);
  self.sprite.radarColour = {0, 0.8, 1};
end

function M.class:runCoroutine()
  --Add enemytype specific run routines here
end

return M;
