local HUD_Kills = 0
local HUD_Money = 0
pnwv.HookVar("kills", "hudKillsDisplay", function(nwvar,value) HUD_Kills = value end, 0)
pnwv.HookVar("money", "hudMoneyDisplay", function(nwvar,value) HUD_Money = value end, 0)

local HudBox_Height = 32
local HudBox_Width = 148
local HudBox_TextColor = Color(255,255,255,255)
local HudBox_BackgroundColor = Color(100,100,100,200)
local Health_BackgroundColor = Color(100,100,100,200)
local Health_HPColor = Color(0,255,0,200)
local Health_LineColor = Color(0,0,0,100)
local Health_LineFrequency = 0.1
local Health_Max = 100
local Health_Width = 28
local Health_Scale = (surface.ScreenHeight() - HudBox_Height)/Health_Max

function DrawHud()
	local lp = LocalPlayer()
	local sw, sh = surface.ScreenWidth(), surface.ScreenHeight()
	
	draw.RoundedBoxEx(16,0,0,HudBox_Width,HudBox_Height,HudBox_BackgroundColor,false,false,false,true)
	draw.SimpleText(string.format("Money: $%i", tonumber(HUD_Money)), "Default", 5, 7, HudBox_TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText(string.format("Kills: %i", tonumber(HUD_Kills)), "Default", 5, HudBox_Height / 2 + 6, HudBox_TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	local curHP = lp:Health()
	--Draw the missing health if there is any
	if(curHP < Health_Max)then
		surface.SetDrawColor(Health_BackgroundColor)
		surface.DrawRect(0, sh-(Health_Max*Health_Scale), Health_Width, (Health_Max-curHP)*Health_Scale)
	end
	--Draw the current health
	surface.SetDrawColor(Health_HPColor)
	surface.DrawRect(0, sh-(curHP*Health_Scale), Health_Width, curHP*Health_Scale)

	surface.SetDrawColor(Health_LineColor)
	--Draw bar's outline
	surface.DrawOutlinedRect(0, sh-(Health_Max*Health_Scale), Health_Width, sh)
	--Place ticks on health bar:
	for i = 0, Health_Max, Health_LineFrequency*Health_Max do
		local lineYpos = sh - i*Health_Scale
		surface.DrawLine(0, lineYpos, Health_Width, lineYpos)
		--Place half-ticks under the normal ticks:
		lineYpos = sh - (i-(Health_LineFrequency*Health_Max)/2)*Health_Scale
		surface.DrawLine(Health_Width / 2, lineYpos, Health_Width, lineYpos)
	end
end
function GM:HUDPaint()
	DrawHud()
	return true
end

local hidden = { ["CHudHealth"] = true }
function GM:HUDShouldDraw(elmnt)
    if (hidden[elmnt]) then 
        return false
    end
	return true
end
