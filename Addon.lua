--[[----------------------------------------------------------------------------
  Copyright (c) 2009, Tom Wieland
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of idChat nor the names of its contributors may be used
    to endorse or promote products derived from this software without specific
    prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
------------------------------------------------------------------------------]]

local _G = _G

ChatFontNormal:SetFont("Fonts\\ARIALN.ttf", 12, "THINOUTLINE") 
ChatFrame1:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
ChatFrame2:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")
ChatFrame3:SetFont("Fonts\\ARIALN.ttf", 12, "OUTLINE")

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local hooks = {}
local replaces = {
	['Guild'] = '.g.',
	['Party'] = '.p.',
	['Raid'] = '.r.',
	['Raid Leader'] = '.rl.',
	['Raid Warning'] = '!rw!',
	['Officer'] = '.o.',
	['Battleground'] = '.bg.',
	['Battleground Leader'] = '.bl.',
	['Dungeon Guide'] = '.dg.',
	['Party Leader'] = '.pl.',
	['(%d+)%. .-'] = '%1',
}

CHAT_FLAG_AFK = "|cff348EF5afk!|r "
CHAT_FLAG_DND = "|cffE81E6Cdnd!|r "
CHAT_FLAG_GM = "|cffEA00FFgm!|r "
FACTION_STANDING_CHANGED = "%s: %s"
FACTION_STANDING_DECREASED = "|3-7(%s) -%d."
FACTION_STANDING_INCREASED = "|3-7(%s) +%d."
CHAT_YOU_CHANGED_NOTICE = "# |Hchannel:%d|h%s|h"
CHAT_YOU_JOINED_NOTICE = "+ |Hchannel:%d|h%s|h"
CHAT_YOU_LEFT_NOTICE = "- |Hchannel:%d|h%s|h"
CHAT_CHANNEL_JOIN_GET = "+ %s"
CHAT_CHANNEL_LEAVE_GET = "- %s"
ERR_FRIEND_ADDED_S = "%s ++f"
ERR_FRIEND_REMOVED_S = "%s --f"
ERR_FRIEND_WRONG_FACTION = "|cffD21111wrong faction|r."
ERR_FRIEND_SELF = "|cffD21111adding self|r."
ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h |cff0DF246on|r."
ERR_FRIEND_OFFLINE_S = "%s |cffF0315Eoff|r."
ERR_IGNORE_ADDED_S = "%s |cffF52020ignored|r."
ERR_IGNORE_REMOVED_S = "%s --|cffF52020ignore|r."
ERR_IGNORE_ALREADY_S = "%s |cffF52020ignored|r already."
ERR_QUEST_REWARD_ITEM_MULT_IS = "|cffE8217Bgiven|r %dx %s"
ERR_QUEST_REWARD_ITEM_S = "|cffE8217Bgiven|r %s"
ERR_ZONE_EXPLORED = "|cff4DE48Fdiscovered|r %s"
ERR_ZONE_EXPLORED_XP = "|cff4DE48Fdiscovered|r %s | gained %d |cff239B29xp|r"
COMBATLOG_HONORAWARD = "|cff38B75C+|r %d |cff38B7C5honor|r"
COMBATLOG_HONORGAIN = "%s dies, rank: %s (%d |cff38B7C5honor|r)"
COMBATLOG_XPGAIN = "%s |cff239B29+|r %d |cff239B29xp|r"
ERR_QUEST_REWARD_EXP_I = "|cff239B29+|r %d |cff239B29xp|r"
COMBATLOG_XPGAIN_FIRSTPERSON = "%s dies |cff239B29+|r %d |cff239B29xp|r"
COMBATLOG_XPGAIN_EXHAUSTION1 = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cff18D5EAbonus|r"
COMBATLOG_XPGAIN_EXHAUSTION1_GROUP = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cff18D5EAbonus|r, +%d |cff0C99E4group|r"
COMBATLOG_XPGAIN_EXHAUSTION1_RAID = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cff18D5EAbonus|r, -%d |cffF041C4r|r"
COMBATLOG_XPGAIN_EXHAUSTION2 = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cff18D5EAbonus|r"
COMBATLOG_XPGAIN_EXHAUSTION2_GROUP = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cff18D5EAbonus|r, +%d |cff0C99E4g|r"
COMBATLOG_XPGAIN_EXHAUSTION2_RAID = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cff18D5EAbonus|r, -%d |cffF041C4r|r"
COMBATLOG_XPGAIN_EXHAUSTION4 = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cffE43167p|r"
COMBATLOG_XPGAIN_EXHAUSTION4_GROUP = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cffE43167p|r, +%d |cff0C99E4g|r"
COMBATLOG_XPGAIN_EXHAUSTION4_RAID = COMBATLOG_XPGAIN_FIRSTPERSON.." (%s |cff239B29xp|r %s |cffE43167p|r, -%d |cffF041C4r|r"
COMBATLOG_XPGAIN_EXHAUSTION5 = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cffE43167p|r"
COMBATLOG_XPGAIN_EXHAUSTION5_GROUP = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cffE43167p|r, +%d |cff0C99E4g|r"
COMBATLOG_XPGAIN_EXHAUSTION5_RAID = COMBATLOG_XPGAIN_FIRSTPERSON.." %s |cff239B29xp|r %s |cffE43167p|r, -%d |cffF041C4r|r"
COMBATLOG_XPGAIN_FIRSTPERSON_GROUP = COMBATLOG_XPGAIN_FIRSTPERSON.." +%d |cff0C99E4g|r"
COMBATLOG_XPGAIN_FIRSTPERSON_RAID = COMBATLOG_XPGAIN_FIRSTPERSON.." -%d |cffF041C4r|r"
COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED = "|cff239B29++|r %d |cff239B29xp|r";
COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_GROUP = COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED.." +%d |cff0C99E4g|r"
COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED_RAID = COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED.." -%d |cffF041C4r|r"
COMBATLOG_XPGAIN_QUEST = COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED.." %s |cff239B29xp|r %s |cff18D5EAbonus|r"
COMBATLOG_XPLOSS_FIRSTPERSON_UNNAMED = "|cffE60E4f--|r %d |cff239B29xp|r"
ERR_SKILL_GAINED_S = "|cff38B75C+|r %s"
ERR_SKILL_UP_SI = "%s |cff38B75C+|r %d"
RAID_INSTANCE_WELCOME = "%s resets in %s."
DUEL_WINNER_KNOCKOUT = "%1$s wins over %2$s."
DUEL_WINNER_RETREAT = "%2$s forfiet %1$s."
LOOT_ITEM = "|cffE8217Bloot|r %s: %s"
LOOT_ITEM_MULTIPLE = "|cffE8217Bloot|r %s: %sx%d"
LOOT_ITEM_SELF = "|cffE8217Bloot|r: %s"
LOOT_ITEM_SELF_MULTIPLE = "|cffE8217Bloot|r: %sx%d"
LOOT_ITEM_PUSHED_SELF = "|cffE8217Bloot|r: %s"
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "|cffE8217Bloot|r: %sx%d"
LOOT_MONEY = "%s"
YOU_LOOT_MONEY = "%s"
LOOT_MONEY_SPLIT = "%s"

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

local function AddMessage(frame, text, red, green, blue, id)
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
	--text = '|cff999999' .. date('%I%M') .. '|r ' .. text

	return hooks[frame](frame, text, red, green, blue, id)
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
