local _G = _G

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local hooks = {}
local replaces = {
	['Guild'] = 'G',
	['Party'] = 'P',
	['Raid'] = 'R',
	['Raid Leader'] = 'RL',
	['Raid Warning'] = 'RW',
	['Officer'] = 'O',
	['Battleground'] = 'B',
	['Battleground Leader'] = 'BL',
	['(%d+)%. .-'] = '%1',
}

local function moveFrame (f, p1, p, p2, x, y)
	f:ClearAllPoints()
	f:SetPoint(p1, p, p2, x, y)
end

local function showFrameForever (f)
	f:SetScript('OnShow', nil)
	f:Show()
end

local function hideFrameForever (f)
	f:SetScript('OnShow', f.Hide)
	f:Hide()
end

local function AddMessage(frame, text, red, green, blue, alpha)
	text = tostring(text) or ''

	-- channels
	for k,v in pairs(replaces) do
		text = text:gsub('|h%['..k..'%]|h', '|h'..v..'|h')
	end

	-- players
	text = text:gsub('(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')

	-- normal messages
	text = text:gsub(' says:', ':')

	-- whispers
	text = text:gsub(' whispers:', ' <')
	text = text:gsub('To (|Hplayer.+|h):', '%1 >')

	-- achievements
	text = text:gsub('(|Hplayer.+|h) has earned the achievement (.+)!', '%1 ! %2')

	-- timestamp
	text = '|cff999999' .. date('%H%M') .. '|r ' .. text

	return hooks[frame](frame, text, red, green, blue, alpha)
end

local function scrollChat(frame, delta)
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

local function tellTarget(s)
	if not UnitExists('target') and UnitName('target') and UnitIsPlayer('target') and GetDefaultLanguage('player') == GetDefaultLanguage('target') or not (s and s:len()>0) then
		return
	end

	local name, realm = UnitName('target')
	if realm and realm ~= GetRealmName() then
		name = ('%s-%s'):format(name, realm)
	end
	SendChatMessage(s, 'WHISPER', nil, name)
end

local f
for i=1,7 do
	f = _G['ChatFrame'..i]

	-- buttons
	hideFrameForever(_G['ChatFrame'..i..'UpButton'])
	hideFrameForever(_G['ChatFrame'..i..'DownButton'])
	hideFrameForever(_G['ChatFrame'..i..'BottomButton'])

	-- no chat text fading
	--f:SetFading(false)

	-- scrolling
	f:EnableMouseWheel(true)
	f:SetScript('OnMouseWheel', scrollChat)

	-- text subs
	hooks[f] = f.AddMessage
	f.AddMessage = AddMessage
end

-- buttons
hideFrameForever(ChatFrameMenuButton)

-- editbox background
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
SlashCmdList['IDCHATTELLTARGET'] = tellTarget
_G.SLASH_IDCHATTELLTARGET1 = '/tt'
