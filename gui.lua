--------------------------------------------------------------------------------
--
-- Stores all elements of the GUI and/or the HUD
--
--------------------------------------------------------------------------------
-------------------------------------GUI.LUA------------------------------------
--------------------------------------------------------------------------------
local class = require("classy");
local radar = require("radar");
local stick = require("joystick");
local button = require("button");

local gui = {};

gui.class = class("GUI");

function gui.class:__init(params)
  --Display Groups
  self.groupGUI = display.newGroup();

  --GUI
  self.radar = radar.class(params.player);
  self.stick = stick.new(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  self.button = button.new(display.contentWidth,  --x
                           display.contentHeight,   --y
                           display.contentHeight/2, display.contentHeight/3,  --width, height
                           false,     --toggleable?
                           0.6,      --red
                           1,      --green
                           0.6,     --blue
                           0.6,     --alpha
                           "fire");  --tag)
  self.gameOverBackground = display.newRect(display.contentWidth/2, display.contentHeight/2, display.contentWidth, display.contentHeight);
  self.gameOverBackground:setFillColor(0.8, 0.1, 0.2);
  self.gameOverBackground.alpha = 1;
  self.gameOverText = display.newText( "gaem is ded", display.contentWidth/2, display.contentHeight/2, "font/LeagueSpartan-Bold.ttf", 212);

  self.gameOverGUI = display.newGroup()
  self.gameOverGUI:insert(self.gameOverBackground);
  self.gameOverGUI:insert(self.gameOverText);

  self.stickGUI = display.newGroup();
  self.stickGUI:insert(self.stick:getBackgroundDisplayObject());
  self.stickGUI:insert(self.stick:getStickDisplayObject());

  self.radarGUI = display.newGroup();
  self.radarGUI:insert(self.radar:getRadarObject());
  self.radarGUI:insert(self.radar:getRadarTriangle());

  self.miscGUI = display.newGroup();

  self.groupGUI:insert(self.miscGUI);
  self.groupGUI:insert(self.button:getDisplayObject());
  self.groupGUI:insert(self.radarGUI);
  self.groupGUI:insert(self.stickGUI);
  self.groupGUI:insert(self.gameOverGUI);

  self.groupGUI[5].alpha = 0.9;

end

function gui.class:initControls()
  self.stick:init();
  self.button:init();
end

function gui.class:getJoystick()
  return self.stick;
end

function gui.class:getButton()
  return self.button;
end

function gui.class:getRadar()
  return self.radar;
end

function gui.class:run()
  -- there seems to be nothing here.
end

return gui;
