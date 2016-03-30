--------------------------------------------------------------------------------
--
-- Code behind the joystick code; Used for moving the player
--
-- joystick.lua
--
------------------------------- Private Fields ---------------------------------

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
local xMag, yMag;
local background;
local stick;
local deltaRadius;
local x, y;

local angleText;
local magText;
local xMagText;
local yMagText;

function joystick.new(_x, _y)
  local newJoystick = {
    x = _x;
    y = _y;

    angle = 0;
    magnitude = 0;
    background = nil;
    stick = nil;
  }

  angle = 0

  background = display.newCircle(_x, _y, display.contentWidth/8);
  background:setFillColor(0.7, 0.7, 0.7)
  stick = display.newCircle(_x, _y, display.contentWidth/20);
  stick:setFillColor(0.4, 1, 0.6, 0.3);
  deltaRadius = (3 * display.contentWidth)/40;

  angleText = display.newText(angle, 500, 300, "Arial", 72);
  magText = display.newText("0", 500, 500, "Arial", 72);
  xMagText = display.newText("0", 1200, 300, "Arial", 72);
  yMagText = display.newText("0", 1200, 500, "Arial", 72);

  return setmetatable(newJoystick, joystick_mt);
end

----------------------------- Private Functions --------------------------------

local function onStickHold(event)
  if (event.phase == "began") then
    display.getCurrentStage():setFocus( self, event.id )
    isStickFocus = true;
  end
  if (isStickFocus == true) then
        stick.x = event.x;
        stick.y = event.y;
        xMag = 0;
        yMag = 0;
    if (event.phase == "ended" or event.phase == "cancelled") then
      display.getCurrentStage():setFocus( self, nil );
      isStickFocus = false;
      stick.x = background.x;
      stick.y = background.y;
    end
  end
end

------------------------------ Public Functions --------------------------------

--[[

  getAngle
    @return angle
    - returns the angle of the joystick
    - Measured in degrees. 0 is up

  getMagnitude
    @return magnitude
    - returns the magnitude of the joystick
    - ranges from 0 - 1
    - calculated using center of the joystick

  getStickX
    @return stick.x
    - gets the distance of the stick from the center only only in the x plane.
    - a magnitude of 1 does not always mean an xMagnitude of 1;

  getStickY
    @return stick.y
    - gets the distance of the stick from the center only in the y plane.
    - measured in pixels
    - NOT a magnitude

  init
    - runs once to initiate the joystick
    - adds the event listener that allows the joystick to move around

  debug
    - Runs in the game loop
    - prints out information such as angles and magnitude
    - used only for debugging.

]]--

function joystick:getAngle()
  if (stick.x - background.x < 0) then
    angle = math.deg(math.atan((stick.y - background.y)/(stick.x - background.x))) + 270;
  elseif (stick.x - background.x > 0) then
    angle = math.deg(math.atan((stick.y - background.y)/(stick.x - background.x))) + 90;
  elseif (stick.x - background.x == 0) then
    if (stick.y - background.y > 0) then
      angle = 180;
    else
      angle = 0;
    end
  end
  return angle;
end

function joystick:getMagnitude()
  magnitude = math.sqrt(math.pow((stick.x-background.x),2) + math.pow((stick.y-background.y),2)) / (background.width/2)
  if magnitude > 1 then
    return 1;
  else
    return magnitude;
  end
end

function joystick:getStickX()
  return stick.x;
end

function joystick:getStickY()
  return stick.y;
end

function joystick:init()
  stick:addEventListener("touch", onStickHold);
end

function joystick:debug()
  angleText.text = joystick:getAngle();
  magText.text = joystick:getMagnitude();
  xMagText.text = string.format("%.3f", joystick:getStickX());
  yMagText.text = string.format("%.3f", joystick:getStickY());
end

return joystick;
