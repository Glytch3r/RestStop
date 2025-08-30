
BunkerStaff = BunkerStaff or {}
BunkerStaff.inBunker = false
BunkerStaff.inBunkerRm = false
BunkerStaff.zed = nil
BunkerStaff.isRestStop = false
-----            ---------------------------
LuaEventManager.AddEvent("OnBunkerEnter")
LuaEventManager.AddEvent("OnBunkerExit")
-----------------------       parse*     ---------------------------
function BunkerStaff.parseCoords()
    if BunkerStaff.coords then
        return BunkerStaff.coords[1], BunkerStaff.coords[2], BunkerStaff.coords[3]
    end

    local strList = SandboxVars.BunkerStaff.Coord or "9948;12631;-4"
    local tx, ty, tz = strList:match("^(-?%d+)[;:](-?%d+)[;:](-?%d+)")
    tx, ty, tz = tonumber(tx), tonumber(ty), tonumber(tz)

    BunkerStaff.coords = { tx, ty, tz }

    return tx, ty, tz
end
function BunkerStaff.parseColor()
    if BunkerStaff.RoomLight then
        return BunkerStaff.RoomLight[1], BunkerStaff.RoomLight[2], BunkerStaff.RoomLight[3], BunkerStaff.RoomLight[4] 
    end

    local strList = SandboxVars.BunkerStaff.RoomLight or "255;255;255;255"
    local r, g, b, a = strList:match("^(%d+);(%d+);(%d+);(%d+)$")
    r, g, b, a = tonumber(r), tonumber(g), tonumber(b), tonumber(a)

    BunkerStaff.RoomLight = { r, g, b, a }
    return r, g, b, a
end

-----------------------     trigger*       ---------------------------
function BunkerStaff.trigger()
    local pl = getPlayer()
    if not pl then return end
    local isBunker = BunkerStaff.isInBunkerRm()
    if BunkerStaff.isInBunkerBldg() then
        if not BunkerStaff.marker then
            BunkerStaff.setLocMarker(true)
        end
        if not isBunker and BunkerStaff.isRestStop then
            triggerEvent("OnBunkerExit", pl)
        elseif isBunker then 
            triggerEvent("OnBunkerEnter", pl)
            BunkerStaff.isRestStop = true
        end
    end
end
Events.OnPlayerMove.Remove(BunkerStaff.trigger)
Events.OnPlayerMove.Add(BunkerStaff.trigger)
-----------------------  events*          ---------------------------
--spawn
function BunkerStaff.doSpawn()
    if not BunkerStaff.zed then
        BunkerStaff.spawnZed()
    end
    Events.OnBunkerEnter.Remove(BunkerStaff.doSpawn)
end
Events.OnBunkerEnter.Add(BunkerStaff.doSpawn)



function BunkerStaff.greet()
    if BunkerStaff.zed then 
        BunkerStaff.sayMsg(BunkerStaff.zed)
    end 
    if not BunkerStaff.light then
        local x, y, z = BunkerStaff.parseCoords()
        local r, g, b, a = BunkerStaff.parseColor()
        if a <= 0 then return end
        BunkerStaff.light = getCell():addLamppost(IsoLightSource.new(x, y, z, math.min(255, r), math.min(255, g), math.min(255, b), math.min(255, a)))
    end
end
Events.OnBunkerEnter.Add(BunkerStaff.greet)



--despawn*
function BunkerStaff.doDespawn(pl)
    if BunkerStaff.light then
        getCell():removeLamppost(BunkerStaff.light)
    end
--[[     if BunkerStaff.zed then
        BunkerStaff.zed:removeFromWorld()
        BunkerStaff.zed:removeFromSquare()
        BunkerStaff.zed = nil
    end ]]
end
Events.OnBunkerExit.Add(BunkerStaff.doDespawn)

-----------------------    is*        ---------------------------

function BunkerStaff.isInBunkerBldg()    
    local plBldg = BunkerStaff.getBldg()
    if not plBldg then return false end

    local bunkerBldg = BunkerStaff.getBunkerBldg()
    if not bunkerBldg then return false end
    
    BunkerStaff.inBunker = plBldg == bunkerBldg 
    return BunkerStaff.inBunker
end 

function BunkerStaff.isInBunkerRm()
    local x, y, z = BunkerStaff.parseCoords()
    if not x or not y or not z then return false end
    
    local plRm = BunkerStaff.getRoom()
    if not plRm then return false end

    local bunkerRm = BunkerStaff.getBunkerRm()
    if not bunkerRm then return false end

    BunkerStaff.inBunkerRm = plRm == bunkerRm
    return BunkerStaff.inBunkerRm
end
-----------------------   get*        ---------------------------
function BunkerStaff.getBunkerBldg()
    local x, y, z = BunkerStaff.parseCoords()
    if not x or not y or not z then return nil end
    local sq = getCell():getOrCreateGridSquare(x, y, z)
    if sq then
        return sq:getBuilding()
    end
    return nil
end

function BunkerStaff.getBunkerRm()
    local x, y, z = BunkerStaff.parseCoords()
    if not x or not y or not z then return nil end
    local sq = getCell():getOrCreateGridSquare(x, y, z)
    if sq then
        return sq:getRoom()
    end
    return nil
end
-----------------------            ---------------------------

function BunkerStaff.getRoomSquares(room)
    if not room then return {} end
    local squares = {}
    for x = room:getX() , room:getX2() do
        for y = room:getY() , room:getY2() do
            local sq = getCell():getGridSquare(x, y, room:getZ())
            if sq and sq:getRoom() == room then
                table.insert(squares, sq)
            end
        end
    end
    return squares
end



-----------------------            ---------------------------



function BunkerStaff.getRoom(sq)
    sq = sq or getPlayer():getCurrentSquare()
    return sq:getRoom() or nil
end

function BunkerStaff.getBldg(sq)
    sq = sq or getPlayer():getCurrentSquare()
    return sq:getBuilding() or nil
end




--[[ 
function BunkerStaff.getBunkerBldg()
    local x, y, z = BunkerStaff.parseCoords()
    if not x or not y or not z then return nil end
    local sq = getCell():getOrCreateGridSquare(x, y, z)
    if sq then
        return sq:getBuilding()
    end
    return nil
end


function BunkerStaff.getBunkerRm()
    local x, y, z = BunkerStaff.parseCoords()
    if not x or not y or not z then return nil end
    local sq = getCell():getOrCreateGridSquare(x, y, z)
    if sq then
        return sq:getRoom()
    end
    return nil
end ]]








