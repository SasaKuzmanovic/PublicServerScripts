--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- Script serveur No Brain 
-- www.nobrain.org
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ESX = nil
local Objekti = {}
local Spawno = false
local Broj = 0
local Radis = false
local Farma = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ProvjeriPosao()
end)
--------------------------------------------------------------------------------
-- NE RIEN MODIFIER
--------------------------------------------------------------------------------
local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blipara				  = {}
local Blip = nil
--------------------------------------------------------------------------------
function ProvjeriPosao()
	PlayerData = ESX.GetPlayerData()
end
-- MENUS
function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'cloakroom',
		{
			title    = _U('cloakroom'),
			elements = {
				{label = _U('job_wear'), value = 'job_wear'},
				{label = _U('citizen_wear'), value = 'citizen_wear'}
			}
		},
		function(data, menu)
			if data.current.value == 'citizen_wear' then
				isInService = false
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
	    			TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
			if data.current.value == 'job_wear' then
				isInService = true
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
	    			if skin.sex == 0 then
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
	    				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end
				end)
			end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function MenuVehicleSpawner()
	local elements = {}

	for i=1, #Config.Trucks, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])), value = Config.Trucks[i]})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "tractor2" then
             local pozicija = math.random(1, #Config.Zones.VehicleSpawnPoint.Pos)
			 ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos[pozicija].coords, Config.Zones.VehicleSpawnPoint.Pos[pozicija].heading, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
				plaquevehicule = "WAL"..platenum			
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
				ESX.Game.SpawnLocalVehicle("raketrailer", Config.Zones.VehicleSpawnPoint.Pos[pozicija].coords, Config.Zones.VehicleSpawnPoint.Pos[pozicija].heading, function(trailer)
					AttachVehicleToTrailer(vehicle, trailer, 1.1)
				end)
			end)
			Radis = true
			SpawnObjekte()
		end

			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function SpawnObjekte()
		local njiva = math.random(4)
		Farma = njiva
		if njiva == 1 then
			for i=1, #Config.Objekti, 1 do
				ESX.Game.SpawnLocalObject('prop_grass_dry_02', {
						x = Config.Objekti[i].x,
						y = Config.Objekti[i].y,
						z = Config.Objekti[i].z
				}, function(obj)
				--PlaceObjectOnGroundProperly(obj)
				Objekti[i] = obj
				end)
				Blipara[i] = AddBlipForCoord(Config.Objekti[i].x,  Config.Objekti[i].y,  Config.Objekti[i].z)
				SetBlipSprite (Blipara[i], 1)
				SetBlipDisplay(Blipara[i], 8)
				SetBlipColour (Blipara[i], 2)
				SetBlipScale  (Blipara[i], 1.4)
			end
			Broj = #Config.Objekti
		elseif njiva == 2 then
			for i=1, #Config.Objekti2, 1 do
				ESX.Game.SpawnLocalObject('prop_grass_dry_02', {
						x = Config.Objekti2[i].x,
						y = Config.Objekti2[i].y,
						z = Config.Objekti2[i].z
				}, function(obj)
				--PlaceObjectOnGroundProperly(obj)
				Objekti[i] = obj
				end)
				Blipara[i] = AddBlipForCoord(Config.Objekti2[i].x,  Config.Objekti2[i].y,  Config.Objekti2[i].z)
				SetBlipSprite (Blipara[i], 1)
				SetBlipDisplay(Blipara[i], 8)
				SetBlipColour (Blipara[i], 2)
				SetBlipScale  (Blipara[i], 1.4)
			end
			Broj = #Config.Objekti2
		elseif njiva == 3 then
			for i=1, #Config.Objekti3, 1 do
				ESX.Game.SpawnLocalObject('prop_grass_dry_02', {
						x = Config.Objekti3[i].x,
						y = Config.Objekti3[i].y,
						z = Config.Objekti3[i].z
				}, function(obj)
				--PlaceObjectOnGroundProperly(obj)
				Objekti[i] = obj
				end)
				Blipara[i] = AddBlipForCoord(Config.Objekti3[i].x,  Config.Objekti3[i].y,  Config.Objekti3[i].z)
				SetBlipSprite (Blipara[i], 1)
				SetBlipDisplay(Blipara[i], 8)
				SetBlipColour (Blipara[i], 2)
				SetBlipScale  (Blipara[i], 1.4)
			end
			Broj = #Config.Objekti3
		elseif njiva == 4 then
			for i=1, #Config.Objekti4, 1 do
				ESX.Game.SpawnLocalObject('prop_grass_dry_02', {
						x = Config.Objekti4[i].x,
						y = Config.Objekti4[i].y,
						z = Config.Objekti4[i].z
				}, function(obj)
				--PlaceObjectOnGroundProperly(obj)
				Objekti[i] = obj
				end)
				Blipara[i] = AddBlipForCoord(Config.Objekti4[i].x,  Config.Objekti4[i].y,  Config.Objekti4[i].z)
				SetBlipSprite (Blipara[i], 1)
				SetBlipDisplay(Blipara[i], 8)
				SetBlipColour (Blipara[i], 2)
				SetBlipScale  (Blipara[i], 1.4)
			end
			Broj = #Config.Objekti4
		end
		Spawno = true
		ESX.ShowNotification("Preorite njivu!")
end

function IsATruck()
	local isATruck = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Trucks, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Trucks[i]) then
			isATruck = true
			break
		end
	end
	return isATruck
end

function IsJobKosac()
	if ESX.PlayerData.job ~= nil then
		local kosac = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'farmer' then
			kosac = true
		end
		return kosac
	end
end

AddEventHandler('esx_farmer:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobKosac() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobKosac() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

function ZavrsiPosao()
	if Farma == 1 then
		for i=1, #Config.Objekti, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
	elseif Farma == 2 then
		for i=1, #Config.Objekti2, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
	elseif Farma == 3 then
		for i=1, #Config.Objekti3, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
	elseif Farma == 4 then
		for i=1, #Config.Objekti4, 1 do
			if Objekti[i] ~= nil then
				ESX.Game.DeleteObject(Objekti[i])
				if DoesBlipExist(Blipara[i]) then
					RemoveBlip(Blipara[i])
				end
			end
		end
	end
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end
	Broj = 0
	Farma = 0
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	if vehicle ~= nil and tablica == plaquevehicule then
		local retval, vehicle2 = GetVehicleTrailerVehicle(vehicle)
		ESX.Game.DeleteVehicle(vehicle)
		ESX.Game.DeleteVehicle(vehicle2)
	end
	Radis = false
	Spawno = false
end

AddEventHandler('esx_farmer:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
		if Spawno == true and Broj > 0 then
			local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			if tablica == plaquevehicule then
				local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_grass_dry_02")
				if Farma == 1 then
					for i=1, #Config.Objekti, 1 do
						if Objekti[i] == NewBin then
							if NewBinDistance <= 2 then
								Wait(600)
								ESX.Game.DeleteObject(Objekti[i])
								if DoesBlipExist(Blipara[i]) then
									RemoveBlip(Blipara[i])
								end
								Broj = Broj-1
								TriggerServerEvent("seljacina:platituljanu")
								if Broj == 0 then
									for k,v in pairs(Config.Zones) do
										if k == "VehicleDeletePoint" then
											--SetNewWaypoint(v.Pos.x, v.Pos.y)
											if DoesBlipExist(Blip) then
												RemoveBlip(Blip)
											end
											Blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
											SetBlipSprite(Blip, 1)
											SetBlipColour (Blip, 5)
											SetBlipAlpha(Blip, 255)
											SetBlipRoute(Blip,  true) -- waypoint to blip
											ESX.ShowNotification("Vratite traktor na oznaceno mjesto kako bih ste zavrsili sa poslom!")
										end
									end
								end
							end
						end
					end
				elseif Farma == 2 then
					for i=1, #Config.Objekti2, 1 do
						if Objekti[i] == NewBin then
							if NewBinDistance <= 2 then
								Wait(600)
								ESX.Game.DeleteObject(Objekti[i])
								if DoesBlipExist(Blipara[i]) then
									RemoveBlip(Blipara[i])
								end
								Broj = Broj-1
								TriggerServerEvent("seljacina:platituljanu")
								if Broj == 0 then
									for k,v in pairs(Config.Zones) do
										if k == "VehicleDeletePoint" then
											--SetNewWaypoint(v.Pos.x, v.Pos.y)
											if DoesBlipExist(Blip) then
												RemoveBlip(Blip)
											end
											Blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
											SetBlipSprite(Blip, 1)
											SetBlipColour (Blip, 5)
											SetBlipAlpha(Blip, 255)
											SetBlipRoute(Blip,  true) -- waypoint to blip
											ESX.ShowNotification("Vratite traktor na oznaceno mjesto kako bih ste zavrsili sa poslom!")
										end
									end
								end
							end
						end
					end
				elseif Farma == 3 then
					for i=1, #Config.Objekti3, 1 do
						if Objekti[i] == NewBin then
							if NewBinDistance <= 2 then
								Wait(600)
								ESX.Game.DeleteObject(Objekti[i])
								if DoesBlipExist(Blipara[i]) then
									RemoveBlip(Blipara[i])
								end
								Broj = Broj-1
								TriggerServerEvent("seljacina:platituljanu")
								if Broj == 0 then
									for k,v in pairs(Config.Zones) do
										if k == "VehicleDeletePoint" then
											--SetNewWaypoint(v.Pos.x, v.Pos.y)
											if DoesBlipExist(Blip) then
												RemoveBlip(Blip)
											end
											Blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
											SetBlipSprite(Blip, 1)
											SetBlipColour (Blip, 5)
											SetBlipAlpha(Blip, 255)
											SetBlipRoute(Blip,  true) -- waypoint to blip
											ESX.ShowNotification("Vratite traktor na oznaceno mjesto kako bih ste zavrsili sa poslom!")
										end
									end
								end
							end
						end
					end
				elseif Farma == 4 then
					for i=1, #Config.Objekti4, 1 do
						if Objekti[i] == NewBin then
							if NewBinDistance <= 2 then
								Wait(600)
								ESX.Game.DeleteObject(Objekti[i])
								if DoesBlipExist(Blipara[i]) then
									RemoveBlip(Blipara[i])
								end
								Broj = Broj-1
								TriggerServerEvent("seljacina:platituljanu")
								if Broj == 0 then
									for k,v in pairs(Config.Zones) do
										if k == "VehicleDeletePoint" then
											--SetNewWaypoint(v.Pos.x, v.Pos.y)
											if DoesBlipExist(Blip) then
												RemoveBlip(Blip)
											end
											Blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
											SetBlipSprite(Blip, 1)
											SetBlipColour (Blip, 5)
											SetBlipAlpha(Blip, 255)
											SetBlipRoute(Blip,  true) -- waypoint to blip
											ESX.ShowNotification("Vratite traktor na oznaceno mjesto kako bih ste zavrsili sa poslom!")
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) and IsJobKosac() then

                if CurrentAction == 'Obrisi' then
					ZavrsiPosao()
                end
                CurrentAction = nil
            end
		end
    end
end)

-- DISPLAY MISSION MARKERS AND MARKERS
Citizen.CreateThread(function()
	while true do
		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		if IsJobKosac() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_farmer:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_farmer:hasExitedMarker', lastZone)
			end

		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobKosac() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobKosac() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		
	end
end)

-------------------------------------------------
-- Fonctions
-------------------------------------------------
-- Fonction selection nouvelle mission livraison
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)