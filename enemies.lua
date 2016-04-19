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

  skeletonList = {};

  --List of all modules; corresponds with order in enemyList
  moduleList = {
    skeleton
  }
  --List of all enemies

  enemyList = {
    --[[
    /////INDEX of ENEMIES/////

    [1] = skeletonList

    ]]
    skeletonList
  }

  return newEnemies;
end

------------------------------ Public Functions --------------------------------

--[[
  spawn(_index, _x, _y)
]]

function enemies:spawn(_index, _x, _y)
  table.insert(enemyList[_index], moduleList[_index].new(_x, _y));
  return enemyList[_index][table.getn(enemyList[_index])]
end

function enemies:getDisplayObject(_index1, _index2)
  enemyList[_index1][_index2]:getDisplayObject();
end

return enemies;
