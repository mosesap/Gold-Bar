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
--REGION FUNCTIONS
-------------------------------------------------------------
local function CreateBar(name, previous)
	local f = CreateFrame("StatusBar", "Fizzle"..name, UIParent)
	f:SetSize(200, 30)
	if not previous then
		f:SetPoint("LEfT", 10, 0)
	else
		f:SetPoint("TOP", previous, "BOTTOM")
	end
	f:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	f.Text = f:CreateFontString()
	f.Text:SetFontObject(GameFontNormal)
	f.Text:SetPoint("CENTER")
	f.Text:SetJustifyH("CENTER")
	f.Text:SetJustifyV("CENTER")
	return f
end

local function UpdateTicker(self) 
    local curr_nrg = UnitPower("player")
    local now = GetTime()
    local bar_tick = math.floor((now - self.prev_tick)  * 100)
    if bar_tick > 190 or bar_tick < 10 then 
        self:SetStatusBarColor(1, .1, .9) 
    else 
        self:SetStatusBarColor(255, 215, 0)
    end
    if now >= self.prev_tick + 2 or curr_nrg > self.prev_nrg then
        self.prev_tick = now
        bar_tick = 0 
    end  
    if curr_nrg + 20 < UnitPowerMax("player") then
        self.Text:SetText(curr_nrg + 20)
    else
        self.Text:SetText(UnitPowerMax("player"))
    end
    self.prev_nrg = curr_nrg
    self:SetValue(bar_tick)
end

if "Rogue" == UnitClass("player") or "Druid" == UnitClass("player") then
    local Au_Bar = CreateBar('GoldBar')
    Au_Bar:SetMinMaxValues(0, 200)
    Au_Bar:SetMovable(true)
    Au_Bar:EnableMouse(true)
    Au_Bar:RegisterForDrag("LeftButton")
    Au_Bar:SetScript("OnDragStart", Au_Bar.StartMoving)
    Au_Bar:SetScript("OnDragStop", Au_Bar.StopMovingOrSizing)
    Au_Bar.prev_nrg = 0
    Au_Bar.prev_tick = 0
    Au_Bar:SetScript("OnUpdate", function(self, event, ...)
        UpdateTicker(self)
    end)
end