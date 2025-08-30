 BunkerStaff = BunkerStaff or {}



BunkerStaff._tags = {}
function BunkerStaff.addSqStr(str, x, y, z, r, g, b, font, xOffset, yOffset, visibility)
    if not isIngameState() then return nil end

    if x == nil or y == nil or z == nil then
        local player = getPlayer()
        if not player then return nil end
        local sq = player:getSquare()
        if not sq then return nil end
        x, y, z = sq:getX(), sq:getY(), sq:getZ()
    end

    r, g, b = r or 1, g or 1, b or 1
    font = font or UIFont.NewLarge
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    visibility = visibility or 360

    local tag = TextDrawObject.new()
    tag:setDefaultFont(font)
    tag:ReadString(font, tostring(str), -1)
    tag:setDefaultColors(r, g, b)
    tag:setVisibleRadius(visibility)

    BunkerStaff._tags[tag] = {
        x = x, y = y, z = z,
        r = r, g = g, b = b,
        xOffset = xOffset, yOffset = yOffset
    }
    return tag
end


function BunkerStaff.delTagObj(tagObj)
    if BunkerStaff._tags[tagObj] then
        BunkerStaff._tags[tagObj] = nil
        return true
    end
    return false
end

function BunkerStaff.delSqStr(x, y, z)
    for tag, data in pairs(BunkerStaff._tags) do
        if data.x == x and data.y == y and data.z == z then
            BunkerStaff._tags[tag] = nil
            return true
        end
    end
    return false
end

function BunkerStaff.getSqStr(x, y, z)
    for tag, data in pairs(BunkerStaff._tags) do
        if data.x == x and data.y == y and data.z == z then
            return tag
        end
    end
    return nil
end

function BunkerStaff.tags()
    return BunkerStaff._tags
end

function BunkerStaff.clearAllTags()
    for tag in pairs(BunkerStaff._tags) do
        BunkerStaff._tags[tag] = nil
    end
end

function BunkerStaff.renderAllTags()
    if not isIngameState() then return end
    local zoom = getCore():getZoom(0)
    for tag, data in pairs(BunkerStaff._tags) do
        local screenX = (IsoUtils.XToScreen(data.x + data.xOffset, data.y, data.z, 0) - IsoCamera.getOffX()) / zoom 
        local screenY = (IsoUtils.YToScreen(data.x + data.yOffset, data.y, data.z, 0) - IsoCamera.getOffY()) / zoom
        tag:AddBatchedDraw(screenX, screenY, data.r, data.g, data.b, 1, false)
    end
end
Events.OnPostRender.Remove(BunkerStaff.renderAllTags)
Events.OnPostRender.Add(BunkerStaff.renderAllTags)

-----------------------            ---------------------------

function BunkerStaff.addNPCTag()
    
    if BunkerStaff.tag == nil then
        local x, y, z = BunkerStaff.parseCoords()
        BunkerStaff.tag = BunkerStaff.addSqStr("Lola Lollypop", x, y, z)
    end
end

function BunkerStaff.addSqMsg(msg, sq)
    if not sq then sq = getPlayer():getSquare() end
    return BunkerStaff.addSqStr(msg, sq:getX(), sq:getY(), sq:getZ())
end

function BunkerStaff.updateSqStr(x, y, z, newStr, font)
    local tag = BunkerStaff.getSqStr(x, y, z)
    if not tag then return false end
    font = font or UIFont.NewLarge
    tag:ReadString(font, tostring(newStr), -1)
    return true
end

function BunkerStaff.updateSqMsg(sq, newStr, font)
    if not sq then return false end
    return BunkerStaff.updateSqStr(sq:getX(), sq:getY(), sq:getZ(), newStr, font)
end
