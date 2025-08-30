
BunkerStaff = BunkerStaff or {}

function BunkerStaff.forceSleep(pl, wakeHr)
    pl = pl or getPlayer()
    if not pl or not pl:isAlive() then return end
    local plNum = pl:getPlayerNum() or 0

    pl:setVariable("ExerciseStarted", false)
    pl:setVariable("ExerciseEnded", true)
    pl:setForceWakeUpTime(wakeHr)
    pl:setAsleepTime(0.0)
    pl:setAsleep(true)
    getSleepingEvent():setPlayerFallAsleep(pl, wakeHr)

    UIManager.setFadeBeforeUI(plNum, true)
    UIManager.FadeOut(plNum, 1)

    if IsoPlayer.allPlayersAsleep() then
        UIManager.getSpeedControls():SetCurrentGameSpeed(3)
        save(true)
    end

    if JoypadState.players[plNum + 1] then
        setJoypadFocus(plNum, nil)
    end
end

function BunkerStaff.forceInstantSleep(pl, hours)
    pl = pl or getPlayer()
    if not pl or not pl:isAlive() then return end

    hours = hours or 168 
    local gTime = GameTime:getInstance()
    local curDay   = gTime:getDay()
    local curMonth = gTime:getMonth()
    local curYear  = gTime:getYear()
    local curTOD   = gTime:getTimeOfDay()

    local addDays  = math.floor(hours / 24)
    local addHours = hours % 24
    local newTOD = curTOD + addHours
    if newTOD >= 24 then
        newTOD = newTOD - 24
        addDays = addDays + 1
    end

    local newDay   = curDay + addDays
    local newMonth = curMonth
    local newYear  = curYear
    while newDay >= gTime:daysInMonth(newYear, newMonth) do
        newDay = newDay - gTime:daysInMonth(newYear, newMonth)
        newMonth = newMonth + 1
        if newMonth >= 12 then
            newMonth = 0
            newYear = newYear + 1
        end
    end

    if curYear ~= newYear then gTime:setYear(newYear) end
    if curMonth ~= newMonth then gTime:setMonth(newMonth) end
    if curDay ~= newDay then gTime:setDay(newDay) end
    if curTOD ~= newTOD then gTime:setTimeOfDay(newTOD) end

    BunkerStaff.forceSleep(pl, newTOD)
    
    local isShowDate =  SandboxVars.BunkerStaff.dateMsg  or true
    if isShowDate then
        BunkerStaff.pause(1, function() 
            local months = {
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            }
            local monthName = months[month] or tostring(month)
            local msg = "Date: " .. tostring(year) .. "/" .. monthName .. "/" .. tostring(newDay)
            pl:setHaloNote(tostring(msg),255,250,255,900) 

        end)
    end

    pl:setAsleep(false)
    pl:setForceWakeUpTime(newTOD)

    local plNum = pl:getPlayerNum() or 0
    UIManager.setFadeBeforeUI(plNum, false)
    UIManager.FadeIn(plNum, 1)

end





function BunkerStaff.doSleep()
    local pl = getPlayer() 
    BunkerStaff.forceInstantSleep(pl, hours)
    BunkerStaff.pause(0.7, function() 
        BunkerStaff.doStats(pl) 
    end)
end

function BunkerStaff.doStats(pl)
    pl = pl or getPlayer()

    local pl = getPlayer() 
    if not pl then return end
    local stats = pl:getStats()
    local drunkAmt = SandboxVars.BunkerStaff.drunkAmt or 100 
    stats:setDrunkenness(math.min(200, stats:getDrunkenness() + drunkAmt))
    BunkerStaff.pause(1, function() 
        stats:setThirst(0.3)
        stats:setHunger(0.05)
        stats:setBoredom(0.0)
        stats:setUnhappyness(0.0)
        stats:setFatigue(0.0)
    end)

--[[ 
    local bd = pl:getBodyDamage()
    local bodyParts = bd:getBodyParts()
    for i = bodyParts:size() - 1, 0, -1 do
        bd:setMuscleStrain(bodyParts:get(i):getType(), 0)
    end
 ]]
    local addWeight =  SandboxVars.BunkerStaff.addWeight  or 3
    local weightLimit =  SandboxVars.BunkerStaff.weightLimit or 150


    local nutri = pl:getNutrition()
    nutri:setWeight(math.min(weightLimit, nutri:getWeight() + addWeight))
    if isClient() then nutri:syncWeight() end
    
end


-----------------------            ---------------------------