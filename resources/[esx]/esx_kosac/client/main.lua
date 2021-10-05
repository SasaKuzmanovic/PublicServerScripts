ESX = nil
local Objekti = {}
local Spawno = false
local objektSpawnan = false
local Broj = 0
local opetBroj = 0
local Radis = false

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

local isInService = false
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blipara				  = {}
local VratiBlip				  = {}
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

	for i=1, #Config.Boats, 1 do
		table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Boats[i])), value = Config.Boats[i]})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vehiclespawner',
		{
			title    = _U('vehiclespawner'),
			elements = elements
		},
		function(data, menu)
		if data.current.value == "seashark2" then
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 116.28479003906, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
				plaquevehicule = "WAL"..platenum			
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
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

	if objektSpawnan == false then
	local randomBroj = math.random(1,5)
	opetBroj = randomBroj
		ESX.Game.SpawnLocalObject('prop_ped_gib_01', {
				x = Config.Objekti[randomBroj].x,
				y = Config.Objekti[randomBroj].y,
				z = Config.Objekti[randomBroj].z
		}, function(obj)
		Objekti[randomBroj] = obj
		end)
		Blipara[randomBroj] = AddBlipForCoord(Config.Objekti[randomBroj].x,  Config.Objekti[randomBroj].y,  Config.Objekti[randomBroj].z)
		SetBlipSprite (Blipara[randomBroj], 1)
		SetBlipDisplay(Blipara[randomBroj], 8)
		SetBlipColour (Blipara[randomBroj], 2)
		SetBlipScale  (Blipara[randomBroj], 1.4)
		Broj = #Config.Objekti
		Spawno = true
		objektSpawnan = true
		ESX.ShowNotification("Spasi Cojka i vratite se na crveni marker sto prije!")
	end
end

function isABoat()
	local isABoat = false
	local playerPed = GetPlayerPed(-1)
	for i=1, #Config.Boats, 1 do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Boats[i]) then
			isABoat = true
			break
		end
	end
	return isABoat
end

function IsJobSpasioc()
	if ESX.PlayerData.job ~= nil then
		local spasioc = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'spasioc' then
			spasioc = true
		end
		return spasioc
	end
end

AddEventHandler('esx_spasioc:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobSpasioc() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobSpasioc() then
			ESX.ShowNotification("Zona uhvacena")
			obrisiVozilo()
		end
	end
end)

function obrisiVozilo()
	local odjebi = 1
	odjebi = odjebi - 1
	if odjebi == 0 then
		ESX.ShowNotification("funkcija radi")
		ESX.ShowNotification("Vozilo vraceno")
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		ESX.Game.DeleteVehicle(vehicle)
		ZavrsiPosao()
	end
end

function ZavrsiPosao()
	for i=1, #Config.Objekti, 1 do
		if Objekti[opetBroj] ~= nil then
			ESX.Game.DeleteObject(Objekti[opetBroj])
			if DoesBlipExist(Blipara[opetBroj]) then
				RemoveBlip(Blipara[opetBroj])
			end
		end
	end
	Broj = 0
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local tablica = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	Spawno = false
	Radis = false
end

AddEventHandler('esx_spasioc:hasExitedMarker', function(zone)
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
				local NewBin, NewBinDistance = ESX.Game.GetClosestObject("prop_ped_gib_01")
					if Objekti[opetBroj] == NewBin then
						if NewBinDistance <= 2 then
							Wait(600)
							ESX.Game.DeleteObject(Objekti[opetBroj])
							if DoesBlipExist(Blipara[opetBroj]) then
								RemoveBlip(Blipara[opetBroj])
							end
							Broj = Broj-1
							TriggerServerEvent("spasioc:isplata")
							if Broj == 0 then
								Spawno = false
								Radis = false
								objektSpawnan = false
								Broj = 0
								ESX.ShowNotification("Uspjesno spasen cojk!")
							end
						end
					end
			end
		end
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, 38) and IsJobSpasioc() then

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
		
		if IsJobSpasioc() then

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
				TriggerEvent('esx_spasioc:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_spasioc:hasExitedMarker', lastZone)
			end

		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobSpasioc() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobSpasioc() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)