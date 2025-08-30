
BunkerStaff = BunkerStaff or {}

function BunkerStaff.updateOpt()
    local sOpt = getSandboxOptions()
    sOpt:toLua()
    sOpt:sendToServer()
end
function BunkerStaff.setLocMarker(bool)    
    if bool then
        BunkerStaff.updateOpt()
    end
    local x, y, z = BunkerStaff.parseCoords()
    local sq = nil
    if x and y then
        sq = getCell():getOrCreateGridSquare(x, y, z) 
    end
    if bool then
        if sq then
            BunkerStaff.marker  = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", sq, 1, 0, 0, true, 0.75);
        end
    else
        if BunkerStaff.marker ~= nil then
            BunkerStaff.marker:remove()
            BunkerStaff.marker = nil
        end
    end	
    return BunkerStaff.marker or nil
end

-----------------------            ---------------------------
function BunkerStaff.addTempMarker(bool)    
    if bool then
        BunkerStaff.updateOpt()
    end
    local x, y, z = BunkerStaff.parseCoords()
    local sq = getCell():getOrCreateGridSquare(x, y, z) 
	if sq then
		local mark  = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", sq, 1, 0, 0, true, 0.75);
		timer:Simple(6, function()
			mark:remove()
			mark = nil
		end)
		local mark2  = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", sq, 1, 0.5, 0.5, true, 0.75);
		timer:Simple(4, function()
			mark2:remove()
			mark2 = nil
		end)
		local mark3  = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", sq, 1, 1, 1, true, 0.75);
		timer:Simple(2, function()
			mark3:remove()
			mark3 = nil
		end)
	end
end
-----------------------            ---------------------------
--[[ 
    BunkerStaff.dbg(true)
]]
function BunkerStaff.dbg(bool)
    if BunkerStaff.marker then
        BunkerStaff.marker:remove(); BunkerStaff.marker = nil
        print("removed: BunkerStaff.marker")
    end
    if BunkerStaff.pointer then
        BunkerStaff.pointer:remove(); BunkerStaff.pointer = nil
        print( "removed: BunkerStaff.pointer")
    end
    if bool then
        local pl = getPlayer() 
        local x, y, z = BunkerStaff.parseCoords()--9950, 12630, 0
        local sq = getCell():getOrCreateGridSquare(x, y, z) 
        local col = {r=1, g=0.1, b=0.5}
        BunkerStaff.pointer = getWorldMarkers():addPlayerHomingPoint(pl, sq:getX(), sq:getY(), "arrow_big", col.r, col.g, col.b, 0.6, true, 20);
        BunkerStaff.marker = getWorldMarkers():addGridSquareMarker("circle_center", "circle_only_highlight", sq, col.r, col.g, col.b, true, 1);
    end
end

--[[ 
    BunkerStaff.dbg(true)
 ]]

function BunkerStaff.printCoords()
    local x, y, z = BunkerStaff.parseCoords()
    print(round(x))
    print(round(y))
    print(z)
end

function BunkerStaff.tp2()
    local x, y, z = 9961, 12613, 0
    print(x) 
    print(y)
    print(z)
    getPlayer():teleportTo(tonumber(x), tonumber(y), tonumber(z))
end
--BunkerStaff.tp2()

function BunkerStaff.tp()
    local x, y, z = BunkerStaff.parseCoords()
    print(x) 
    print(y)
    print(z)
    getPlayer():teleportTo(tonumber(x), tonumber(y), tonumber(z))
end

--[[ 
BunkerStaff.printCoords()
 ]]
-----------------------            ---------------------------
function BunkerStaff.see(bool)
    BunkerStaff.isCoordsView=bool
    if bool then
        Events.OnPlayerUpdate.Add(BunkerStaff.coordsView)
    end
end
function BunkerStaff.coordsView(pl)
    if BunkerStaff.isCoordsView then
        local x, y, z = round(pl:getX()),  round(pl:getY()),  pl:getZ()
        pl:setHaloNote(round(x).. "  "..round(y).."  "..round(z) ,150,250,150,100) 
    else
        Events.OnPlayerUpdate.Remove(BunkerStaff.coordsView)
    end
end
--[[ 
BunkerStaff.see(true)
BunkerStaff.see(false) 
]]
