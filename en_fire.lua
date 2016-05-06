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
physics.start();

local M = {};

M.class = class("Fireballer", enemyBase.BaseEnemy);
M.description = "Packing heat all day, any day."

function M.class:__init(_x, _y)
  self.x = _x;
  self.y = _y;
  enemyBase.BaseEnemy.__init(self, 3, self.x, self.y, 175, 250, math.random(0, 359), "img/sprites/fire.jpg", "Fireballer", description, 0);

  self.sprite.maxSpeed = 800;
  self.sprite.acceleration = 0.5;
  self.sprite.healthBar.maxHealth = 25;
  self.sprite.healthBar.health = 25;
  self.sprite.healthBar.armour = math.random(30, 50)/100;

  self.bullets = bullets.newInstance(self.sprite, "img/sprites/bullet-fire.png", self.sprite.width / 4, self.sprite.height - 50, self.sprite.maxSpeed * 125);
  self.bulletCooldown = 0;
end

--Add enemytype specific run routines here
function M.class:runCoroutine()
  if(self.isChasingPlayer == true and self.bulletCooldown<=0) then
    self.bulletCooldown = 10;
    self.bullets:shoot(1);
  end
  self.bullets:removeBullets();
  --print("FIREBALLER:" .. table.getn(self.bullets:getTable()))

  self.bulletCooldown = self.bulletCooldown - 1;
end

return M;
