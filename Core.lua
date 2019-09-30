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

local prev_time_tick = 0
local tick_increment = 0.5
-------------------------------------------------------------
--REGION CREATE AUBAR FRAME
-------------------------------------------------------------
local BaseFrame = CreateFrame('Frame', 'BaseFrame', UIParent)
BaseFrame:SetSize(300,360)
BaseFrame:SetPoint('Center', UIParent, 'Center')
--generic scipt caller, calls appropiate function on event
BaseFrame:SetScript("OnEvent", function(self, event, ...)
    --print(event, unpack{...})
	return self[event](self, event, ...)
end)
--BaseFrame:SetScript("OnUpdate", TickerOnUpdate)
BaseFrame:RegisterEvent("PLAYER_LOGIN")
BaseFrame:RegisterEvent("PLAYER_LOGOUT")

-------------------------------------------------------------
--REGION BASE FRAME EVENT HANDLERS
-------------------------------------------------------------
function BaseFrame.PLAYER_LOGIN(self, event)
        print("welcome ", UnitName("player").."!")
        self:RegisterEvent("UNIT_POWER_UPDATE")
        self:UNIT_POWER_UPDATE(nil, "player", "ENERGY")
        
        local red = .5
        local green = .5
        local blue = .5
        local opacity = 1
        local tick = 0
        local AuBar = CreateFrame("StatusBar", "")
        AuBar:SetScript("OnUpdate", TickerOnUpdate)
        AuBar:SetStatusBarColor(red, green, blue, opacity)
        --may need to set a texture here
        AuBar:Show()
        local minValue
        local maxValue
        minValue, maxValue = StatusBar:GetMinMaxValues()
end

function BaseFrame.UNIT_POWER_UPDATE(self, event, unit, powertype)
    unit_energy = UnitPower("player")
    if unit_energy ~= prev_energy then
        --do something
    end
    prev_energy = unit_energy
end

-------------------------------------------------------------
--REGION AUBAR UPDATE HANDLER
-------------------------------------------------------------
function TickerOnUpdate(self)
    local now = GetTime()
    if now >= prev_energy_tick + 2 then
        prev_energy_tick = now
        prev_time_tick = now
        print("now")
        tick = 0
        AuBar:SetValue(tick)
    elseif now >= prev_time_tick + tick_increment then
        print("tick")
        tick += tick_increment
        AuBar:SetValue(tick)
        prev_time_tick = now
    end     
end