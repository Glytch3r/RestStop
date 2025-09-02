
BunkerStaff = BunkerStaff or {}

BunkerStaff.IgnorePlayer = nil

function BunkerStaff.getMsg(strList)
    local phrases = {}
    for str in string.gmatch(strList, "[^;]+") do
        table.insert(phrases, tostring(str))
    end
	local msg = tostring(phrases[ZombRand(1, #phrases + 1)])
	return msg
end

function BunkerStaff.sayMsg(zed, mode, msg)
    if not zed then return end

    if BunkerStaff.IgnorePlayer then return end

    local strList = SandboxVars.BunkerStaff.RandomStatements
    if mode == "hurt" then
        if BunkerStaff.WasHurt  then return end 
        strList = SandboxVars.BunkerStaff.HurtStatements
    elseif mode == "interact" then
        strList = SandboxVars.BunkerStaff.InteractStatements
    end

    if not msg or msg == '' then
        msg = BunkerStaff.getMsg(strList)
    end

    if not msg then return end

    zed:addLineChatElement(tostring(msg))
    BunkerStaff.IgnorePlayer= true

    BunkerStaff.pause(3, function()
        BunkerStaff.IgnorePlayer = nil
    end)
end
-----------------------            ---------------------------
