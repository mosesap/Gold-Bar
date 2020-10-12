local function CreateBar(name, previous)
	local frame = CreateFrame("StatusBar", "Fizzle"..name, UIParent)
	frame:SetSize(200, 30)
	if not previous then
		frame:SetPoint("LEFT", 10, 0)
	else
		frame:SetPoint("TOP", previous, "BOTTOM")
	end
	frame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	frame.Text = frame:CreateFontString()
	frame.Text:SetFontObject(GameFontNormal)
	frame.Text:SetPoint("CENTER")
	frame.Text:SetJustifyH("CENTER")
	frame.Text:SetJustifyV("CENTER")
	return frame
end

local function ConfigureBar(bar)
    local function UpdateBar(self)
        self.curr_nrg = UnitPower("player")
        self.now = GetTime()
        self.bar_tick = math.floor((self.now - self.prev_tick)  * 100)
        if self.bar_tick > 185 then 
            self:SetStatusBarColor(242/255, 75/255, 75/255) 
        else 
            self:SetStatusBarColor(255, 215, 0)
        end
        if self.now >= self.prev_tick + 2 or self.curr_nrg > self.prev_nrg then
            self.prev_tick = self.now
            self.bar_tick = 0 
        end
        self.prev_nrg = self.curr_nrg
        self.Text:SetText(self.curr_nrg)  
        self:SetValue(self.bar_tick)
    end
    
    bar:SetMinMaxValues(0, 200)
    bar:SetMovable(true)
    bar:EnableMouse(true)
    bar:RegisterForDrag("LeftButton")
    bar:SetScript("OnDragStart", bar.StartMoving)
    bar:SetScript("OnDragStop", bar.StopMovingOrSizing)
    bar.prev_nrg = 0
    bar.prev_tick = 0
    bar.curr_nrg = 0
    bar.now = 0
    bar.bar_tick = 0
    bar:SetScript("OnUpdate", function(self, event, ...)
        UpdateBar(self)
    end)
end

if "Rogue" == UnitClass("player") then 
    ConfigureBar(CreateBar('GoldBar'))
end