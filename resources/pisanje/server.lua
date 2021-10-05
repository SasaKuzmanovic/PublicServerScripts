ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('pisanje:sync')
AddEventHandler('pisanje:sync', function(player, need, gender)
    TriggerClientEvent('pisanje:syncCL', -1, player, need, gender)
end)

RegisterServerEvent('pisanje:add')
AddEventHandler('pisanje:add', function(need, amount)
    local src = tonumber(source)
    TriggerClientEvent('esx_status:add', src, need, amount)
end)
