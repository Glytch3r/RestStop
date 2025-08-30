
BunkerStaff = BunkerStaff or {}

function BunkerStaff.addMapSymbol()
    if not SandboxVars.BunkerStaff.AddMapSymbol  then return end
    local pl = getPlayer()
    if not pl then return end 

    if pl:getModData()['BunkerStaffTag'] == nil then
        local x, y, z =  BunkerStaff.parseCoords() 
        pl:getModData()['BunkerStaffTag'] = true
        if not x or not y then return end   

        if not ISWorldMap_instance then
            ISWorldMap.ShowWorldMap(0)
            ISWorldMap_instance:close()
        end

        local mapAPI = ISWorldMap_instance.javaObject:getAPIv1()
        local symAPI = mapAPI:getSymbolsAPI()
        if not BunkerStaffSym then
            BunkerStaffSym = symAPI:addTexture("Bunker", x, y)
        end        
        if BunkerStaffSym then
            BunkerStaffSym:setAnchor(0.5, 0.5)
            BunkerStaffSym:setRGBA(1,1,1, 1)
            BunkerStaffSym:setScale(1)
        end
    end
end

--[[ 
    BunkerStaff.addMapSymbol()
]]
