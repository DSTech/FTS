local lp = LocalPlayer()
local HUD_Kills = 0
local HUD_Money = 0
pnwv.HookVar("kills", function(kills) HUD_Kills = kills end,0)
pnwv.HookVar("money", function(money) HUD_Money = money end,0)

local HudBox_Height = 125
local HudBox_Width = 350
local HudBox_TextColor = Color(255,255,255,255)
local HudBox_BackgroundColor = Color(0,50,255,200)
pcall(hook.Remove, "HUDPaint", "DrawFTSHud")
function DrawHud()
	draw.RoundedBoxEx(16,0,0,HudBox_Width,HudBox_Height,HudBox_BackgroundColor,false,false,false,true)
	draw.SimpleText(string.format("Money: %i", HUD_Money), "ScoreboardText", 5, 5, HudBox_TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText(string.format("Kills: %i", HUD_Kills), "ScoreboardText", 5, HudBox_Height / 2, HudBox_TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
hook.Add("HUDPaint","DrawFTSHud",DrawHud)

local hidden = { ["CHudHealth"] = true }
function HideDefaults(elmnt)
    if (hidden[elmnt]) then 
        return false;
    end 
end
hook.Add("HUDShouldDraw","DisableDefaultHud",HideDefaults)
