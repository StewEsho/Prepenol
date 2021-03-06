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

function M.class:__init(_x, _y, newIndex, params)
  self.x = _x;
  self.y = _y;
  self.autokill = params.autokill or true
  enemyBase.BaseEnemy.__init(self, 1, self.x, self.y, 120, 150, 0, "img/sprites/skel.png", "Skeleship", description, 0, newIndex, params);

  self.sprite.maxSpeed = 1800;
  self.sprite.acceleration = 1;
  self.sprite.healthBar.maxHealth = 30;
  self.sprite.healthBar.health = 30;
  self.sprite.healthBar.armour = math.random(25, 35)/100;
  self.sprite.radarColour = {0.8, 0.8, 0.8};
  self.sprite.damage = 18;
  self.turnRate = 6

end

function M.class:runCoroutine()
  --Add enemytype specific run routines here
end

return M;
