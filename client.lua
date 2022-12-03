local Promise = nil
local active = false

RegisterNUICallback('NUI:close', function(data, cb)
    Promise:resolve(data.success)
    Promise = nil
    active = false
    SetNuiFocus(false, false)
    cb('ok')
end)

local OpenHack = function(diff, time)
    active = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "start",
        diff = diff,
        time = time
    })
end

StartHack = function(diff, time)
    if diff ~= nil then
        local chance = math.random(1, 100)
        print(chance)
        if diff == 'easy' then
            if chance <= 33 then
                diff = 'numeric'
            elseif chance <= 66 and chance > 33 then
                diff = 'alphabet'
            else
                diff = 'alphanumeric'
            end
        elseif diff == 'medium' then
            if chance <= 3 then
                diff = 'alphabet'
            elseif chance <= 7 and chance > 3 then
                diff = 'alphanumeric'
            elseif chance <= 10 and chance > 7 then
                diff = 'numeric'
            elseif chance >= 11 then
                diff = 'greek'
            end
        elseif diff == 'hard' then
            if chance <= 3 then
                diff = 'alphanumeric'
            elseif chance <= 7 and chance > 3 then
                diff = 'greek'
            elseif chance <= 10 and chance > 7 then
                diff = 'runes'
            elseif chance >= 11 then
                diff = 'braille'
            end
        elseif diff == 'expert' then
            if chance <= 3 then
                diff = 'alphanumeric'
            elseif chance <= 7 and chance > 3 then
                diff = 'greek'
            elseif chance <= 25 and chance > 7 then
                diff = 'braille'
            elseif chance >= 25 then
                diff = 'runes'
            end
        end
    else
        local chance = math.random(1, 100)
        if chance <= 15 then
            diff = 'numeric'
        elseif chance <= 30 and chance > 15 then
            diff = 'alphabet'
        elseif chance <= 45 and chance > 30 then
            diff = 'alphanumeric'
        elseif chance <= 60 and chance > 45 then
            diff = 'braille'
        elseif chance <= 75 and chance > 60 then
            diff = 'greek'
        elseif chance <= 90 and chance > 75 then
            diff = 'braille'
        elseif chance >= 91 then
            diff = 'runes'
        end
    end
    if time == nil then time = 20 end

    if Promise then return end
    while active do Wait(0) end
    Promise = promise.new()
    OpenHack(diff, time)
    local result = Citizen.Await(Promise)
    return result
end

exports("StartHack", StartHack)

--[[
    diffs = easy, medium, hard, expert
    time = TIME SECONDS
]]

RegisterCommand('hacktest', function(source, args, raw) local this = StartHack() print(this) end)

