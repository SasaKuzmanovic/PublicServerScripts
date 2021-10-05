ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("NaplatiTuljana")
AddEventHandler("NaplatiTuljana", function(chargeAmount)
     local xPlayer        = ESX.GetPlayerFromId(source)
     xPlayer.removeMoney(chargeAmount)
     CancelEvent()
end)

RegisterServerEvent("devDajTuljanuRePa")
AddEventHandler("devDajTuljanuRePa", function(devAddAmount)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		user.addMoney(devAddAmount)
		CancelEvent()
	end)
end)