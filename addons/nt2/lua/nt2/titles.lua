AddCSLuaFile()

local tag = "titles"
local net_eidx_size = 16

local PLAYER = FindMetaTable("Player")

function PLAYER:GetCustomTitle()
	return self:GetNWString(tag .. "_title", "") or ""
end

if SERVER then
	util.AddNetworkString(tag .. "_titlechange")

	function PLAYER:SetCustomTitle(txt)
		local res = hook.Run("OnPlayerChangedTitle", self, txt)
		if res == false then return end

		self:SetPData(tag .. "_title", txt)
		self:SetNWString(tag .. "_title", txt)

		net.Start(tag .. "_titlechange")
			net.WriteInt(self:EntIndex(), net_eidx_size)
			net.WriteString(txt)
		net.Broadcast()
	end

	net.Receive(tag .. "_titlechange", function(len, ply)
		local txt = net.ReadString()
		ply:SetCustomTitle(txt)
	end)

	if aowl and easylua then
		aowl.AddCommand({"title", "changetitle"}, function(caller, line, ply, txt)
			if not ply then
				ply = caller
				txt = ""
			end

			if ply ~= caller then
				local targ = easylua.FindEntity(ply)

				if IsValid(targ) then
					ply = targ
				else
					return false, aowl.TargetNotFound(ply)
				end
			end

			ply:SetCustomTitle(txt or "")
		end)
	end

	hook.Add("PlayerSpawn", tag, function(ply)
		ply:SetCustomTitle(ply:GetPData(tag .. "_title") or "")
	end)
else
	function PLAYER:SetCustomTitle(txt)
		assert(self == LocalPlayer(), "SetCustomTitle: Attempt to change non-localplayer customtitle on client")

		net.Start(tag .. "_titlechange")
			net.WriteString(txt)
		net.SendToServer()
	end

	net.Receive(tag .. "_titlechange", function()
		local plyID = net.ReadInt(net_eidx_size)
		local ply = Entity(plyID)

		if not (IsValid(ply) and ply:IsPlayer()) then return end

		local txt = net.ReadString()
		ply.CustomTitle = txt

		hook.Run("OnPlayerChangedTitle", ply, txt)
	end)
end
