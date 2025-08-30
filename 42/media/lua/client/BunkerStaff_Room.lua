
BunkerStaff = BunkerStaff or {}
BunkerStaff.inBunker = false
BunkerStaff.inBunkerRm = false
BunkerStaff.zed = nil

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

-----------------------     trigger*       ---------------------------
function BunkerStaff.trigger()
    local pl = getPlayer()
    if not pl then return end

    local csq = pl:getCurrentSquare()
    if not csq then return end

    local rm = csq:getRoom()
    if not rm then
        if BunkerStaff.inBunkerRm then
            triggerEvent("OnBunkerExit", pl, rm)
            BunkerStaff.inBunkerRm = false
        end
        return
    end

    local isBunker = (rm == BunkerStaff.getBunkerRm())

    if isBunker and not BunkerStaff.inBunkerRm then
        triggerEvent("OnBunkerEnter", pl, rm)
        BunkerStaff.inBunkerRm = true
    elseif not isBunker and BunkerStaff.inBunkerRm then
        triggerEvent("OnBunkerExit", pl, rm)
        BunkerStaff.inBunkerRm = false
    end
end

Events.OnPlayerMove.Remove(BunkerStaff.trigger)
Events.OnPlayerMove.Add(BunkerStaff.trigger)


-----------------------  events*          ---------------------------
--spawn*
--spawn*
function BunkerStaff.doSpawn(pl, rm)
    if not rm then return end

    -- find existing zed in room
    local existing = BunkerStaff.getBunkerStaff(rm)

    if existing then
        BunkerStaff.zed = existing
    else
        -- spawn fresh
        BunkerStaff.zed = BunkerStaff.spawnZed()
    end

    -- if we now have a zed, process it
    if BunkerStaff.zed then
        BunkerStaff.Humanize(BunkerStaff.zed)
        BunkerStaff.addNPCTag()
        BunkerStaff.addMapSymbol()
        if BunkerStaff.marker == nil then
            BunkerStaff.setLocMarker(true)
        end
        BunkerStaff.sayMsg(BunkerStaff.zed)
        if getCore():getDebug() then
            print("BunkerStaff active in " .. tostring(rm))
        end
    end
end

--despawn*
function BunkerStaff.doDespawn(pl, rm)
    if BunkerStaff.marker then
        BunkerStaff.setLocMarker(false)
    end

    if BunkerStaff.zed then
        if BunkerStaff.tag then
            BunkerStaff.delTagObj(BunkerStaff.tag)
        end
        BunkerStaff.zed:removeFromWorld()
        BunkerStaff.zed:removeFromSquare()
        BunkerStaff.zed = nil
        if getCore():getDebug() then
            print("BunkerStaff despawned from " .. tostring(rm))
        end
    end
end

Events.OnBunkerEnter.Add(BunkerStaff.doSpawn)
Events.OnBunkerExit.Add(BunkerStaff.doDespawn)


-----------------------     getzed*       ---------------------------

function BunkerStaff.getBunkerStaff(room)
    if BunkerStaff.inBunker then
        local sq = getPlayer():getSquare() 
        room = room or BunkerStaff.getRoom(sq)
        if not room then return nil end
        for x = room:getX(), room:getX2() do
            for y = room:getY(), room:getY2() do
                local sq = getCell():getGridSquare(x, y, room:getZ())
                if sq and sq:getRoom() == room then
                    local zeds = sq:getZombie()
                    if zeds then
                        for i = 0, zeds:size() - 1 do
                            local zed = zeds:get(i)
                            if zed and zed:getOutfitName() == "BunkerStaff" then
                                return zed
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end
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


function BunkerStaff.getRoom(sq)
    sq = sq or getPlayer():getCurrentSquare()
    return sq:getRoom() or nil
end

function BunkerStaff.getBldg(sq)
    sq = sq or getPlayer():getCurrentSquare()
    return sq:getBuilding() or nil
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













