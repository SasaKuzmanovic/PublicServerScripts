-- Density values from 0.0 to 1.0.
local NemojGa = 0
DensityMultiplier = 0.1
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
		if NemojGa == 0 then
			SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetPedDensityMultiplierThisFrame(0.5)
			SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
			SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
		end
	end
end)

RegisterNetEvent('NPC:MakniNPC')
AddEventHandler('NPC:MakniNPC', function(br)
	NemojGa = br
end)

