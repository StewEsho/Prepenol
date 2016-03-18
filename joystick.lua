--------------------------------------------------------------------------------
--
-- Code behind the joystick code; Used for moving the player
--
-- joystick.lua
--
------------------------------- Private Fields ---------------------------------

local ship = require ("ship");

local joystick = {};
local joystick_mt = {}; --metatable

--[[
  angle
    - Angle of the joystick_mt
    - Range = { 0 - 359 }
    - Up is 0 degrees

  magnitude
    - How far from the center the joystick has moved.
    - Higher magnitude == higher speed
    - Range = {0 - 1}

  x, y
    - Stores coordinates of joystick *center*

  background
    - Display object for back of joystick

  stick
    - Display object for movable joystick
]]--

local angle;
local magnitude;
local background;
local stick;
local x, y;
local angleText;
local magText;

function joystick.new(_x, _y)
  local newJoystick = {
    x = _x;
    y = _y;

    angle = 0;
    magnitude = 0;
    background = nil;
    stick = nil;
  }

  angle = 0;

  background = display.newCircle(_x, _y, display.contentWidth/8);
  background:setFillColor(0.7, 0.7, 0.7)
  stick = display.newCircle(_x, _y, display.contentWidth/20);
  stick:setFillColor(0.4, 1, 0.6, 0.3);

  angleText = display.newText(angle, 500, 300, "Arial", 72);
  magText = display.newText("0", 500, 500, "Arial", 72)

  return setmetatable(newJoystick, joystick_mt);
end

----------------------------- Private Functions --------------------------------

local function onStickHold(event)
  if (event.phase == "began") then
    display.getCurrentStage():setFocus( self, event.id )
    isStickFocus = true
  elseif (isStickFocus == true) then
    if (event.phase == "moved") then
      stick.x = event.x;
      stick.y = event.y;
    elseif (event.phase == "ended" or event.phase == "cancelled") then
      display.getCurrentStage():setFocus( self, nil );
      isStickFocus = false
      stick.x = background.x;
      stick.y = background.y;
    end
  end
  angleText.text = joystick:getAngle();
  magText.text = joystick:getMagnitude();

  ship:translate(joystick:getMagnitude() * math.sin(math.rad(joystick:getAngle())) * ship:getSpeed(), -joystick:getMagnitude() * math.cos(math.rad(joystick:getAngle())) * ship:getSpeed());
end

------------------------------ Public Functions --------------------------------

--[[

  run
    - Runs in the game loop
    - gets user input, and returns angle and magnitude values
]]--

--Getters
function joystick:getAngle()
  if (stick.x - background.x < 0) then
    angle = math.deg(math.atan((stick.y - background.y)/(stick.x - background.x)))+270;
  elseif (stick.x - background.x > 0) then
    angle = math.deg(math.atan((stick.y - background.y)/(stick.x - background.x)))+90;
  elseif (stick.x - background.x == 0) then
    angle = 0;
  end
  return angle;
end

function joystick:getMagnitude()
  magnitude = math.sqrt(math.pow((stick.x-background.x),2) + math.pow((stick.y-background.y),2)) / (display.contentWidth/8)
  return magnitude;
end

function joystick:run()
  stick:addEventListener("touch", onStickHold);
end

return joystick;
