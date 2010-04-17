local _G = _G

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local f = CreateFrame('Frame')
local original_addmessages = {}

local dummy = function(...) end
local hide_frame
local scroll_chat
local tell_target
local add_message

local enable
local on_event

_G.CHAT_BATTLEGROUND_GET        = '|Hchannel:Battleground|hb|h %s '
_G.CHAT_BATTLEGROUND_LEADER_GET = '|Hchannel:Battleground|hB|h %s '

_G.CHAT_CHANNEL_GET             = '%s '

_G.CHAT_GUILD_GET               = '|Hchannel:Guild|hg|h %s '
_G.CHAT_OFFICER_GET             = '|Hchannel:o|ho|h %s '

_G.CHAT_PARTY_GET               = '|Hchannel:Party|hp|h %s '
_G.CHAT_PARTY_GUIDE_GET         = '|Hchannel:Party|hP|h %s '
_G.CHAT_PARTY_LEADER_GET        = '|Hchannel:Party|hP|h %s '

_G.CHAT_RAID_WARNING_GET        = '|Hchannel:raid|hW|h %s '
_G.CHAT_RAID_GET                = '|Hchannel:raid|hr|h %s '
_G.CHAT_RAID_LEADER_GET         = '|Hchannel:raid|hR|h %s '

_G.CHAT_SAY_GET                 = '%s '
_G.CHAT_YELL_GET                = '%s '

_G.CHAT_WHISPER_GET             = '%s < '
_G.CHAT_WHISPER_INFORM_GET      = '%s > '

function hide_frame(frame)
	frame.Show = dummy
	frame:Hide()
end

function scroll_chat(frame, delta)
	if delta > 0 then
		if IsShiftKeyDown() then
			frame:ScrollToTop()
		else
			frame:ScrollUp()
		end
	elseif delta < 0 then
		if IsShiftKeyDown() then
			frame:ScrollToBottom()
		else
			frame:ScrollDown()
		end
	end
end

function tell_target(message)
	if
		not (
			message and
			message:len() > 0
		) or
		not UnitExists('target') or
		not UnitName('target') or
		not UnitIsPlayer('target') or
		GetDefaultLanguage('player') ~= GetDefaultLanguage('target')
	then
		return
	end

	local name, realm = UnitName('target')
	if realm and realm ~= GetRealmName() then
		name = ('%s-%s'):format(name, realm)
	end
	SendChatMessage(message, 'WHISPER', nil, name)
end

function add_message(frame, text, ...)
	if not text then
		return
	end
	text = tostring(text)

	-- '|Hchannel:2|h[2. Trade]|h |Hplayer:PlayerName:12345|h[PlayerName]|h MESSAGE'
	text = text:gsub('|Hchannel:(%d)|h.-|h', '|Hchannel:%1|h%1|h')
	text = text:gsub('|Hplayer:(.-)|h%[(.-)%]|h', '|Hplayer:%1|h<%2>|h')

	text = ('|cffffffff%s|r %s'):format(date('%H:%M:%S'), text)


	return original_addmessages[frame](frame, text, ...)
end

function enable(...)
	local frame
	for i = 1, NUM_CHAT_WINDOWS do
		frame = _G['ChatFrame' .. i]

		-- hide buttons
		hide_frame(_G['ChatFrame' .. i .. 'UpButton'])
		hide_frame(_G['ChatFrame' .. i .. 'DownButton'])
		hide_frame(_G['ChatFrame' .. i .. 'BottomButton'])

		-- disable text fading
		frame:SetFading(false)

		-- mousewheel scrolling
		frame:EnableMouseWheel(true)
		frame:SetScript('OnMouseWheel', scroll_chat)

		original_addmessages[frame] = frame.AddMessage
		frame.AddMessage = add_message
	end

	-- hide buttons
	hide_frame(ChatFrameMenuButton)

	-- editbox
	local x=({ChatFrameEditBox:GetRegions()})
	x[6]:SetAlpha(0)
	x[7]:SetAlpha(0)
	x[8]:SetAlpha(0)

	-- editbox position
	ChatFrameEditBox:ClearAllPoints()
	ChatFrameEditBox:SetPoint(BL, _G.ChatFrame1, TL, -5, 0)
	ChatFrameEditBox:SetPoint(BR, _G.ChatFrame1, TR,  5, 0)

	-- editbox noalt
	ChatFrameEditBox:SetAltArrowKeyMode(nil)

	-- sticky channels
	ChatTypeInfo.SAY.sticky = 1
	ChatTypeInfo.EMOTE.sticky = 1
	ChatTypeInfo.YELL.sticky = 1
	ChatTypeInfo.PARTY.sticky = 1
	ChatTypeInfo.GUILD.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.BATTLEGROUND.sticky = 1
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1

	-- target tell
	SlashCmdList['IDCHATTELLTARGET'] = tell_target
	_G.SLASH_IDCHATTELLTARGET1 = '/tt'
end

f:SetScript('OnEvent', enable)
f:RegisterEvent('PLAYER_LOGIN')

