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
--REGION INITIALIZE ON LOGIN
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

function AuBar.PLAYER_LOGIN(self, event)
    print("welcome ", UnitName("player").."!")
    self:RegisterEvent("UNIT_POWER_UPDATE")
    self:UNIT_POWER_UPDATE(nil, "player", "ENERGY")
end

--REGION EVENT HANDLERS
local prev_energy = 0
function AuBar.UNIT_POWER_UPDATE(self, event, unit, powertype)
    local unit_energy = UnitPower("player")
    if unit_energy ~= prev_energy then
        print(unit_energy)
    end
    prev_energy = unit_energy
end
--comment commment comment asdfasdf