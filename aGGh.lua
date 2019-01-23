-------------------------
-- ain't GGonna happen --
-- a BR addon          --
-- All Rights Reserved --
-------------------------
local addonName, addonTable = ...

local f = CreateFrame("Frame")

local tostring , stringFind = tostring, string.find

local messa = {"gg", "gz",}
local chans = {"CHAT_MSG_GUILD", "CHAT_MSG_RAID", "CHAT_MSG_PARTY", "CHAT_MSG_WHISPER",
	"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_CHANNEL",}
local nameTable = {
	["CHAT_MSG_GUILD"] = "guild",
	["CHAT_MSG_RAID"] = "raid",
	["CHAT_MSG_PARTY"] = "party",
	["CHAT_MSG_WHISPER"] = "whisper",
	["CHAT_MSG_SAY"] = "say",
	["CHAT_MSG_YELL"] = "yell",
	["CHAT_MSG_CHANNEL"] = "channels",
}

local settingsDefaults = {
	["channels"] = {
		["CHAT_MSG_GUILD"] = {
			["gg"] = true,
			["gz"] = true,
		},
		["CHAT_MSG_RAID"] = {
			["gg"] = true,
			["gz"] = true,
		},
		["CHAT_MSG_PARTY"] = {
			["gg"] = true,
			["gz"] = true,
		},
		["CHAT_MSG_WHISPER"] = {
			["gg"] = true,
			["gz"] = true,
		},
		["CHAT_MSG_SAY"] = {
			["gg"] = true,
			["gz"] = true,
		},
		["CHAT_MSG_YELL"] = {
			["gg"] = true,
			["gz"] = true,
		},
		["CHAT_MSG_CHANNEL"] = {
			["gg"] = true,
			["gz"] = true,
		},
	}
}

local settings = {}

function f:ADDON_LOADED(name)
	if name == addonName then
		settings = aGGhDB or settingsDefaults
		aGGhDB = settings
		self:CreateOptionPanel()
	end
end

local patterns = {
	["gg"] = "%f[%a][gG][gG]+%f[%A]",
	["gz"] = "%f[%a][gG][zZ]+%f[%A]",
	["mix"] = "%f[%a][gG][gGzZ]+%f[%A]"
}

local function PatternFilter(self, event, msg, author,...)
	local set = settings["channels"][tostring(event)]
	if not set["gg"] then
		if not set["gz"] then
			return false
		else
			return stringFind(msg, patterns.gz)
		end
	else
		if not set["gz"] then
			return stringFind(msg, patterns.gg)
		else
			return stringFind(msg, patterns.mix)
		end
	end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
	if not self[event] then
		return 
	end
	self[event](self, ...)
end)

------------------------------------------ Settings ------------------------------------------
function f:CreateOptionPanel()
	local optionPanel = CreateFrame("Frame", "aGGhOptionPanel", InterfaceOptionsFramePanelContainer)
	optionPanel.name = "ain't GGonna happen"

	local tmpT = {}
	for j=1,#messa do
		local header = CreateFrame("Frame", messa[j].."Header", optionPanel)

		if j == 1 then 
			header:SetPoint("TOPLEFT", optionPanel, "TOPLEFT", 0, -10)
			header:SetPoint("TOPRIGHT", optionPanel, "TOP")
		elseif j == 2 then
			header:SetPoint("TOPLEFT", optionPanel, "TOP", 0, -10)
			header:SetPoint("TOPRIGHT", optionPanel, "TOPRIGHT")
		end

		header:SetHeight(18)
		header.label = header:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
		header.label:SetPoint("TOP")
		header.label:SetPoint("BOTTOM")
		header.label:SetJustifyH("CENTER")
		header.label:SetText("HIDE "..messa[j].." FROM")

		header.left = header:CreateTexture(nil, "BACKGROUND")
		header.left:SetHeight(8)
		header.left:SetPoint("LEFT", 10, 0)
		header.left:SetPoint("RIGHT", header.label, "LEFT", -5, 0)
		header.left:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
		header.left:SetTexCoord(0.81, 0.94, 0.5, 1)
		header.right = header:CreateTexture(nil, "BACKGROUND")
		header.right:SetHeight(8)
		header.right:SetPoint("RIGHT", -10, 0)
		header.right:SetPoint("LEFT", header.label, "RIGHT", 5, 0)
		header.right:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
		header.right:SetTexCoord(0.81, 0.94, 0.5, 1)
	
		for i=1,#chans do
			local checkbox = CreateFrame("CheckButton", messa[j]..nameTable[chans[i]].."Checkbox", optionPanel, "InterfaceOptionsCheckButtonTemplate")
			local k = (j*10)+i
			tmpT[k] = checkbox
			if not (chans[i]=="CHAT_MSG_CHANNEL")  then
				_G[checkbox:GetName().."Text"]:SetText(nameTable[chans[i]].." chat")
			else
				_G[checkbox:GetName().."Text"]:SetText("other "..nameTable[chans[i]])
			end

			if i >1 then
				checkbox:SetPoint("TOPLEFT", tmpT[k-1], "BOTTOMLEFT")
			else
				checkbox:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 20, -5)
			end

			checkbox:SetScript("OnClick", function(self, button, down)
				settings["channels"][chans[i]][messa[j]] = self:GetChecked() and true or false
			end)

			--checkbox.tooltipText = "TEST TOOLTIP"

			if settings["channels"][chans[i]][messa[j]] then 
				checkbox:SetChecked(true)
			end

			if j < 2 then
				ChatFrame_AddMessageEventFilter(chans[i], PatternFilter)
			end
		end
	end
	InterfaceOptions_AddCategory(optionPanel)
end