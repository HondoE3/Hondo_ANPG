local scannerActive = false
local playerVehicle = nil

RegisterNetEvent('Hondo_ANPG:toggleScanner', function()
    scannerActive = not scannerActive
    if scannerActive then
        playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false) 
        lib.notify({
            type = 'inform',
            description = 'ANPG aktiveret!',
            position = 'top',
            duration = 5000
        })
        ScanForVehicles()
    else
        playerVehicle = nil
        lib.notify({
            type = 'inform',
            description = 'ANPG deaktiveret!',
            position = 'top',
            duration = 5000
        })
    end
end)

function ScanForVehicles()
    CreateThread(function()
        while scannerActive do
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local vehicles = GetGamePool('CVehicle')

            for _, vehicle in ipairs(vehicles) do
                if vehicle ~= playerVehicle then
                    local vehiclePos = GetEntityCoords(vehicle)
                    if #(playerPos - vehiclePos) <= 8.0 then
                        local plate = GetVehicleNumberPlateText(vehicle):gsub("%s+", ""):upper()

                        TriggerServerEvent('Hondo_ANPG:checkAndCachePlate', plate)
                    end
                end
            end
            Wait(2000) 
        end
    end)
end

RegisterNetEvent('Hondo_ANPG:notifyWantedVehicle', function(plate)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)

    lib.notify({
        type = 'warning',
        description = plate .. ' - Er efterlyst.',
        position = 'top',
        duration = 10000
    })
end)