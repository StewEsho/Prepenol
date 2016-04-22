--------------------------------------------------------------------------------
--
-- Contains all logic for bullets and their interaction with other entities
--
-- bullets.lua
--
------------------------------- Private Fields ---------------------------------
local physics = require("physics");
local scene = require("scene");
local enemy = require("enemies");

local bullets = {};
local bullets_mt = {__index = bullets}; --metatable

local bulletNum;
local bullet = {};
local numberOfBulletsToRemove;
local baseObject;

--Constructor
function bullets.new(_object)
  local newBullets = {
  }

  baseObject = _object; --the object that the bullets originate from, e.g. the ship

  bulletNum = 0;
  bullet = {};
  numberOfBulletsToRemove = 0;

  return setmetatable(newBullets, bullets_mt);
end

------------------------------ Public Functions --------------------------------

function bullets:init()
  physics.start();
  physics.setGravity( 0, 0 );
end

function bullets:getTable()
  return bullet;
end

function bullets:getX(_index)
  if (table.getn(bullet) >= 1) then
    return bullet[_index].x;
  else
    return -99999
  end
end

function bullets:getY(_index)
  if (table.getn(bullet) >= 1) then
    return bullet[_index].y;
  else
    return -99999
  end
end

local function onBulletCollision( self, event )
  --Runs when the bullet hits something
  if ( event.phase == "began") then
    self:removeSelf();
    if ( event.other.name ~= "Bullet") then
      event.other.health = event.other.health - 20 + event.other.armour;
      event.other.isShaking = true;
    end
  end
end

function bullets:shoot()
  bulletNum = table.getn(bullet);
  bullet[bulletNum] = display.newRect(baseObject.x, baseObject.y, baseObject.width/8, baseObject.height/3);
  bullet[bulletNum]:setFillColor(0.6, 0.8, 1);
  bullet[bulletNum].rotation = baseObject.rotation;
  bullet[bulletNum].name = "Bullet";
  scene:addObjectToScene(bullet[bulletNum], 1);

  physics.addBody(bullet[bulletNum], "dynamic");
  bullet[bulletNum].isBullet = true;
  bullet[bulletNum]:setLinearVelocity(math.sin(math.rad(bullet[bulletNum].rotation))*50000, -math.cos(math.rad(bullet[bulletNum].rotation))*50000);
  bullet[bulletNum].collision = onBulletCollision;
  bullet[bulletNum]:addEventListener("collision", bullet[bulletNum]);
end

function bullets:removeBullets()

  for i = 1, table.getn(bullet) do
    if (bullet[i] == nil) then break
    elseif (bullet[i].x > (baseObject.x + 2000)
    or bullet[i].x < (baseObject.x - 2000)
    or bullet[i].y > (baseObject.y + 1000)
    or bullet[i].y < (baseObject.y - 1000)) then
      bullet[j]:removeSelf();
      table.remove(bullet, j);
    end
  end
end

return bullets;
