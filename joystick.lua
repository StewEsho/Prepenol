--------------------------------------------------------------------------------
--
-- Code behind the joystick code; Used for moving the player
--
-- joystick.lua
--
------------------------------- Private Fields ---------------------------------
local class = require("classy")

local joystick = {};
joystick.newInstance = class("Joystick");

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

function joystick.newInstance:__init(_x, _y)

  self.x = _x;
  self.y = _y;

  self.angle = 0;
  self.magnitude = 0;

  self.background = display.newCircle(_x, _y, display.contentWidth/8);
  self.background.x = _x;
  self.background.y = _y;
  self.background:setFillColor(0.8, 0.8, 0.8, 0.2);

  self.background.stick = display.newCircle(_x, _y, display.contentWidth/20);
  self.background.stick:setFillColor(0.6, 1, 0.6, 1);
  self.background.stick.defaultX = self.background.x;
  self.background.stick.defaultY = self.background.y;
  self.deltaRadius = (3 * display.contentWidth)/40;

  self.angleText = display.newText("", 500, 300, "Arial", 72);
  self.magText = display.newText("", 500, 500, "Arial", 72);

  --initalizes controls
  self.background.touch = self.snapStick;
  self.background.onStickHold = self.onStickHold;
  self.background:addEventListener("touch", self.background);
end

----------------------------- Private Functions --------------------------------

function joystick.newInstance:onStickHold(event)
  if (isStickFocus == true) then
      self.x = event.x;
      self.y = event.y;
      xMag = 0;
      yMag = 0;
    if (event.phase == "ended" or event.phase == "cancelled") then
      display.getCurrentStage():setFocus( self, nil );
      isStickFocus = false;
      self.x = self.defaultX;
      self.y = self.defaultY;
      self:removeEventListener("touch", onStickHold);
    end
  end
end

function joystick.newInstance:snapStick(event)
  if (event.phase == "began") then
    event.target.stick.x = event.x;
    event.target.stick.y = event.y;
    event.target.stick.touch = event.target.onStickHold;
    event.target.stick:addEventListener("touch", event.target.stick);
    display.getCurrentStage():setFocus( event.target.stick, event.id )
    isStickFocus = true;
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

  init
    - runs once to initiate the joystick
    - adds the event listener that allows the joystick to move around

  isInUse
    - returns true if the joystick is being used.
    - returns false if joystick magnitude is 0.

  debug
    - Runs in the game loop
    - prints out information such as angles and magnitude
    - used only for debugging.

]]--

function joystick.newInstance:getStickDisplayObject()
  return self.background.stick; --returns the actual DISPLAY OBJECT of the stick
end

function joystick.newInstance:getBackgroundDisplayObject()
  return self.background; --returns the background display object, behind the stick
end

function joystick.newInstance:getAngle()
  if (self.background.stick.x - self.background.x < 0) then
    self.angle = math.deg(math.atan((self.background.stick.y - self.background.y)/(self.background.stick.x - self.background.x))) + 270;
  elseif (self.background.stick.x - self.background.x > 0) then
    self.angle = math.deg(math.atan((self.background.stick.y - self.background.y)/(self.background.stick.x - self.background.x))) + 90;
  elseif (self.background.stick.x - self.background.x == 0) then
    if (self.background.stick.y - self.background.y > 0) then
      self.angle = 180;
    else
      self.angle = 0;
    end
  end
  return self.angle;
end

function joystick.newInstance:getMagnitude()
  self.magnitude = math.sqrt(math.pow((self.background.stick.x-self.background.x),2) + math.pow((self.background.stick.y-self.background.y),2)) / (self.background.width/2)
  if self.magnitude > 1 then
    return 1;
  else
    return self.magnitude;
  end
end

function joystick.newInstance:isInUse()
  if (self:getMagnitude() == 0) then
    return false;
  else
    return true;
  end
end

function joystick.newInstance:debug()
  self.angleText.text = self:getAngle();
  self.magText.text = self:getMagnitude();
end

return joystick;
