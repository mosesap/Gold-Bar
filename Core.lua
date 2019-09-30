-------------------------------------------------------------
--REGION QUICK DEBUG
-------------------------------------------------------------
SLASH_RELOADUI1 = '/rl' -- for quicker reloading
SlashCmdList.RELOADUI = ReloadUI

SLASH_FRAMESTK1 = '/fs' -- for quicker access to frame stack
SlashCmdList.FRAMESTK = function()
    LoadAddOn('Blizzard_DebugTools')
    FrameStackTooltip_Toggle()
end
-- to be able to use the left and right arrows in the edit box
-- with out rotating your character!
for i = 1, NUM_CHAT_WINDOWS do
    _G['ChatFrame'..i..'EditBox']:SetAltArrowKeyMode(false)
end

-------------------------------------------------------------
--REGION MEMBER VARIABLES
-------------------------------------------------------------
local prev_energy = 0
local unit_energy = 0
local prev_energy_tick = 0
local tick_increment = 1.9
-------------------------------------------------------------
--REGION CREATE AUBAR FRAME
-------------------------------------------------------------
local AuBar = CreateFrame('StatusBar', 'AuBar', UIParent)
AuBar:SetSize(300,360)
AuBar:SetPoint('Center', UIParent, 'Center')
--generic scipt caller, calls appropiate function on event
AuBar:SetScript("OnEvent", function(self, event, ...)
    --print(event, unpack{...})
	return self[event](self, event, ...)
end)
AuBar:RegisterEvent("PLAYER_LOGIN")
AuBar:RegisterEvent("PLAYER_LOGOUT")

-------------------------------------------------------------
--REGION AUBAR EVENT HANDLERS
-------------------------------------------------------------
function AuBar.PLAYER_LOGIN(self, event)
        print("welcome ", UnitName("player").."!")
        self:RegisterEvent("UNIT_POWER_UPDATE")
        self:UNIT_POWER_UPDATE(nil, "player", "ENERGY")
        
        local TickerFrame = CreateFrame("Frame")
        TickerFrame:SetScript("OnUpdate", TickerOnUpdate)
end

function AuBar.UNIT_POWER_UPDATE(self, event, unit, powertype)
    unit_energy = UnitPower("player")
    if unit_energy ~= prev_energy then
        --do something
    end
    prev_energy = unit_energy
end

function TickerOnUpdate(self)
     unit_energy = UnitPower("player", PowerTypeIndex)
    local now = GetTime()
    if unit_energy > prev_energy or now >= prev_energy_tick + 2 then
        prev_energy_tick = now
        print("now")
    end
    --% game time and only increment the bar if the time has moved by > the increment
    prev_energy = unit_energy
end