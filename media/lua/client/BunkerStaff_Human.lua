
--[[◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙
██░_____░███░_░███░_░███░_░█░_______░██░_____░██░_░████░_░██░_____░██░______░██ 
█░_░███░_░██░_░███░_░███░_░████░_░████░_░███░_░█░_░████░_░█░_████░_░█░_█████░_█
█░_░████████░_░███░_░███░_░████░_░████░_░███████░_░████░_░███████░_░█░_█████░_█
█░_░█░___░██░_░████░_____░█████░_░████░_░███████░________░████░__░███░______░██
█░_░███░_░██░_░██████░_░███████░_░████░_░███████░_░████░_░███████░_░█░_░████_░█
█░_░███░_░██░_░██████░_░███████░_░████░_░███░_░█░_░████░_░█░_████░_░█░_░████__█
██░_____░███░____░███░_░███████░_░█████░_____░██░_░████░_░██░_____░██░_░████__█
◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙◙--]]

--[[ ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
░░▓█████▓░░░▓████▓░░░▓█▓░░░░░░░▓█▓░░░░░▓█████▓░░▓█▓░░░░▓█▓░░▓█████▓░░▓█▓░░░░██░
░▓█▓░░░▓█▓░░▓█▓░░░░░░▓█▓░░░░░░░▓█▓░░░░▓█▓░░░▓█▓░▓█▓░░░░▓█▓░▓█░░░░▓█▓░▓█▓░░░░██░
░▓█▓░░░▓█▓░░▓█▓░░░░░░▓█▓░░░░░░░▓█▓░░░░▓█▓░░░░░░░▓█▓░░░░▓█▓░░░░░░░▓█▓░▓█▓░░░░█▓░
░▓█▓░▓███▓░░▓█▓░░░░▓█████▓░░░░░▓█▓░░░░▓█▓░░░░░░░▓████████▓░░░░▓██▓░░░▓██████▓░░
░▓█▓░░░░░░░░▓█▓░░░▓█▓░░░▓█▓░░░░▓█▓░░░░▓█▓░░░░░░░▓█▓░░░░▓█▓░░░░░░░▓█▓░▓█░░░░░▓█░
░▓█▓░░░▓█▓░░▓█▓░░░▓█▓░░░▓█▓░░░░▓█▓░░░░▓█▓░░░▓█▓░▓█▓░░░░▓█▓░▓█░░░░▓█▓░▓█░░░░░▓█░
░░▓█████▓░░░▓█▓░░░▓█▓░░░▓█▓░▓███████▓░░▓█████▓░░▓█▓░░░░▓█▓░░▓█████▓░░▓██████▓░░
■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ --]]


BunkerStaff = BunkerStaff or {}

BunkerStaff.SkinList_F = {
    ["F_ZedBody01_level1"] = "FemaleBody01",
    ["F_ZedBody01_level2"] = "FemaleBody02",
    ["F_ZedBody01_level3"] = "FemaleBody03",
    ["F_ZedBody01"] = "FemaleBody04",
    ["F_ZedBody02_level1"] = "FemaleBody05",
    ["F_ZedBody02_level2"] = "FemaleBody01",
    ["F_ZedBody02_level3"] = "FemaleBody02",
    ["F_ZedBody02"] = "FemaleBody03",
    ["F_ZedBody03_level1"] = "FemaleBody04",
    ["F_ZedBody03_level2"] = "FemaleBody05",
    ["F_ZedBody03_level3"] = "FemaleBody01",
    ["F_ZedBody03"] = "FemaleBody02",
    ["F_ZedBody04_level1"] = "FemaleBody03",
    ["F_ZedBody04_level2"] = "FemaleBody04",
    ["F_ZedBody04_level3"] = "FemaleBody05",
    ["F_ZedBody04"] = "FemaleBody01",
}

BunkerStaff.SkinList_M = {
    ["M_ZedBody01_level1"] = "MaleBody01",
    ["M_ZedBody01_level2"]= "MaleBody01a",
    ["M_ZedBody01_level3"] = "MaleBody02",
    ["M_ZedBody01"] = "MaleBody02a",
    ["M_ZedBody02_level1"] = "MaleBody03",
    ["M_ZedBody02_level2"]= "MaleBody03a",
    ["M_ZedBody02_level3"] = "MaleBody04",
    ["M_ZedBody02"]= "MaleBody04a",
    ["M_ZedBody03_level1"] = "MaleBody05",
    ["M_ZedBody03_level2"]= "MaleBody05a",
    ["M_ZedBody03_level3"] = "MaleBody01",
    ["M_ZedBody03"] = "MaleBody01a",
    ["M_ZedBody04_level1"] = "MaleBody02",
    ["M_ZedBody04_level2"] = "MaleBody02a",
    ["M_ZedBody04_level3"] = "MaleBody03",
    ["M_ZedBody04"] = "MaleBody03a",
}

function BunkerStaff.isZSkin(skin)
    return skin and skin:match("Zed") ~= nil
end
function BunkerStaff.getZSkin(zed)
    local vis = zed:getHumanVisual()
    local skin = nil
    if vis then
        skin = vis:getSkinTexture()
    end
    return skin
end

function BunkerStaff.doSkinColor(zed, vis)
    local changeSkin =  SandboxVars.BunkerStaff.changeSkin or true
    if changeSkin then
        vis:setSkinTextureName("FemaleBody05")
    end
    zed:resetModelNextFrame()
end

function BunkerStaff.Humanize(zed)
    if not zed  then return end

    local emitter = zed:getEmitter()
    if emitter then
        emitter:stopAll()
    end

    local vis = zed:getHumanVisual()
    if  vis then 
        vis:randomDirt()
        vis:removeBlood()
        for i = 0, BloodBodyPartType.MAX:index() - 1 do
            local part = BloodBodyPartType.FromIndex(i)
            vis:setBlood(part, 0)
            vis:setDirt(part, 0)
        end
        BunkerStaff.doSkinColor(zed, vis)
    end


    local iVis = zed:getItemVisuals()
    if iVis then
        for i = 0, iVis:size() - 1 do
            local item = iVis:get(i)
            if item then
                for j = 0, BloodBodyPartType.MAX:index() - 1 do
                    local part = BloodBodyPartType.FromIndex(j)
                    if item:getHole(part) ~= 0 then
                        item:removeHole(j)
                    end
                    item:setBlood(part, 0)
                    item:setDirt(part, 0)
                end
                item:setInventoryItem(nil)
            end
        end
    end
    local bVis = vis:getBodyVisuals()
    if bVis then
        for j = bVis:size() - 1, 0, -1 do
            local item = bVis:get(j)
            if item then
                local fType = item:getItemType()
                if luautils.stringStarts(fType, "Base.ZedDmg_") or luautils.stringStarts(fType, "Base.Wound_") or luautils.stringStarts(fType, "Base.Bandage_") then
                    vis:removeBodyVisualFromItemType(fType)
                end
            end
        end
    end
    zed:resetModelNextFrame()
    zed:resetModel()

end

function BunkerStaff.spawnZed()
    local zed = nil
    if not BunkerStaff.zed then
        local immortal = SandboxVars.BunkerStaff.immortal or true
        local x, y, z = BunkerStaff.parseCoords()
        zed = addZombiesInOutfit(x, y, z, 1, "BunkerStaff", 100, false, false, false, false, immortal, false, 2, false);

    end
    return zed
end


--[[ 
function BunkerStaff.wear(zed)
    if not zed or not instanceof(zed, "IsoZombie") then return end
    local inv = zed:getInventory()
    local vis = zed:getHumanVisual()
    local iVis = zed:getItemVisuals()
    if not inv or not vis or not iVis then return end

    local items = {
        "Base.BellyButton_RingSilver",
        "Base.Bra_Straps_FrillyBlack",
        "Base.Gloves_LongWomenGloves",
        "Base.HolsterAnkle",
        "Base.Shoes_Fancy",
        "Base.StockingsBlack",
        "Base.FrillyUnderpants_Black",
        "Base.Makeup_LipsBlack",
        "Base.Makeup_EyesShadowBlue",
    }

    for _, type in ipairs(items) do
        local item = InventoryItemFactory.CreateItem(type)
        if item then
            inv:AddItem(item)
            iVis:setItem(item)
        end
    end

    zed:resetModelNextFrame()
    zed:resetModel()
end
 ]]