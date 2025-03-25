ESX = exports["es_extended"]:getSharedObject()

local cacheDuration = 250000 

ESX.RegisterCommand('togglescanner', 'user', function(xPlayer)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(xPlayer.source), false)
    if vehicle and vehicle ~= 0 then
        if Config.AllowedVehicles[GetEntityModel(vehicle)] then
            TriggerClientEvent('Hondo_ANPG:toggleScanner', xPlayer.source)
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {
                type = 'error',
                description = 'Dit køretøj har ikke ANPG udstyr.'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', xPlayer.source, {
            type = 'error',
            description = 'Du er ikke i et køretøj.'
        })
    end
end, false, { help = "Toggle ANPG system" })

RegisterNetEvent('Hondo_ANPG:checkAndCachePlate')
AddEventHandler('Hondo_ANPG:checkAndCachePlate', function(plate)
    local src = source
    plate = plate:gsub("%s+", ""):upper() 

    local cache = LoadResourceFile(GetCurrentResourceName(), 'cache.json') or "[]"
    local data = json.decode(cache)

    local currentTime = GetGameTimer()

    if data[plate] and currentTime < data[plate] then
        return 
    end

    MySQL.query('SELECT * FROM omik_polititablet_efterlysninger WHERE type = "vehicle" AND plate = ?', { plate }, function(result)
        if result and result[1] then

            TriggerClientEvent('Hondo_ANPG:notifyWantedVehicle', src, plate)

            data[plate] = currentTime + cacheDuration
            SaveResourceFile(GetCurrentResourceName(), 'cache.json', json.encode(data), -1)
        end
    end)
end)