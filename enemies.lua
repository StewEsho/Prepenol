--------------------------------------------------------------------------------
--
-- Centralized module for spawning, tracking, and handling enemies
-- Contains a table, which itself contains more table_insert
-- Each subtable contains all instances of enemies.
-- This way, every enemy can be accessed through this one module
--
-- enemies.lua
--
------------------------------- Private Fields ---------------------------------
local scene = require("scene");

local skeleton = require("en_skeleton");

enemies = {};
enemies_mt = {__index = enemies}; --metatable

local enemyList;
local moduleList;
local skeletonList;

--------------------------------- Constructor ----------------------------------

function enemies.new()
  local newEnemies = {
  }
  setmetatable(newEnemies, enemies_mt);

  skeletonList = {}; --List of all Skeleton enemies
  --List of all enemies
  enemyList = {
    --[[
    /////INDEX of ENEMIES/////

    [1] = skeletonList

    ]]
    skeletonList
  }

  --List of all clases; corresponds with order in enemyList
  --Used to spawn instances of these classes
  moduleList = {
    skeleton
  }

  return newEnemies;
end

------------------------------ Public Functions --------------------------------

--[[
  spawn(_index, _x, _y)
    - spawns a new enemy, and adds it to the list
    - _index determines which type of enemy to spawn
    - does NOT add the oobject to the scene
    @return the instance of the enemy;

  get(_index1, _index2)
    - retrieves the specificed enemy instance;
    - _index1 is the type of enemy, and _index2 specifes which in particular
    - retrieves newest instance if _index2 is not specified
]]

function enemies:spawn(_index, _x, _y)
  table.insert(enemyList[_index], moduleList[_index].new(_x, _y, table.getn(enemyList[_index])));
  return enemyList[_index][table.getn(enemyList[_index])];
end

function enemies:get(_index1, _index2)
  if (_index2 == nil) then
    return enemyList[_index1][table.getn(enemyList[_index1])];
  else
    return enemyList[_index1][_index2];
  end
end

return enemies;
