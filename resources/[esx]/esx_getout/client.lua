ESX					= nil
local PlayerData	= {}
local group = 0
local Valja = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("esx_getout:DajAdmina")
end)

RegisterNetEvent('esx_getout:VratiAdmina')
AddEventHandler('esx_getout:VratiAdmina', function(g)
	if g == 1 then
		group = 1
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, false) and Valja == false then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			local vehicleClass = GetVehicleClass(vehicle)
			PlayerData = ESX.GetPlayerData()
			if vehicleClass == 19 then
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					if group ~= 1 then
						ClearPedTasksImmediately(ped)
						TaskLeaveVehicle(ped,vehicle,0)
						ESX.ShowNotification("Ne mozete voziti vojna vozila!")
					else
						Valja = true
					end
				end
			end
			if vehicleClass == 18 then
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					if PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'mechanic' and group ~= 1 then
						ClearPedTasksImmediately(ped)
						TaskLeaveVehicle(ped,vehicle,0)
						ESX.ShowNotification("Ne mozete voziti sluzbena vozila!")
					else
						Valja = true
					end
				end
			else
				Valja = true
			end
		else
			Valja = false
		end
	end
end)