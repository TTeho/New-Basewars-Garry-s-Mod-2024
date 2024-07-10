local PLAYER = debug.getregistry().Player
local ENTITY = debug.getregistry().Entity

if CPPI then
	return
elseif SERVER then
	ErrorNoHalt("You need a CPPI compliant prop protection addon installed! Do not complain about issues or errors!\nHere's the one we use: http://steamcommunity.com/sharedfiles/filedetails/?id=159298542\n")
end

CPPI                     = {}
CPPI.CPPI_DEFER          = 100100
CPPI.CPPI_NOTIMPLEMENTED = 7080

if SERVER then
	function ENTITY:CPPISetOwner(ply)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPISetOwnerUID(uid)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPICanTool(ply, tool)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPICanPhysgun(ply)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPICanPickup(ply)
		return CPPI.CPPI_NOTIMPLEMENTED
	end

	function ENTITY:CPPICanPunt(ply)
		return CPPI.CPPI_NOTIMPLEMENTED
	end
end

function CPPI:GetName()
	return "BaseWars"
end

function CPPI:GetVersion()
	return CPPI.CPPI_NOTIMPLEMENTED
end

function CPPI:GetInterfaceVersion()
	return CPPI.CPPI_NOTIMPLEMENTED
end

function CPPI:GetNameFromUID(uid)
	return CPPI.CPPI_NOTIMPLEMENTED
end

function PLAYER:CPPIGetFriends()
	return CPPI.CPPI_NOTIMPLEMENTED
end

function ENTITY:CPPIGetOwner()
	return NULL, CPPI.CPPI_NOTIMPLEMENTED
end
