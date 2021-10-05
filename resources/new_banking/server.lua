-- ================================================================================================--
-- ==                                VARIABLES - DO NOT EDIT                                     ==--
-- ================================================================================================--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('banka:predaj')
AddEventHandler('banka:predaj', function(amount)
    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
        TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
    else
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', tonumber(amount))
		ESX.SavePlayer(xPlayer, function() 
		end)
    end
end)

RegisterServerEvent('banka:podigni')
AddEventHandler('banka:podigni', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local base = 0
    amount = tonumber(amount)
    base = xPlayer.getAccount('bank').money
    if amount == nil or amount <= 0 or amount > base then
        TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
    else
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
		ESX.SavePlayer(xPlayer, function() 
		end)
    end
end)

RegisterNetEvent('bank:balance')
AddEventHandler('bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    balance = xPlayer.getAccount('bank').money
    TriggerClientEvent('currentbalance1', _source, balance)
end)

RegisterServerEvent('banka:prebaci')
AddEventHandler('banka:prebaci', function(to, amountt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local zPlayer = ESX.GetPlayerFromId(to)
    local balance = 0
    if zPlayer ~= nil then
        balance = xPlayer.getAccount('bank').money
        zbalance = zPlayer.getAccount('bank').money
        if tonumber(_source) == tonumber(to) then
            -- advanced notification with bank icon
            TriggerClientEvent('esx:showAdvancedNotification', _source, 'Banka',
                               'Transfer Novca',
                               'Ne mozete prebacit novac samom sebi!',
                               'CHAR_BANK_MAZE', 9)
        else
            if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=
                0 then
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banka', 'Transfer Novca',
                                   'Nemate dovoljno novca za transfer!',
                                   'CHAR_BANK_MAZE', 9)
            else
                xPlayer.removeAccountMoney('bank', tonumber(amountt))
                zPlayer.addAccountMoney('bank', tonumber(amountt))
                -- advanced notification with bank icon
                TriggerClientEvent('esx:showAdvancedNotification', _source,
                                   'Banka', 'Transfer Novca',
                                   'Prebacili ste ~r~$' .. amountt ..
                                       '~s~ osobi ~r~' .. to .. ' .',
                                   'CHAR_BANK_MAZE', 9)
                TriggerClientEvent('esx:showAdvancedNotification', to, 'Banka',
                                   'Transfer Novca', 'Primili ste ~r~$' ..
                                       amountt .. '~s~ od ~r~' .. _source ..
                                       ' .', 'CHAR_BANK_MAZE', 9)
            end

        end
    end

end)
