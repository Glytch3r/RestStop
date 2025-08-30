

----------------------------------------------------------------
-----  ▄▄▄   ▄    ▄   ▄  ▄▄▄▄▄   ▄▄▄   ▄   ▄   ▄▄▄    ▄▄▄  -----
----- █   ▀  █    █▄▄▄█    █    █   ▀  █▄▄▄█  ▀  ▄█  █ ▄▄▀ -----
----- █  ▀█  █      █      █    █   ▄  █   █  ▄   █  █   █ -----
-----  ▀▀▀▀  ▀▀▀▀   ▀      ▀     ▀▀▀   ▀   ▀   ▀▀▀   ▀   ▀ -----
----------------------------------------------------------------
--                                                            --
--   Project Zomboid Modding Commissions                      --
--   https://steamcommunity.com/id/glytch3r/myworkshopfiles   --
--                                                            --
--   ▫ Discord  ꞉   glytch3r                                  --
--   ▫ Support  ꞉   https://ko-fi.com/glytch3r                --
--   ▫ Youtube  ꞉   https://www.youtube.com/@glytch3r         --
--   ▫ Github   ꞉   https://github.com/Glytch3r               --
--                                                            --
----------------------------------------------------------------
----- ▄   ▄   ▄▄▄   ▄   ▄   ▄▄▄     ▄      ▄   ▄▄▄▄  ▄▄▄▄  -----
----- █   █  █   ▀  █   █  ▀   █    █      █      █  █▄  █ -----
----- ▄▀▀ █  █▀  ▄  █▀▀▀█  ▄   █    █    █▀▀▀█    █  ▄   █ -----
-----  ▀▀▀    ▀▀▀   ▀   ▀   ▀▀▀   ▀▀▀▀▀  ▀   ▀    ▀   ▀▀▀  -----
----------------------------------------------------------------

BunkerStaff = BunkerStaff or {}
-----------------------        core*       ---------------------------

BunkerStaff.ticks = 0
local defaultCount = SandboxVars.BunkerStaff.ActionChangeDelay or 20
local TickTrigger = 60
BunkerStaff.count = defaultCount
-----------------------            ---------------------------


function BunkerStaff.coreFunc(zed)
	local pl = getPlayer() 
	BunkerStaff.ticks = BunkerStaff.ticks + 1
	if BunkerStaff.isNPCZed(zed) then
		BunkerStaff.syncNPC(zed)

		if BunkerStaff.isOnBaseTile(zed) and pl then
			if pl:DistTo(zed:getX(), zed:getY()) <= 5 then
				zed:faceLocation(pl:getX(), pl:getY());
			else
				if BunkerStaff.ticks > TickTrigger then
					if BunkerStaff.count <= 1 then
						BunkerStaff.count = defaultCount
						--BunkerStaff.doRandActions(zed)
						if ZombRand(0,3)==2 then
							BunkerStaff.setAction(zed)
						else
							if zed:getModData()['Interact'] == nil then
								zed:getModData()['Interact']  = true
								BunkerStaff.setRandomIdle(zed)
							else
								zed:getModData()['Interact']  = nil
								BunkerStaff.setRandomExt(zed)
							end
				
						end

					end
					BunkerStaff.ticks = 0
					BunkerStaff.count = BunkerStaff.count - 1
				end

			end
		end
		if zed:getVariableBoolean('isNPC') == false then
			zed:setVariable('isNPC', 'true')
	
		end
	elseif not BunkerStaff.isNPCZed(zed)  then
		if zed:getVariableBoolean('isNPC') == true then
			zed:setVariable('isNPC', 'false');
			zed:setVariable('ActNPC', 'NPC_ActionReset');
		
		end
	end
end
Events.OnZombieUpdate.Remove(BunkerStaff.coreFunc)
Events.OnZombieUpdate.Add(BunkerStaff.coreFunc)




function BunkerStaff.syncNPC(zed)
	if not BunkerStaff.zed then
		zed:makeInactive(true);
		zed:clearAggroList()
		zed:setUseless(true)
		BunkerStaff.Humanize(zed)
		BunkerStaff.addNPCTag()
		BunkerStaff.zed = zed
	end
end

function BunkerStaff.isNPCZed(zed)
	return zed and zed:getOutfitName() and zed:getOutfitName() == "BunkerStaff"
end
-----------------------            ---------------------------

function BunkerStaff.isOnBaseTile(zed)
    local tx, ty, tz = BunkerStaff.parseCoords()
    local zx, zy, zz = round(zed:getX()), round(zed:getY()), zed:getZ()
    if not (zx and zy and zz) then return false end

    local sqDist = (zx - tx)^2 + (zy - ty)^2
    if sqDist <= 2 and tz == zz then
        zed:setCanWalk(false)
        return true
    else
        zed:setCanWalk(true)
        BunkerStaff.moveToXYZ(zed, tx, ty, tz)
        return false
    end
end


function BunkerStaff.hit(zed, pl, bodyPartType, wpn)
    local immortal = SandboxVars.BunkerStaff.immortal or true 
    if not immortal then return end
	if zed and BunkerStaff.isNPCZed(zed) then
		zed:setVariable("HitReaction", "HeadLeft")
		zed:setAvoidDamage(true)
		if BunkerStaff.WasHurt ~= nil then return end	
		BunkerStaff.sayMsg(zed, "hurt")		
		BunkerStaff.WasHurt = true

		BunkerStaff.pause(10, function()
			BunkerStaff.WasHurt = false
		end)

	end
end
Events.OnHitZombie.Remove(BunkerStaff.hit)
Events.OnHitZombie.Add(BunkerStaff.hit)
-----------------------            ---------------------------


function BunkerStaff.isCloseToBase(base, zed)
	if base and zed then
		if math.floor(IsoUtils.DistanceTo(base:getX(), base:getY(), zed:getX(), zed:getY())) <= 1.5 then
			return true
		end
	end
	return false
end

function BunkerStaff.isIdleNPC(zed)
	local act = string.lower(tostring(zed:getVariableString('ActNPC')))

	if string.find(act, "idle") ~= nil then
		return true
	end
	return false
end

function BunkerStaff.doRandActions(zed)
	if BunkerStaff.isNPCZed(zed) and not BunkerStaff.isBusy(zed) then
		if isDebugEnabled() then print('setAction') end
		zed:setCanWalk(false)

		if SandboxVars.BunkerStaff.ActiveTransition then
			BunkerStaff.setAction(zed)
		else
			BunkerStaff.setRandomExt(zed)
		end
	end
end



--[[ 

function BunkerStaff.syncNPC(zed)
	if not zed:isUseless() then
		zed:makeInactive(true);
		zed:clearAggroList()
		zed:setUseless(true)
		BunkerStaff.Humanize(zed)
		if BunkerStaff.zed == nil then
			BunkerStaff.zed = zed
		end
	end	
end

function BunkerStaff.isNPCZed(zed)	
	if zed then  
		if not zed:isAlive() and BunkerStaff.zed == zed then
			BunkerStaff.zed = nil			
		end
		if BunkerStaff.zed and BunkerStaff.zed ~= zed and BunkerStaff.zed:isAlive() then
			BunkerStaff.zed:removeFromWorld()
			BunkerStaff.zed:removeFromSquare()
			BunkerStaff.zed = nil
			BunkerStaff.zed = zed 
		end

		local isNPCZed = zed:getOutfitName() and zed:getOutfitName() == "BunkerStaff"
		if isNPCZed then
			if BunkerStaff.zed == nil  or (BunkerStaff.zed ~= zed and not BunkerStaff.zed:isAlive())  then
				BunkerStaff.zed = zed
			end
		end
	end
end ]]
-----------------------            ---------------------------

-----------------------            ---------------------------

  --[[   if not zed then return false end
    local outfit = zed:getOutfitName()
    return outfit ~= nil and outfit == "BunkerStaff" ]]


-----------------------      end*         ---------------------------
--[[
print(debugZed:getVariableBoolean('bPathfind'))
print(debugZed:getVariableBoolean('bMoving'))
print(debugZed:isCanWalk())

]]

-----------------------       set*        ---------------------------
function BunkerStaff.setNPC(zed, bool)
	if bool == nil or bool == true then
		zed:setVariable('isNPC', 'true')
		zed:dressInNamedOutfit("BunkerStaff")
		BunkerStaff.syncNPC(zed)
	elseif bool == false then
		zed:changeState(ZombieOnGroundState.instance())
		zed:setAttackedBy(getCell():getFakeZombieForHit())
		zed:becomeCorpse()
	end
	if isDebugEnabled() then getPlayer():Say(tostring(zed:getOutfitName()))  end
	zed:resetModelNextFrame()
end



