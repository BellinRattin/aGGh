-------------------------
-- ain't GGonna happen --
-- a BR addon          --
-- All Rights Reserved --
-------------------------
aGGh = LibStub("AceAddon-3.0"):NewAddon("aGGh")

local tostring = tostring

local settingsDefaults = {
	global = {
		chatChannels = {
			CHAT_MSG_GUILD = true,
			CHAT_MSG_RAID = true,
			CHAT_MSG_PARTY = true,
			CHAT_MSG_WHISPER = true,
			CHAT_MSG_SAY = true,
			CHAT_MSG_YELL = true,
			CHAT_MSG_CHANNEL = true,
		},
		chatMessages = {
			gg = true,
			gz = true,
		}
	}
}

function aGGh:OnInitialize()
	DEFAULT_CHAT_FRAME:AddMessage("aGGh loaded")
	self.db = LibStub("AceDB-3.0"):New("aGGhDB", settingsDefaults, true)
	DEFAULT_CHAT_FRAME:AddMessage("aaa "..tostring(self.db.global.chatMessages.gg))
	self:setFilters()
end

function aGGh:OnEnable()
	
end

function aGGh:OnDisable()

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
	gg = ggFilter,
	gz = gzFilter,
}

function aGGh:setFilters()
	for mes,value in pairs(self.db.global.chatMessages) do
		if value then 
			for channel,isTrue in pairs(self.db.global.chatChannels) do
				if isTrue then
					if tostring(mes) == "gg" then
						ChatFrame_AddMessageEventFilter(tostring(channel), ggFilter)
					elseif tostring(mes) == "gz" then
						ChatFrame_AddMessageEventFilter(tostring(channel), gzFilter)
					end
				end
			end
		end
	end
end
