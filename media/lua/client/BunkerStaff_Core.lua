

require "lua_timers"
require "BunkerStaff_Functions"

BunkerStaff = BunkerStaff or {}
-----------------------        core*       ---------------------------

BunkerStaff.ticks = 0
local defaultCount = SandboxVars.BunkerStaff.ActionChangeDelay or 20
local TickTrigger = 60
BunkerStaff.count = defaultCount


function BunkerStaff.syncNPC(zed)
	if not zed:isUseless() then
		zed:makeInactive(true);
		zed:clearAggroList()
		zed:setUseless(true)
	end
end

function BunkerStaff.isNPCZed(zed)
	return zed and zed:getOutfitName() and zed:getOutfitName() == "BunkerStaff"
end


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
	--[[ 		if isClient() then
				sendClientCommand('NPC', 'isNPC', {isNPC = true, zedId = zed:getOnlineID(), ActNPC = zed:getVariableString("ActNPC")})
			end		 ]]		
		end
	elseif not BunkerStaff.isNPCZed(zed)  then
		if zed:getVariableBoolean('isNPC') == true then
			zed:setVariable('isNPC', 'false');
			zed:setVariable('ActNPC', 'NPC_ActionReset');
		--[[ 	if isClient() then
				sendClientCommand('NPC', 'isNPC', {isNPC = false, zedId = zed:getOnlineID(), ActNPC = zed:getVariableString("ActNPC")})
			end ]]
		end
	end
end
Events.OnZombieUpdate.Remove(BunkerStaff.coreFunc)
Events.OnZombieUpdate.Add(BunkerStaff.coreFunc)



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



