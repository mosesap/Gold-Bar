local function CreateBar(name, type, texture, anchor)
	local frame = CreateFrame(type, name, UIParent)
	if not anchor then
		frame:SetPoint("LEFT", 10, 0)
	else
		frame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT")
	end
	frame:SetStatusBarTexture(texture)
	frame.Text = frame:CreateFontString()
	frame.Text:SetFontObject(GameFontNormal)
	frame.Text:SetPoint("CENTER")
	frame.Text:SetJustifyH("CENTER")
	frame.Text:SetJustifyV("CENTER")
	return frame
end

local function ConfigureGoldBar(bar)
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
    bar:SetSize(200, 30)
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

local function ConfigureComboBar(bar, point)
    local function UpdateBar(self)
        self.curr_points = GetComboPoints("player", "target")
        self:SetValue(self.curr_points)
        self.Text:SetText(self.curr_points) 
        if self.curr_points == 0 then
            self:SetStatusBarColor(255, 0, 0) 
        elseif self.curr_points == 1 then
            self:SetStatusBarColor(246/255, 189/255, 192/255) 
        elseif self.curr_points == 2 then
            self:SetStatusBarColor(241/255, 149/255, 155/255) 
        elseif self.curr_points == 3 then
            self:SetStatusBarColor(240/255, 116/255, 112/255) 
        elseif self.curr_points == 4 then
            self:SetStatusBarColor(234/255, 76/255, 70/255) 
        else
            self:SetStatusBarColor(220/255, 28/255, 19/255)
        end
    end
    bar.curr_points = 0
    bar.Text:SetText(bar.curr_points)  
    bar:SetSize(200, 30)
    bar:SetMinMaxValues(0, 5)
    bar:SetValue(0)
    bar:SetStatusBarColor(242/255, 75/255, 75/255) 
    bar:SetScript("OnEvent", function(self, event, ...)
        if event == "UNIT_POWER_UPDATE" then
            UpdateBar(self)
        end
    end)
    bar:RegisterEvent("UNIT_POWER_UPDATE")
end

if "Rogue" == UnitClass("player") then 
    local GoldBar = CreateBar("GoldBar", "StatusBar", "Interface\\TargetingFrame\\UI-StatusBar")
    ConfigureGoldBar(GoldBar)
    local ComboBar = CreateBar("ComboBar", "StatusBar", "Interface\\TargetingFrame\\UI-StatusBar", GoldBar)
    ConfigureComboBar(ComboBar)
end