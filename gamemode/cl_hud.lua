kills = 3
money = 4001

LocalPlayer().HookPNWVar("money", function(mny) money = mny end))
LocalPlayer().HookPNWVar("kills", function(kls) kills = kls end))

function DrawHud()
	height = 125
	width = 350
	draw.RoundedBoxEx(16,0,ScrH()-height,width,height,Color(0,50,255,200),false,true,false,false)
end

hook.Add("HUDPaint","DrawFTSHud",DrawHud)
