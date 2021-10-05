ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

RegisterServerEvent('esx_zlica:dobijTuljana')
AddEventHandler('esx_zlica:dobijTuljana', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)	
	xPlayer.addMoney(math.floor(amount))
end)


