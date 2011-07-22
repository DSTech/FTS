local HUD_Kills = 0
LocalPlayer().HookPNWVar("kills", function(kills) HUD_Kills = kills end))
local HUD_Money = 0
LocalPlayer().HookPNWVar("money", function(money) HUD_Money = money end))

local HudBox_Height = 125
local HudBox_Width = 350
function DrawHud()
	draw.RoundedBoxEx(16,0,ScrH()-HudBox_Height,HudBox_Width,HudBox_Height,Color(0,50,255,200),false,true,false,false)
end
hook.Add("HUDPaint","DrawFTSHud",DrawHud)
