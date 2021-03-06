-------------------------
-- ain't GGonna happen --
-- a BR addon          --
-- All Rights Reserved --
-------------------------
local addonName, addonTable = ...

local addonFrames = {}

addonFrames.addon = CreateFrame("Frame")

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

local aGGDBDefaults = {
	["version"] = "0.9.0",
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
	},
	["stats"] = {
		["total"] = 0,
		["badperson"] = {}
	}
}

local settings = {}

local badpeople = {}
local frame_bad = {}
local function UpdateBadPeople()
	wipe(badpeople)
	for k,v in pairs(settings["stats"]["badperson"]) do table.insert(badpeople, {k,v}) end
	table.sort(badpeople, function(a,b) return a[2]>b[2] end)
		
	for i = 1,min(#badpeople,5) do
		frame_bad[i]:SetText(badpeople[i][1].." "..badpeople[i][2])
	end
	frame_bad["all"]:SetText("Total: "..settings["stats"]["total"])
end

local function InitDB()
	settings = aGGhDB or aGGDBDefaults
	local vers = settings["version"]
	local curr = GetAddOnMetadata(addonName, "Version")
	if not vers then
		settings["version"] = curr
		settings["stats"] = {["total"]=0, ["badperson"] = {}}
	end
	if not(vers == curr) then
		-- if vers == "" then end
		settings["version"]=curr
	end
	aGGhDB = settings
end

function addonFrames.addon:ADDON_LOADED(name)
	if name == addonName then
		--settings = aGGhDB or DBDefaults
		--aGGhDB = settings
		InitDB()
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
	local bol 
	if not set["gg"] then
		if not set["gz"] then
			bol = false
		else
			bol = stringFind(msg, patterns.gz)
		end
	else
		if not set["gz"] then
			bol = stringFind(msg, patterns.gg)
		else
			bol = stringFind(msg, patterns.mix)
		end
	end
	if bol then
		settings["stats"]["total"] = settings["stats"]["total"] +1
			settings["stats"]["badperson"][author] = (settings["stats"]["badperson"][author] or 0) +1
		UpdateBadPeople()
	end
	return bol
end

addonFrames.addon:RegisterEvent("ADDON_LOADED")
addonFrames.addon:SetScript("OnEvent", function(self, event, ...)
	if not self[event] then
		return 
	end
	self[event](self, ...)
end)

------------------------------------------ Settings ------------------------------------------
function addonFrames.addon:CreateOptionPanel()
	local optionPanel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	optionPanel.name = "ain't GGonna happen"

	local tmpT = {}
	for j=1,#messa do
		local header = CreateFrame("Frame", nil, optionPanel)

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
			local checkbox = CreateFrame("CheckButton", nil, optionPanel, "InterfaceOptionsCheckButtonTemplate")
			checkbox.label = checkbox:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
			checkbox.label:SetPoint("LEFT", checkbox, "RIGHT")

			local k = (j*10)+i
			tmpT[k] = checkbox
			if not (chans[i]=="CHAT_MSG_CHANNEL")  then
				checkbox.label:SetText(nameTable[chans[i]].." chat")
			else
				checkbox.label:SetText("other "..nameTable[chans[i]])
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

	local header = CreateFrame("Frame", nil, optionPanel)

	header:SetPoint("TOPLEFT", optionPanel, "TOPLEFT", 0, -250)
	header:SetPoint("TOPRIGHT", optionPanel, "TOPRIGHT", 0, -250)

	header:SetHeight(18)
	header.label = header:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	header.label:SetPoint("TOP")
	header.label:SetPoint("BOTTOM")
	header.label:SetJustifyH("CENTER")
	header.label:SetText("STATISTICS")

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
	
	local all_label = header:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	frame_bad["all"] = all_label
	all_label:SetPoint("TOP", header, "BOTTOM", 0, -10)
	all_label:SetJustifyH("CENTER")
	--all_label:SetText("Total: "..settings["stats"]["total"])

	--local a={}
	for i=1,5 do
		local label = header:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
		frame_bad[i]=label
		if i == 1 then
			label:SetPoint("TOP", all_label, "BOTTOM", 0, -10)
		else
			label:SetPoint("TOP", frame_bad[i-1], "BOTTOM", 0, -10)
		end
		label:SetJustifyH("CENTER")
		--label:SetText(badpeople[i][1].." "..badpeople[i][2])
	end
	UpdateBadPeople()

	InterfaceOptions_AddCategory(optionPanel)
end
