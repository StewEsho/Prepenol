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
local bullets = require("bullets");
local player = require("ship");
physics.start();

local M = {};

M.class = class("Fireballer", enemyBase.BaseEnemy);
M.description = "Packing heat all day, any day."

function M.class:__init(_x, _y, newIndex, params)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 3, self.x, self.y, 132, 187.5, math.random(0, 359), "img/sprites/fire.jpg", "Fireballer", description, 0, newIndex, params);

  self.sprite.maxSpeed = 800;
  self.sprite.acceleration = 0.5;
  self.sprite.damage = 75
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(30, 50)/100;
  self.sprite.radarColour = {1, 0.4, 0.2};

  self.bullets = bullets.newInstance(self.sprite, "img/sprites/bullet-fire.png", self.sprite.width / 2, self.sprite.height - 50, self.sprite.maxSpeed * 125);
  self.bulletCooldown = 0;
end

--Add enemytype specific run routines here
function M.class:runCoroutine()
  if(self.sprite.isChasingPlayer == true and self.bulletCooldown<=0) then
    self.bulletCooldown = 10;
    self.bullets:shoot(1);
  end
  self.bullets:removeBullets(player:getDisplayObject());
  --print("FIREBALLER:" .. table.getn(self.bullets:getTable()))

  self.bulletCooldown = self.bulletCooldown - 1;
end

return M;
