ESX = nil

local TaCijena = 0
local GarazaV 				  = nil
local Vblip 				  = nil

PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)

        TriggerEvent("esx:getSharedObject", function(response)
            ESX = response
        end)
    end

    if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()

		RemoveVehicles()

		Citizen.Wait(500)

		LoadSellPlace()

		SpawnVehicles()
    end
end)

RegisterNetEvent('esx_property:ProsljediVozilo')
AddEventHandler('esx_property:ProsljediVozilo', function(voz, bl)
	if bl == nil then
		if DoesEntityExist(Vblip) then
			RemoveBlip(Vblip)
		end
	end
	GarazaV = voz
	Vblip = bl
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	PlayerData = response
	
	LoadSellPlace()

	SpawnVehicles()
end)

RegisterNetEvent("Pijaca:refreshVehicles")
AddEventHandler("Pijaca:refreshVehicles", function()
	RemoveVehicles()

	Citizen.Wait(500)

	SpawnVehicles()
end)

function LoadSellPlace()
	Citizen.CreateThread(function()

		local SellPos = Config.SellPosition

		local Blip = AddBlipForCoord(SellPos["x"], SellPos["y"], SellPos["z"])
		SetBlipSprite (Blip, 147)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 0.8)
		SetBlipColour (Blip, 52)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Rabljena vozila")
		EndTextCommandSetBlipName(Blip)

		while true do
			local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, SellPos["x"], SellPos["y"], SellPos["z"], true)

			if dstCheck <= 10.0 then
				sleepThread = 5

				if dstCheck <= 4.2 then
					ESX.Game.Utils.DrawText3D(SellPos, "[E] Otvorite izbornik", 0.4)
					if IsControlJustPressed(0, 38) then
						if IsPedInAnyVehicle(ped, false) then
							OpenSellMenu(GetVehiclePedIsUsing(ped))
						else
							ESX.ShowNotification("Morate sjediti u ~g~vozilu")
						end
					end
				end
			end

			for i = 1, #Config.VehiclePositions, 1 do
				if Config.VehiclePositions[i]["entityId"] ~= nil then
					local pedCoords = GetEntityCoords(ped)
					local vehCoords = GetEntityCoords(Config.VehiclePositions[i]["entityId"])

					local dstCheck = GetDistanceBetweenCoords(pedCoords, vehCoords, true)
					local propa = ESX.Game.GetVehicleProperties(Config.VehiclePositions[i]["entityId"])
					local cijenaa = 0

					if dstCheck <= 2.0 then
						sleepThread = 5
						TriggerServerEvent("Pijaca:Cijena", GetPlayerServerId(PlayerId()), propa.plate)
						cijenaa = TaCijena
						ESX.Game.Utils.DrawText3D(vehCoords, "[E] " .. cijenaa, 0.4)

						if IsControlJustPressed(0, 38) then
							if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
								OpenSellMenu(Config.VehiclePositions[i]["entityId"], cijenaa, true, Config.VehiclePositions[i]["owner"])
							else
								ESX.ShowNotification("Morate biti u ~g~vozilu~s~!")
							end
						end
					end
				end
			end

			Citizen.Wait(sleepThread)
		end
	end)
end

RegisterNetEvent("Pijaca:VCijena")
AddEventHandler("Pijaca:VCijena", function(cij)
	TaCijena = cij
end)

function OpenSellMenu(veh, price, buyVehicle, owner)
	local elements = {}

	if not buyVehicle then
		if price ~= nil then
			table.insert(elements, { ["label"] = "Promjenite cijenu - " .. price .. " :-", ["value"] = "price" })
			table.insert(elements, { ["label"] = "Stavite vozilo na prodaju", ["value"] = "sell" })
		else
			table.insert(elements, { ["label"] = "Postavite cijenu - :-", ["value"] = "price" })
		end
	else
		table.insert(elements, { ["label"] = "Kupi " .. price .. " - :-", ["value"] = "buy" })

		if owner then
			table.insert(elements, { ["label"] = "Maknite vozilo iz prodaje", ["value"] = "remove" })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Prodaja vozila",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		if action == "price" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_veh_price',
				{
					title = "Cijena vozila"
				},
			function(data2, menu2)

				local vehPrice = tonumber(data2.value)

				menu2.close()
				menu.close()

				OpenSellMenu(veh, vehPrice)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "sell" then
			local vehProps = ESX.Game.GetVehicleProperties(veh)

			ESX.TriggerServerCallback("Pijaca:isVehicleValid", function(valid)

				if valid then
					DeleteVehicle(veh)
					ESX.ShowNotification("Stavili ste ~g~vozilo~s~ na prodaju - " .. price .. " :-")
					menu.close()
				else
					ESX.ShowNotification("Morate biti ~r~vlasnik~s~ ovog ~g~vozila!~s~ ili je pijaca popunjena!")
				end
	
			end, vehProps, price)
		elseif action == "buy" then
			ESX.TriggerServerCallback("Pijaca:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					if GarazaV ~= nil and DoesEntityExist(GarazaV) then
						local prop = ESX.Game.GetVehicleProperties(GarazaV)
						local pla = prop.plate:gsub("^%s*(.-)%s*$", "%1")
						ESX.Game.DeleteVehicle(GarazaV)
						GarazaV = nil
						TriggerServerEvent("garaza:SpremiModel", pla, nil)
						if Vblip ~= nil then
							RemoveBlip(Vblip)
							Vblip = nil
						end
					end
					--SetEntityCoords(veh, -32.476375579834, -1691.947265625, 28.753887176514, 1, 0, 0, 0)
					--SetEntityHeading(veh, 204.4192352295)
					ESX.Streaming.RequestModel(GetEntityModel(veh))
					GarazaV = CreateVehicle(GetEntityModel(veh), -32.476375579834, -1691.947265625, 28.753887176514, 204.4192352295, true, false)
					local vehProps = ESX.Game.GetVehicleProperties(veh)
					ESX.Game.SetVehicleProperties(GarazaV, vehProps)
					SetVehRadioStation(GarazaV, "OFF")
					--TaskWarpPedIntoVehicle(GetPlayerPed(-1), GarazaV, -1)
					local plate = GetVehicleNumberPlateText(GarazaV)
					TriggerServerEvent("ls:mainCheck", plate, GarazaV, true)
					Vblip = AddBlipForEntity(GarazaV)
					SetBlipSprite (Vblip, 225)
					SetBlipDisplay(Vblip, 4)
					SetBlipScale  (Vblip, 1.0)
					SetBlipColour (Vblip, 30)
					SetBlipAsShortRange(Vblip, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Vase vozilo")
					EndTextCommandSetBlipName(Vblip)
					TriggerEvent("esx_property:ProsljediVozilo", GarazaV, Vblip)
					DeleteVehicle(veh)
					TriggerServerEvent("Pijaca:Refreshaj")
					ESX.ShowNotification("~g~Kupili~s~ ste vozilo za " .. price .. " :-")
					menu.close()
				else
					ESX.ShowNotification("Vi ~r~nemate~s~ dovoljno novca, fali vam " .. price - totalMoney .. " :-")
				end
			end, ESX.Game.GetVehicleProperties(veh), 1)
		elseif action == "remove" then
			ESX.TriggerServerCallback("Pijaca:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					local vehProps = ESX.Game.GetVehicleProperties(veh)
					ESX.Game.SpawnVehicle(GetEntityModel(veh),{
						x=-32.476375579834 ,
						y=-1691.947265625,
						z=28.753887176514											
						},204.4192352295, function(callback_vehicle)
						ESX.Game.SetVehicleProperties(callback_vehicle, vehProps)
						SetVehRadioStation(callback_vehicle, "OFF")
						--TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
						local plate = GetVehicleNumberPlateText(callback_vehicle)
						TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
					end)
					DeleteVehicle(veh)
					TriggerServerEvent("Pijaca:Refreshaj")
					ESX.ShowNotification("~g~Maknuli~s~ ste vozilo iz prodaje")
					menu.close()
				end
			end, ESX.Game.GetVehicleProperties(veh), 0)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

function RemoveVehicles()
	local VehPos = Config.VehiclePositions

	for i = 1, #VehPos, 1 do
		local veh, distance = ESX.Game.GetClosestVehicle(VehPos[i])

		if DoesEntityExist(veh) and distance <= 1.0 then
			DeleteEntity(veh)
		end
	end
end

function SpawnVehicles()
	local VehPos = Config.VehiclePositions

	ESX.TriggerServerCallback("Pijaca:retrieveVehicles", function(vehicles)
		for i = 1, #vehicles, 1 do

			local vehicleProps = vehicles[i]["vehProps"]

			LoadModel(vehicleProps["model"])

			VehPos[i]["entityId"] = CreateVehicle(vehicleProps["model"], VehPos[i]["x"], VehPos[i]["y"], VehPos[i]["z"] - 0.975, VehPos[i]["h"], false)
			VehPos[i]["price"] = vehicles[i]["price"]
			VehPos[i]["owner"] = vehicles[i]["owner"]

			ESX.Game.SetVehicleProperties(VehPos[i]["entityId"], vehicleProps)

			FreezeEntityPosition(VehPos[i]["entityId"], true)

			SetEntityAsMissionEntity(VehPos[i]["entityId"], true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
		end
	end)

end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)

		Citizen.Wait(1)
	end
end
