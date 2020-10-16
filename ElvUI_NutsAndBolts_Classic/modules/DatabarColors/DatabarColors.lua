local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local DB = E:GetModule('DataBars');
local mod = E:NewModule('NB_DataBarColors', 'AceHook-3.0');

local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local backupColor = FACTION_BAR_COLORS[1]
function mod:ChangeRepColor()
	local db = E.db.NutsAndBolts.DataBarColors.reputation.color
	local _, reaction = GetWatchedFactionInfo()
	local color = FACTION_BAR_COLORS[reaction] or backupColor
	local bar = DB.StatusBars.Reputation

	if db.default then
		bar:SetStatusBarColor(color.r, color.g, color.b)
	else
		if reaction >= 5 then
			bar:SetStatusBarColor(ENB:unpackColor(db.friendly))
		elseif reaction == 4 then
			bar:SetStatusBarColor(ENB:unpackColor(db.neutral))
		elseif reaction == 3 then
			bar:SetStatusBarColor(ENB:unpackColor(db.unfriendly))
		elseif reaction < 3 then
			bar:SetStatusBarColor(ENB:unpackColor(db.hated))
		end
	end
end

function mod:ChangeXPcolor()
	local db = E.db.NutsAndBolts.DataBarColors.experience.color
	local bar = DB.StatusBars.Experience

	if db.default then
		bar:SetStatusBarColor(0, 0.4, 1, .8)
		bar.Rested:SetStatusBarColor(1, 0, 1, 0.2)
	else
		bar:SetStatusBarColor(ENB:unpackColor(db.xp))
		bar.Rested:SetStatusBarColor(ENB:unpackColor(db.rested))
	end
end

function mod:ChangePetColor()
    if E.myclass ~= 'HUNTER' then return end
	local db = E.db.NutsAndBolts.DataBarColors.pet.color
	local bar = DB.StatusBars.PetExperience

	if db.default then
		bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b, .8)
	else
		bar:SetStatusBarColor(ENB:unpackColor(db.xp))
	end
end

function mod:Initialize()
	self:ChangeXPcolor()
	self:ChangeRepColor()
	self:ChangePetColor()

	hooksecurefunc(DB, 'ReputationBar_Update', mod.ChangeRepColor)
	hooksecurefunc(DB, 'ExperienceBar_Update', mod.ChangeXPcolor)
	hooksecurefunc(DB, 'PetExperienceBar_Update', mod.ChangePetColor)

	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.DataBarColors.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)