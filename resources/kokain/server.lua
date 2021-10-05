

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent("KCoke:get")
AddEventHandler("KCoke:get", function()
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
		
				if xPlayer.getInventoryItem('coke').count <= 20 then
					xPlayer.addInventoryItem("coke", math.random(1,2))
					else
					TriggerClientEvent('esx:showNotification', source, '~r~Ne mozete imati vise listova koke')
				end

			
end)




ESX.RegisterServerCallback('KCoke:process', function (source, cb)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
			
				if xPlayer.getInventoryItem('coke').count >= 2 then
					xPlayer.removeInventoryItem('coke', 2) 
					xPlayer.addInventoryItem('cocaine', 1) 
					cb(true)
				else
				TriggerClientEvent('esx:showNotification', source, '~r~Nemate dosta listova')
				cb(false)
				end
			

end)



