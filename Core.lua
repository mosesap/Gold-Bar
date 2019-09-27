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
local function HelloWorld(a)
    a = a or 'Good Bye World'
    print(a)
end

local UIConfig = CreateFrame('Frame', 'Au_Bar')--, UIParent, 'BasicFrameTemplateWithInset')
UIConfig:SetSize(300,360)
UIConfig:SetPoint('Center', UIParent, 'Center')
HelloWorld('Oh boy, here I go killing again')