local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local M = E:GetModule('DataBars');
local mod = E:NewModule('NB_DataBarColors', 'AceHook-3.0');

local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local backupColor = FACTION_BAR_COLORS[1]
function mod:ChangeRepColor()
	local db = E.db.NutsAndBolts.DataBarColors.reputation.color
	local _, reaction = GetWatchedFactionInfo()
	local color = FACTION_BAR_COLORS[reaction] or backupColor
	local elvstatus = ElvUI_ReputationBar.statusBar

	if db.default then
		elvstatus:SetStatusBarColor(color.r, color.g, color.b)
	else
		if reaction >= 5 then
			elvstatus:SetStatusBarColor(ENB:unpackColor(db.friendly))
		elseif reaction == 4 then
			elvstatus:SetStatusBarColor(ENB:unpackColor(db.neutral))
		elseif reaction == 3 then
			elvstatus:SetStatusBarColor(ENB:unpackColor(db.unfriendly))
		elseif reaction < 3 then
			elvstatus:SetStatusBarColor(ENB:unpackColor(db.hated))
		end
	end
end

function mod:ChangeXPcolor()
	local db = E.db.NutsAndBolts.DataBarColors.experience.color
	local elvxpstatus = ElvUI_ExperienceBar.statusBar
	local elvrestedstatus = ElvUI_ExperienceBar.rested

	if db.default then
		elvxpstatus:SetStatusBarColor(0, 0.4, 1, .8)
		elvrestedstatus:SetStatusBarColor(1, 0, 1, 0.2)
	else
		elvxpstatus:SetStatusBarColor(ENB:unpackColor(db.xp))
		elvrestedstatus:SetStatusBarColor(ENB:unpackColor(db.rested))
	end
end

function mod:Initialize()
	self:ChangeXPcolor()
	self:ChangeRepColor()

	hooksecurefunc(M, 'UpdateReputation', mod.ChangeRepColor)
	hooksecurefunc(M, 'UpdateExperience', mod.ChangeXPcolor)
	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.DataBarColors.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)