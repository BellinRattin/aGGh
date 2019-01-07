-------------------------
-- ain't GGonna happen --
-- a BR addon          --
-- All Rights Reserved --
-------------------------
local name, addon = ...

local f = CreateFrame("Frame")

local tostring = tostring

local settingsDefaults = {
	["chatChannels"] = {
		["CHAT_MSG_GUILD"] = true,
		["CHAT_MSG_RAID"] = true,
		["CHAT_MSG_PARTY"] = true,
		["CHAT_MSG_WHISPER"] = true,
		["CHAT_MSG_SAY"] = true,
		["CHAT_MSG_YELL"] = true,
		["CHAT_MSG_CHANNEL"] = true,
	},
	["chatMessages"] = {
		["gg"] = true,
		["gz"] = true,
	}
}


local activeFilters = {}

function f:ADDON_LOADED(...)
	--DEFAULT_CHAT_FRAME:AddMessage("aGGh loaded")
	activeFilters = aGGhDB or settingsDefaults -- change to read from savedVariables
	aGGhDB = activeFilters
	self:setFilters()
end

local function ggFilter(self, event, msg, author, ... )
	if msg=="gg" or msg == "GG" or msg == "Gg" or msg == "gG" then
		return true
	end
end
local function gzFilter(self, event, msg, author, ... )
	if msg=="gz" or msg == "GZ" or msg == "gZ" or msg == "Gz" then
		return true
	end
end

local filterTable = {
	["gg"] = ggFilter,
	["gz"] = gzFilter,
}

function f:setFilters()
	for mes,value in pairs(activeFilters.chatMessages) do
		if value then 
			for channel,isTrue in pairs(activeFilters.chatChannels) do
				if isTrue then
					ChatFrame_AddMessageEventFilter(tostring(channel), filterTable[tostring(mes)])
				end
			end
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