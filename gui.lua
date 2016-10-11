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

  --[[  Stores the gameState
    0 = not initialized
    1 = main menu
    2 = gameplay (Gauntlet)
    3 = gameplay (101 Ships)
    4 = game over
    5 = resetting process
    6 = resetting process in preperation of the main menu
  ]]
  self.gameState = 1;

  ------------------------------------------------------------------------------
  ---------------------------- Gameplay GUI / HUD ------------------------------
  ------------------------------------------------------------------------------

  --Display Groups
  self.controlGroup = display.newGroup(); --[ * ] -- main group for the controls. contains all sub groups within
  self.miscGUI = display.newGroup();      --[ 1 ] -- Misc. GUI objects
  self.buttonGUI = display.newGroup();    --[ 2 ] -- Buttons
  self.radarGUI = display.newGroup();     --[ 3 ] -- Radar
  self.stickGUI = display.newGroup();     --[ 4 ] -- Joysticks
  self.gameOverGUI = display.newGroup();  --[ 5 ] -- Gameover Screens

  --adds the groups to the main group
  self.controlGroup:insert(self.miscGUI);
  self.controlGroup:insert(self.buttonGUI);
  self.controlGroup:insert(self.radarGUI);
  self.controlGroup:insert(self.stickGUI);
  self.controlGroup:insert(self.gameOverGUI);

  --Special settings for display groups
  self.controlGroup[5].alpha = 0;

  ------------------------------------------------------------------------------

  --GUI
  self.radar = radar.class(params.player);
  self.stick = stick.newInstance(1.125 * display.contentWidth/8, 6 * display.contentHeight / 8);
  self.button = button.newInstance({x      = display.contentWidth - display.contentHeight/4,  --x
                                   y       = display.contentHeight - display.contentHeight/6,   --y
                                   width   = display.contentHeight/2,
                                   height  = display.contentHeight/3,  --width, height
                                   r       = 0.6,      --red
                                   g       = 1,      --green
                                   b       = 0.6,     --blue
                                   a       = 0.6,     --alpha
                                   tag     = "fire"});  --tag)
  self.button:getDisplayObject().path.x1 = -40;
  self.button:getDisplayObject().path.y1 = -40;

  --101 Man Brawl Enemy Countdown
  self.brawlCounterGroup = display.newGroup();

  self.brawlEnemyCounterHeading = display.newText(self.brawlCounterGroup, "Targets Remaining:", display.contentWidth/1.7, display.contentHeight - 60, "font/LeagueSpartan-Bold.ttf", 56)
  self.brawlEnemyCounterHeading.anchorX = 1;
  self.brawlEnemyCounter = display.newText(self.brawlCounterGroup, "101", self.brawlEnemyCounterHeading.x + 20, self.brawlEnemyCounterHeading.y, "font/LeagueSpartan-Bold.ttf", 81)
  self.brawlEnemyCounter.anchorX = 0;
  self.brawlEnemyCounter:setFillColor(0.8, 0.2, 0.1);
  self.brawlCounterGroup.isVisible = false;

  --Gameover Background
  self.gameOverBackground = display.newRect(self.gameOverGUI, display.contentWidth/2, display.contentHeight/2, display.actualContentWidth, display.actualContentHeight);
  self.gameOverBackground:setFillColor(0.8, 0.2, 0.1);
  self.gameOverBackground.super = self;

  self.gameOverText = display.newText(self.gameOverGUI, "gg", display.contentWidth/2, display.contentHeight/2, "font/LeagueSpartan-Bold.ttf", 212);

  self.menuButtonGroup = display.newGroup();
  self.menuButtonGroup.alpha = 0;

  self.menuButton = display.newRect(self.menuButtonGroup, display.contentWidth/3, display.contentHeight-250, 590, 115);
  self.menuButton.path.x1 = 30;
  self.menuButton.path.x4 = 30;
  self.menuButton:setFillColor(0.15, .55, .83)
  self.menuButton.super = self;
  self.menuButton.touch = self.returnToMenu;
  self.menuButton:addEventListener("touch", self.menuButton);

  self.restartButtonGroup = display.newGroup();
  self.restartButtonGroup.alpha = 0;

  self.restartButton = display.newRect(self.restartButtonGroup, 2*display.contentWidth/3, display.contentHeight-250, 590, 115);
  self.restartButton.path.x1 = 30;
  self.restartButton.path.x4 = 30;
  self.restartButton:setFillColor(.83, .83, .36)
  self.restartButton.super = self;
  self.restartButton.touch = self.restartGame;
  self.restartButton:addEventListener("touch", self.restartButton);

  ------------------------------------------------------------------------------

  --inserts everything into correct display groups

  self.stickGUI:insert(self.stick:getBackgroundDisplayObject());
  self.stickGUI:insert(self.stick:getStickDisplayObject());

  self.buttonGUI:insert(self.button:getDisplayObject());

  self.radarGUI:insert(self.radar:getRadarObject());
  self.radarGUI:insert(self.radar:getRadarTriangle());
  self.radarGUI:insert(self.radar:getDots());

  ------------------------------------------------------------------------------

  self.miscTable = {};      --[ 1 ] -- Misc. GUI objects
  self.buttonTable = {};    --[ 2 ] -- Buttons
  self.radarTable = {};     --[ 3 ] -- Radar
  self.stickTable = {};     --[ 4 ] -- Joysticks
  self.gameOverTable = {};  --[ 5 ] -- Gameover Screens
  self.gameplayHUDTable = {
    self.miscTable,
    self.buttonTable,
    self.radarTable,
    self.stickTable,
    self.gameOverTable
  }

  ----------

  table.insert(self.gameOverTable, self.gameOverBackground);
  table.insert(self.gameOverTable, self.gameOverText);

  table.insert(self.stickTable, self.stick);

  table.insert(self.buttonTable, self.button);

  table.insert(self.radarTable, self.radar);

  ------------------------------------------------------------------------------
  ---------------------------- Main Menu GUI / HUD -----------------------------
  ------------------------------------------------------------------------------

  self.menuGroup = display.newGroup();
  self.menuGauntletGroup = display.newGroup();
  self.menuBrawlGroup = display.newGroup();
  self.menuAIFightButtonGroup = display.newGroup();
  self.menuMultiplayerButtonGroup = display.newGroup();
  self.mainMenuButtonGroup = display.newGroup();
  self.menuTitleGroup = display.newGroup();

  self.mainMenuButtonGroup:insert(self.menuGauntletGroup);
  self.mainMenuButtonGroup:insert(self.menuBrawlGroup);
  self.mainMenuButtonGroup:insert(self.menuAIFightButtonGroup);
  self.mainMenuButtonGroup:insert(self.menuMultiplayerButtonGroup);

  self.menuGroup:insert(self.mainMenuButtonGroup);
  self.menuGroup:insert(self.menuTitleGroup);

  display.newText(self.menuTitleGroup, "Prepenol", display.contentWidth/2+5, 155, "font/Audiowide-Regular.ttf", 164);
  self.menuTitleGroup[1]:setFillColor(0.5, 0.5, 0.5);
  display.newText(self.menuTitleGroup, "Prepenol", display.contentWidth/2, 150, "font/Audiowide-Regular.ttf", 164);
  self.menuTitleGroup[2]:setFillColor(1, 0.5, 0.25);

  display.newRect(self.menuGauntletGroup,
                  32,
                  164+75+32,
                  1024,
                  display.contentHeight - ((164+75+32) + 32) - 400);
  self.menuGauntletGroup[1].anchorX = 0;
  self.menuGauntletGroup[1].anchorY = 0;
  self.menuGauntletGroup[1].fill = {
    type = "gradient",
    color1 = { 0.7, 0.1, 0.2},
    color2 = { 0.9, 0.3, 0.4},
    direction = "down"
  }
  display.newText(self.menuGauntletGroup,
                  "Gauntlet",
                  self.menuGauntletGroup[1].x + self.menuGauntletGroup[1].width/2,
                  self.menuGauntletGroup[1].y + self.menuGauntletGroup[1].height/2,
                  "font/LeagueSpartan-Bold.ttf",
                  210);
  self.menuGauntletGroup.super = self;
  self.menuGauntletGroup.touch = self.restartGuantlet;
  self.menuGauntletGroup:addEventListener("touch", self.menuGauntletGroup);

  display.newRect(self.menuBrawlGroup,
                  32,
                  164+75+32 + 400,
                  self.menuGauntletGroup[1].width,
                  display.contentHeight - ((164+75+32) + 32 + 400));
  self.menuBrawlGroup[1].anchorX = 0;
  self.menuBrawlGroup[1].anchorY = 0;
  self.menuBrawlGroup[1].fill = {
    type = "gradient",
    color1 = { 0.7, 0.7, 0.2},
    color2 = { 1, 1, 0.5},
    direction = "down"
  }
  display.newText(self.menuBrawlGroup,
                  "101 Ship Brawl",
                  self.menuBrawlGroup[1].x + self.menuBrawlGroup[1].width/2,
                  self.menuBrawlGroup[1].y + self.menuBrawlGroup[1].height/2,
                  "font/LeagueSpartan-Bold.ttf",
                  130);
  self.menuBrawlGroup.super = self;
  self.menuBrawlGroup.touch = self.restartBrawl;
  self.menuBrawlGroup:addEventListener("touch", self.menuBrawlGroup);

  display.newRect(self.menuAIFightButtonGroup,
                  32 + self.menuGauntletGroup[1].width + 32,
                  164+75+32,
                  display.contentWidth - (self.menuGauntletGroup[1].width + 32 + 32 + 32),
                  250);
  self.menuAIFightButtonGroup[1].anchorX = 0;
  self.menuAIFightButtonGroup[1].anchorY = 0;
  self.menuAIFightButtonGroup[1].fill = {
    type = "gradient",
    color1 = { 0.3, 0.3, 0.3, 1},
    color2 = { 0.7, 0.7, 0.7, 1},
    direction = "down"
  }
  display.newText(self.menuAIFightButtonGroup,
                  "Boss Duel",
                  self.menuAIFightButtonGroup[1].x + self.menuAIFightButtonGroup[1].width/2,
                  self.menuAIFightButtonGroup[1].y + self.menuAIFightButtonGroup[1].height/2,
                  "font/LeagueSpartan-Bold.ttf",
                  120);

  display.newRect(self.menuMultiplayerButtonGroup,
                  32 + self.menuGauntletGroup[1].width + 32,
                  164+75+32 + self.menuAIFightButtonGroup[1].height + 32,
                  display.contentWidth - (self.menuGauntletGroup[1].width + 32 + 32 + 32),
                  display.contentHeight - ((164+75+32) + 32 + self.menuAIFightButtonGroup[1].height + 32));
  self.menuMultiplayerButtonGroup[1].anchorX = 0;
  self.menuMultiplayerButtonGroup[1].anchorY = 0;
  self.menuMultiplayerButtonGroup[1].fill = {type = "image", filename = "img/menu/twin1.jpg"}
  display.newRect(self.menuMultiplayerButtonGroup,
                  self.menuMultiplayerButtonGroup[1].x,
                  self.menuMultiplayerButtonGroup[1].y,
                  self.menuMultiplayerButtonGroup[1].width,
                  self.menuMultiplayerButtonGroup[1].height)
                  self.menuMultiplayerButtonGroup[2].anchorX = 0;
                  self.menuMultiplayerButtonGroup[2].anchorY = 0;
  self.menuMultiplayerButtonGroup[2].fill = {
    type = "gradient",
    color1 = { 0.3, 0.3, 0.3, 1},
    color2 = { 0.7, 0.7, 0.7, 1},
    direction = "down"
  }
  display.newText(self.menuMultiplayerButtonGroup,
                  "Dogfight",
                  self.menuMultiplayerButtonGroup[1].x + self.menuMultiplayerButtonGroup[1].width/2,
                  self.menuMultiplayerButtonGroup[1].y + self.menuMultiplayerButtonGroup[1].height/2,
                  "font/LeagueSpartan-Bold.ttf",
                  164);

  self.mainMenuButtonGroup.alpha = 0.9

  self.menuGroup.isVisible = false;

  ------------------------------------------------------------------------------

end

--gets an object from the hud
function gui.class:get(index1, index2)
  if(index1 == nil) then
    return self.gameplayHUDTable;
  elseif(index2 == nil) then
    return self.gameplayHUDTable[index1];
  else
    return self.gameplayHUDTable[index1][index2];
  end
end

function gui.class:getEnemyCounter()
  return self.brawlEnemyCounter;
end

function gui.class:setEnemyCounter(_count)
  self.brawlEnemyCounter.text = _count;
  return self.brawlEnemyCounter;
end

function gui.class:getEnemyCounterGroup()
  return self.brawlCounterGroup;
end

function gui.class:getState()
  return self.gameState;
end

function gui.class:getSelf()
  return self;
end

function gui.class:setState(_state)
  self.gameState = _state;
  return self.gameState;
end

function gui.class:run()
  self.radar:run();
end

function gui.class:showEndscreen()
  -- if (self.controlGroup[5].alpha < 1) then
    self.controlGroup[5].alpha = self.controlGroup[5].alpha + 0.02;
    self.gameOverBackground:setFillColor(0.8, 0.2, 0.1);
    self.gameOverText.text = "gg wp";
    if(self.controlGroup[5].alpha >= 0.87) then
      self.menuButtonGroup.alpha = self.menuButtonGroup.alpha + 0.05
      self.restartButtonGroup.alpha = self.restartButtonGroup.alpha + 0.05
    end
  -- end
end

function gui.class:insert(_displayObj, _index)
  self.controlGroup[_index]:insert(_displayObj);
end

function gui.class:restartGame(event)
  if(event.phase == "began") then
    if(self.super.gameState == 4) then
      self.super.gameState = 5;
    elseif(self.super.gameState == 8 or self.super.gameState == 9) then
      self.super.gameState = 7;
    end
    self.super.controlGroup[5].alpha = 0;
    self.super.menuButtonGroup.alpha = 0;
    self.super.restartButtonGroup.alpha = 0;
  end
end

function gui.class:restartGuantlet(event)
  if(event.phase == "began") then
    self.super.gameState = 5;
    self.super.controlGroup[5].alpha = 0;
    self.super.menuButtonGroup.alpha = 0;
    self.super.restartButtonGroup.alpha = 0;
  end
end

function gui.class:restartBrawl(event)
  if(event.phase == "began") then
    self.super.gameState = 7;
    self.super.controlGroup[5].alpha = 0;
    self.super.menuButtonGroup.alpha = 0;
    self.super.restartButtonGroup.alpha = 0;
  end
end

function gui.class:returnToMenu(event)
  if(event.phase == "began") then
    self.super.gameState = 6;
    self.super.controlGroup[5].alpha = 0;
    self.super.menuButtonGroup.alpha = 0;
    self.super.restartButtonGroup.alpha = 0;
  end
end

function gui.class:showVictoryScreen()
  -- if (self.controlGroup[5].alpha < 1) then
    self.gameOverBackground:setFillColor(0.1, 0.8, 0.15);
    self.gameOverText.text = "VICTORY";
    self.controlGroup[5].alpha = self.controlGroup[5].alpha + 0.02;
    if(self.controlGroup[5].alpha >= 0.87) then
      self.menuButtonGroup.alpha = self.menuButtonGroup.alpha + 0.05
      self.restartButtonGroup.alpha = self.restartButtonGroup.alpha + 0.05
    end
  -- end
end

return gui;
