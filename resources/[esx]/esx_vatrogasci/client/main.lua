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
local Vozilo = nil
local TrajePozar = false
local ZadnjeVozilo = nil
local Blipara = nil
local LokacijaVatre = nil

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
--------------------------------------------------------------------------------
function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
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
				ZaustaviPozar()
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
				GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FIREEXTINGUISHER"), 200, false, true)
				menu.close()
				if TrajePozar == false then
					StartajVatru()
				end
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
		if data.current.value == "firetruk" then
			if Vozilo ~= nil then
				ESX.Game.DeleteVehicle(Vozilo)
				Vozilo = nil
			end
			ESX.Streaming.RequestModel(data.current.value)
			Vozilo = CreateVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, 319.94915771484, true, false)
			platenum = math.random(10000, 99999)
			SetVehicleNumberPlateText(Vozilo, "WAL"..platenum)             
			plaquevehicule = "WAL"..platenum			
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vozilo, -1)
			Radis = true
			ESX.ShowNotification("Pricekajte dojavu o pozaru!")
		end
			menu.close()
		end,
		function(data, menu)
			menu.close()
		end
	)
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

function IsJobVatrogasac()
	if ESX.PlayerData.job ~= nil then
		local vatr = false
		if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == 'vatrogasac' then
			vatr = true
		end
		return vatr
	end
end

AddEventHandler('esx_vatrogasac:hasEnteredMarker', function(zone)
	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobVatrogasac() and Radis == false then
			MenuVehicleSpawner()
		end
	end
	
	if zone == 'VehicleDeletePoint' then
		if isInService and IsJobVatrogasac() then
			CurrentAction     = 'Obrisi'
            CurrentActionMsg  = "Pritisnite E da vratite vozilo!"
			--ZavrsiPosao()
		end
	end
end)

AddEventHandler('esx_vatrogasac:hasExitedMarker', function(zone)
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
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustPressed(0, 38) and IsJobVatrogasac() then

                if CurrentAction == 'Obrisi' then
					if Vozilo ~= nil then
						ESX.Game.DeleteVehicle(Vozilo)
						Vozilo = nil
					end
					Radis = false
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
		
		if IsJobVatrogasac() then

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
				TriggerEvent('esx_vatrogasac:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_vatrogasac:hasExitedMarker', lastZone)
			end

		end
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobVatrogasac() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobVatrogasac() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		
	end
end)

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function ZaustaviPozar()
	TrajePozar = false
	Radis = false
	StopFireInRange(LokacijaVatre, 5.0)
	RemoveBlip(Blipara)
	if ZadnjeVozilo ~= nil then
		local retval, script = GetEntityScript(ZadnjeVozilo)
		if retval == "esx_vatrogasci" then
			ESX.Game.DeleteVehicle(ZadnjeVozilo)
			ZadnjeVozilo = nil
		end
	end
	if Vozilo ~= nil then
		ESX.Game.DeleteVehicle(Vozilo)
		Vozilo = nil
	end
end

function StartajVatru()
	if isInService then
		local br = {}
		for veh in EnumerateVehicles() do
			table.insert(br, veh)
		end
		if #br ~= 0 then
			local veha = br[math.random(#br)]
			local bra = 0
			local core
			local klasa = GetVehicleClass(veha)
			if klasa ~= 13 and klasa ~= 14 and klasa ~= 15 and klasa ~= 16 and klasa ~= 18 and klasa ~= 21 then
				local retvalee, script = GetEntityScript(veha)
				if veha ~= ZadnjeVozilo and retvalee == nil then
					local bonic = GetEntityBoneIndexByName(veha, "engine")
					if bonic ~= -1 and bonic ~= nil then
						ZadnjeVozilo = veha
						NetworkRequestControlOfEntity(veha)
						SetEntityAsMissionEntity(veha, true, true)
						NetworkRegisterEntityAsNetworked(veha)
						SetNetworkIdExistsOnAllMachines(VehToNet(veha), true)
						SetVehicleOnGroundProperly(veha, 5.0)
						ESX.ShowNotification("Imamo dojavu o pozaru, oznacena vam je lokacija na GPS-u!")
						FreezeEntityPosition(veha, true)			
						local cordo = GetEntityCoords(veha)
						core = GetWorldPositionOfEntityBone(veha, bonic)
						StartScriptFire(core, 25, false)
						Blipara = AddBlipForCoord(cordo)
						SetBlipSprite (Blipara, 436)
						SetBlipDisplay(Blipara, 8)
						SetBlipColour (Blipara, 49)
						SetBlipScale  (Blipara, 1.4)
						LokacijaVatre = core
						SetDisableVehicleEngineFires(veha, true)
						SetVehicleEngineCanDegrade(veha, false)
						SetVehicleFuelLevel(veha, 0)
						SetVehicleCanEngineOperateOnFire(veha, false)
						SetVehicleEngineHealth(veha, -1)
						SetVehicleHasBeenOwnedByPlayer(veha, true)
						SetVehicleEngineTemperature(veha, 300)
						TrajePozar = true
						while TrajePozar do
							Wait(0)
							local br = GetNumberOfFiresInRange(core, 4.0)
							if br == 0 then
								TrajePozar = false
								RemoveBlip(Blipara)
								FreezeEntityPosition(veha, false)
								local cor = GetEntityCoords(PlayerPedId())
								if GetDistanceBetweenCoords(core, cor, false) < 20 and ESX.PlayerData.job.name == "vatrogasac" and isInService then
									TriggerServerEvent("vatraaa:platituljanu")
									ESX.ShowNotification("Dobili ste $750 za uspjesno ugasen pozar!")
								end
								local retval, script = GetEntityScript(veha)
								if retval == "esx_vatrogasci" then
									Wait(8000)
									ESX.Game.DeleteVehicle(veha)
								end
								Wait(15000)
								StartajVatru()
							end
						end
					else
						Wait(100)
						StartajVatru()
					end
				else
					Wait(100)
					StartajVatru()
				end
			else
				Wait(100)
				StartajVatru()
			end
		else
			Wait(100)
			StartajVatru()
		end
	end
end
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