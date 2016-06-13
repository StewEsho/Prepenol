--------------------------------------------------------------------------------
--
-- Controls the dogfight gamemode and all networking functionality
--
--------------------------------------------------------------------------------
-------------------------------- MULTIPLAYER.LUA -------------------------------
--------------------------------------------------------------------------------
local socket = require("socket");

local mp = {}

function mp:init()
end

local function advertiseServer( button )

  local send = socket.udp();
  send:settimeout( 0 );  --this is important (see notes below)

  local stop;

  local counter = 0;  --using this, we can advertise our IP address for a limited time

  local function broadcast()
    local msg = "AwesomeGameServer"
    --multicast IP range from 224.0.0.0 to 239.255.255.255
    send:sendto( msg, "228.192.1.1", 49398 )
    --not all devices can multicast so it's a good idea to broadcast too
    --however, for broadcast to work, the network has to allow it
    send:setoption( "broadcast", true )  --turn on broadcast
    send:sendto( msg, "255.255.255.255", 49398 )
    send:setoption( "broadcast", false )  --turn off broadcast

    counter = counter + 1
    if ( counter == 80 ) then  --stop after 8 seconds
        stop()
    end
  end

  --pulse 10 times per second
  local serverBroadcast = timer.performWithDelay( 100, broadcast, 0 )

  button.stopLooking = function()
    timer.cancel( serverBroadcast )  --cancel timer
    button.stopLooking = nil
  end

  stop = button.stopLooking
end

return mp;
