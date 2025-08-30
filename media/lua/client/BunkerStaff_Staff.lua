
BunkerStaff = BunkerStaff or {}

--FemaleBody05
function BunkerStaff.spawnZed()
    if not BunkerStaff.zed then
        local immortal = SandboxVars.BunkerStaff.immortal or true
        local x, y, z = BunkerStaff.parseCoords()
        local zed = addZombiesInOutfit(x, y, z, 1, "BunkerStaff", 100, false, false, false, false, immortal, false, 2, false);
        BunkerStaff.zed = zed
        return zed
    end
    return nil
end
function BunkerStaff.isOnBaseTile(zed)
    local tx, ty, tz = BunkerStaff.parseCoords()
    local zx, zy, zz = round(zed:getX()), round(zed:getY()), zed:getZ()
    if zx and zy and zz then
        if math.abs(zx - tx) <= 1 and math.abs(zy - ty) <= 1 and tz == zz then
            zed:setCanWalk(false)
            return true
        else
            zed:setCanWalk(true)
            BunkerStaff.moveToXYZ(zed, tx, ty, tz)
        end
    end
end
function BunkerStaff.hit(zed, pl, bodyPartType, wpn)
    local immortal = SandboxVars.BunkerStaff.immortal or true 
    if not immortal then return end
	if zed and BunkerStaff.isNPCZed(zed) then
		zed:setVariable("HitReaction", "HeadLeft")
		zed:setAvoidDamage(true)
		if zed:getModData()['WasHurt'] ~= nil then return end	
		BunkerStaff.sayMsg(zed, "hurt")		
		zed:getModData()['WasHurt'] = true

		BunkerStaff.pause(10, function()
			zed:getModData()['WasHurt'] = nil
		end)

	end
end
Events.OnHitZombie.Remove(BunkerStaff.hit)
Events.OnHitZombie.Add(BunkerStaff.hit)
