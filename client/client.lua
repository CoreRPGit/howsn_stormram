local STORMRAM_PROP = `w_me_batteringram`
local STORMRAM_DICT = 'anim@batteringram'
local STORMRAM_CLIPS = {
    enter = 'breach_enter',
    loop = 'breach_loop',
    exit = 'breach_exit',
}
local STORMRAM_ENTER_EXIT_DURATION = 420
local STORMRAM_PROP_BONE = 28422 -- PH_R_Hand, model is pre-aligned to this bone with no offset
local STORMRAM_PROP_OFFSET = vector3(0.0, 0.0, 0.0)
local STORMRAM_PROP_ROTATION = vector3(0.0, 0.0, 0.0)

local function attachStormramProp(playerPed)
    lib.requestModel(STORMRAM_PROP)

    local coords = GetEntityCoords(playerPed)
    local prop = CreateObject(STORMRAM_PROP, coords.x, coords.y, coords.z, true, true, false)
    local boneIndex = GetPedBoneIndex(playerPed, STORMRAM_PROP_BONE)

    AttachEntityToEntity(prop, playerPed, boneIndex,
        STORMRAM_PROP_OFFSET.x, STORMRAM_PROP_OFFSET.y, STORMRAM_PROP_OFFSET.z,
        STORMRAM_PROP_ROTATION.x, STORMRAM_PROP_ROTATION.y, STORMRAM_PROP_ROTATION.z,
        true, true, false, true, 1, true)

    SetModelAsNoLongerNeeded(STORMRAM_PROP)

    return prop
end

local function playStormramAnim(playerPed)
    lib.requestAnimDict(STORMRAM_DICT)

    local prop = attachStormramProp(playerPed)

    TaskPlayAnim(playerPed, STORMRAM_DICT, STORMRAM_CLIPS.enter, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Wait(STORMRAM_ENTER_EXIT_DURATION)
    TaskPlayAnim(playerPed, STORMRAM_DICT, STORMRAM_CLIPS.loop, 8.0, -8.0, -1, 1, 0.0, false, false, false)

    return prop
end

local function stopStormramAnim(playerPed, prop)
    TaskPlayAnim(playerPed, STORMRAM_DICT, STORMRAM_CLIPS.exit, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Wait(STORMRAM_ENTER_EXIT_DURATION)
    ClearPedTasks(playerPed)

    if prop and DoesEntityExist(prop) then
        DeleteEntity(prop)
    end
end

local function canUseStormram(action)
    local ClosestDoor = exports.ox_doorlock:getClosestDoor()
    
    if not ClosestDoor then
        return false -- No door found
    end
    
    if action == 'useStormram' then
        return ClosestDoor.state == 1 -- Can use storm ram only if the door is locked (state 1)
    elseif action == 'closeDoor' then
        return ClosestDoor.state == 0 -- Can close the door only if it is unlocked (state 0)
    end
    
    return false -- Default case if action is unknown
end

CreateThread(function()
    exports.ox_target:addGlobalObject({
        {
            name = 'useStormram',
            label = locale('label_use_stormram'),
            icon = 'fas fa-user-lock',
            canInteract = function() 
                local ClosestDoor = exports.ox_doorlock:getClosestDoor()
                return ClosestDoor and canUseStormram('useStormram') and ClosestDoor.distance <= 2
            end,
            event = 'howsn_stormram:client:useStormram',
            items = 'police_stormram',
            anyItem = true,
            distance = 1
        },
        {
            name = 'closeDoor',
            label = locale('label_lock_door'),
            icon = 'fas fa-user-lock',
            canInteract = function() 
                local ClosestDoor = exports.ox_doorlock:getClosestDoor()
                return ClosestDoor and canUseStormram('closeDoor') and ClosestDoor.distance <= 2
            end,
            event = 'howsn_stormram:client:useStormram',
            items = 'police_stormram',
            anyItem = true,
            distance = 1
        }
    })
end)

RegisterNetEvent('howsn_stormram:client:useStormram', function(source)
    local PlayerData = exports.qbx_core:GetPlayerData()
    local ClosestDoor = exports.ox_doorlock:getClosestDoor()

    if PlayerData.job.name ~= 'police' then
        return exports.qbx_core:Notify(locale('error_no_permission'), 'error')
    end

    if ClosestDoor.distance > 2 then
        return exports.qbx_core:Notify(locale('error_no_doors_nearby'), 'error')
    end
    
    local coords = ClosestDoor.coords
    local entity = ClosestDoor.entity
    local playerPed = cache.ped

    TaskTurnPedToFaceCoord(playerPed, coords.x, coords.y, coords.z, 2000)
    Wait(500)

    if ClosestDoor.state == 0 then 
        if lib.progressBar({
            duration = 4000,
            label = locale('progress_locking_door'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
            anim = {
                scenario = 'PROP_HUMAN_PARKING_METER',
            },
        })

        then
            TriggerServerEvent('howsn_stormram:server:setState', ClosestDoor.id, 1)
        else
            exports.qbx_core:Notify(locale('cancelled'), 'error')
        end
    else
        local prop = playStormramAnim(playerPed)

        if lib.progressBar({
            duration = 4000,
            label = locale('progress_using_stormram'),
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
        })

        then
            local randomChance = math.random(1, 100)

            if randomChance <= 50 then
                TriggerServerEvent('howsn_stormram:server:setState', ClosestDoor.id, 0)
                exports.qbx_core:Notify(locale('door_opened'), 'error')
            else
                exports.qbx_core:Notify(locale('door_failed'), 'error')
            end
        else
            exports.qbx_core:Notify(locale('cancelled'), 'error')
        end

        stopStormramAnim(playerPed, prop)
    end
end)
