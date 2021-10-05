local ind = {l = false, r = false}
local UpalioSva = false

Citizen.CreateThread(function()
	while true do
		local Ped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
				local class = GetVehicleClass(PedCar)
				if class ~= 13 then
					-- Speed
					carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
					SendNUIMessage({
						showhud = true,
						speed = carSpeed
					})

					-- Lights
					_,feuPosition,feuRoute = GetVehicleLightsState(PedCar)
					if(feuPosition == 1 and feuRoute == 0) then
						SendNUIMessage({
							feuPosition = true
						})
					else
						SendNUIMessage({
							feuPosition = false
						})
					end
					if(feuPosition == 1 and feuRoute == 1) then
						SendNUIMessage({
							feuRoute = true
						})
					else
						SendNUIMessage({
							feuRoute = false
						})
					end
				end

				-- Turn signal
				-- SetVehicleIndicatorLights (1 left -- 0 right)
				local class = GetVehicleClass(PedCar)
				local VehIndicatorLight = GetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()))
				if class ~= 13 and class ~=14 and class ~= 15 and class ~= 16 then
					--local VehIndicatorLight = GetVehicleIndicatorLights(GetVehiclePedIsUsing(PlayerPedId()))
					if IsControlJustPressed(1, 107) then -- N4 is pressed
						if ind.r == true then
						ind.r = not ind.r
						--SetVehicleIndicatorLights(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1, ind.r)
						TriggerServerEvent('IndicatorR', ind.r)
						end
						ind.l = not ind.l
						--SetVehicleIndicatorLights(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0, ind.l)
						TriggerServerEvent('IndicatorL', ind.l)
					end
					if IsControlJustPressed(1, 108) then -- N6 is pressed
						if ind.l == true then
						ind.l = not ind.l
						--SetVehicleIndicatorLights(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0, ind.l)
						TriggerServerEvent('IndicatorL', ind.l)
						end
						ind.r = not ind.r
						--SetVehicleIndicatorLights(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1, ind.r)
						TriggerServerEvent('IndicatorR', ind.r)
					end
					if IsControlJustPressed(1, 110) then -- N5 is pressed
						if UpalioSva == false then
							ind.l = false
							TriggerServerEvent('IndicatorL', ind.l)
							ind.r = false
							TriggerServerEvent('IndicatorR', ind.r)
							Wait(500)
							ind.l = true
							TriggerServerEvent('IndicatorL', ind.l)
							ind.r = true
							TriggerServerEvent('IndicatorR', ind.r)
							UpalioSva = true
						else
							ind.l = false
							TriggerServerEvent('IndicatorL', ind.l)
							ind.r = false
							TriggerServerEvent('IndicatorR', ind.r)
							UpalioSva = false
						end
					end
				end

				if(VehIndicatorLight == 0) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 1) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 2) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = true,
					})
				elseif(VehIndicatorLight == 3) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = true,
					})
				end

			else
				SendNUIMessage({
					showhud = false
				})
			end
		else
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(1)
	end
end)

RegisterNetEvent('updateIndicators')
AddEventHandler('updateIndicators', function(PID, dir, Toggle)
	--if isPlayerOnline(PID) then
		local Veh = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(PID)), false)
		if dir == 'left' then
			SetVehicleIndicatorLights(Veh, 0, Toggle)
		elseif dir == 'right' then
			SetVehicleIndicatorLights(Veh, 1, Toggle)
		end
	--end
end)

-- Consume fuel factor
Citizen.CreateThread(function()
	while true do
		local Ped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				fuel = GetVehicleFuelLevel(PedCar)	
				SendNUIMessage({
					showfuel = true,
					fuel = fuel
				})
			end
		end

		Citizen.Wait(1)
	end
end)