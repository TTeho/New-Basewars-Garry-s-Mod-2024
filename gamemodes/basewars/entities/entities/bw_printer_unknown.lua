AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Model = "models/props_lab/reciever01a.mdl"
ENT.Skin = 0

ENT.Capacity 		= math.huge
ENT.PrintInterval 	= 1
ENT.PrintAmount		= math.huge

ENT.PrintName = "?̈́͆͏̡͍̣̦̰?̟̹̤̤̭̮ͨ̃?̧̪̤͍̤̓ͅ?̴͇̖̣̪̘̠͌̐̓ͭͦ̒ͬ̀?͈̳̙̖͙͍̠̞̝̉̂ͭ͋ͤ?̲ͦ̃̈́̍ͦͮͬ ̷̢̣̭̭͉̳̘ͯ̆͂ͦ̆ͮ̽̕P̣͕̫͓̱̪̭̣̎́̇ͯ̍̑͝rͭ̌ͫͩ͂͗̋͏͖̬͎i̧̡̠̖ͯ̔͋n̦̳̪͇͖ͤ̔̌ͩ͐̍̀̕̕t͈̔͗ͮe̅ͦ̓̇̔ͯ҉̶̣̦̭̤̟͍͜ͅr̛̙̟̩͔̓̃ͤ̐̃ͣ"

ENT.FontColor = color_white
ENT.BackColor = color_black

ENT.IsValidRaidable = true

ENT.PresetMaxHealth = 2000
ENT.PowerRequired = 1


function ENT:Calc3D2DParams()

  local pos = self:GetPos()
  local ang = self:GetAngles()

  pos = pos + ang:Up() * (3.09 + (math.random() * math.random(-2, 2)))
  pos = pos + ang:Forward() * (-7.35 + (math.random() * math.random(-2, 3)))
  pos = pos + ang:Right() * (10.82 + (math.random() * math.random(-3, 2)))

  ang:RotateAroundAxis(ang:Up(), math.random(87, 93))

  return pos, ang, 0.1 / 2

end
