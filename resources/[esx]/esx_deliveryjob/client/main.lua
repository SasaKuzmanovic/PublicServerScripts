--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- ORIGINAL SCRIPT BY Marcio FOR CFX-ESX
-- Script serveur No Brain 
-- www.nobrain.org
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ESX = nil
local PlayerData              = nil

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
local namezone = "Delivery"
local namezonenum = 0
local namezoneregion = 0
local MissionRegion = 0
local viemaxvehicule = 1000
local argentretire = 0
local livraisonTotalPaye = 0
local livraisonnombre = 0
local MissionRetourCamion = false
local MissionNum = 0
local MissionLivraison = false
local isInService = false
local GUI                     = {}
GUI.Time                      = 0
local hasAlreadyEnteredMarker = false
local lastZone                = nil
local Blips                   = {}

local plaquevehicule = ""
local plaquevehiculeactuel = ""
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local LokCPa
local LokDos
local PritisoTipku = 0
local vozilo
local IstovarioTo = 0
local prop_ent
local MiciCP = 0
local PrviDio = 0
local lastpickup = nil
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
		if data.current.value == "mule" then
				ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint2.Pos, 270.0, function(vehicle)
				platenum = math.random(10000, 99999)
				SetVehicleNumberPlateText(vehicle, "WAL"..platenum)             
                MissionLivraisonSelect()
				plaquevehicule = "WAL"..platenum		
				vozilo = vehicle
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)   
			end)
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

function IsJobTrucker()
	if PlayerData ~= nil then
		local isJobTrucker = false
		if PlayerData.job.name ~= nil and PlayerData.job.name == 'delivery' then
			isJobTrucker = true
		end
		return isJobTrucker
	end
end

AddEventHandler('esx_delivererjob:hasEnteredMarker', function(zone)

	local playerPed = GetPlayerPed(-1)

	if zone == 'CloakRoom' then
		MenuCloakRoom()
	end
	
	if zone == 'Pokupi' then
		if isInService and IsJobTrucker() and PrviDio == 0 then
			CurrentAction     = 'Pokupi'
            CurrentActionMsg  = "Pritisnite E da istovarite robu!"
		end
	end
	
	if zone == 'Istovari' then
		if isInService and IsJobTrucker() then
			CurrentAction     = 'Istovari'
            CurrentActionMsg  = "Pritisnite E da ostavite robu!"
		end
	end

	if zone == 'VehicleSpawner' then
		if isInService and IsJobTrucker() then
			if MissionRetourCamion or MissionLivraison then
				CurrentAction = 'hint'
                CurrentActionMsg  = _U('already_have_van')
			else
				MenuVehicleSpawner()
			end
		end
	end

	if zone == namezone then
		if isInService and MissionLivraison and MissionNum == namezonenum and MissionRegion == namezoneregion and IsJobTrucker() and MiciCP == 0 then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifPlaqueVehiculeActuel()
				
				if plaquevehicule == plaquevehiculeactuel then
					if Blips['delivery'] ~= nil then
						RemoveBlip(Blips['delivery'])
						Blips['delivery'] = nil
					end

					CurrentAction     = 'delivery'
                    CurrentActionMsg  = _U('delivery')
				else
					CurrentAction = 'hint'
                    CurrentActionMsg  = _U('not_your_van')
				end
			else
				CurrentAction = 'hint'
                CurrentActionMsg  = _U('not_your_van2')
			end
		end
	end

	if zone == 'AnnulerMission' then
		if isInService and MissionLivraison and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifPlaqueVehiculeActuel()
				
				if plaquevehicule == plaquevehiculeactuel then
                    CurrentAction     = 'retourcamionannulermission'
                    CurrentActionMsg  = _U('cancel_mission')
				else
					CurrentAction = 'hint'
                    CurrentActionMsg  = _U('not_your_van')
				end
			else
                CurrentAction     = 'retourcamionperduannulermission'
			end
		end
	end

	if zone == 'RetourCamion' then
		if isInService and MissionRetourCamion and IsJobTrucker() then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				VerifPlaqueVehiculeActuel()

				if plaquevehicule == plaquevehiculeactuel then
                    CurrentAction     = 'retourcamion'
				else
                    CurrentAction     = 'retourcamionannulermission'
                    CurrentActionMsg  = _U('not_your_van')
				end
			else
                CurrentAction     = 'retourcamionperdu'
			end
		end
	end

end)

AddEventHandler('esx_delivererjob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()    
    CurrentAction = nil
    CurrentActionMsg = ''
end)

function nouvelledestination()
	IstovarioTo = 0
	PritisoTipku = 0
	PrviDio = 1
	MiciCP = 0
	livraisonnombre = livraisonnombre+1
	livraisonTotalPaye = livraisonTotalPaye+destination.Paye

	if livraisonnombre >= Config.MaxDelivery then
		MissionLivraisonStopRetourDepot()
	else

		livraisonsuite = math.random(0, 100)
		
		if livraisonsuite <= 10 then
			MissionLivraisonStopRetourDepot()
		elseif livraisonsuite <= 99 then
			MissionLivraisonSelect()
		elseif livraisonsuite <= 100 then
			if MissionRegion == 1 then
				MissionRegion = 1
			elseif MissionRegion == 2 then
				MissionRegion = 1
			end
			MissionLivraisonSelect()	
		end
	end
end

function retourcamion_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	MissionRetourCamion = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapaye()
end

function retourcamion_non()
	
	if livraisonnombre >= Config.MaxDelivery then
		ESX.ShowNotification(_U('need_it'))
	else
		ESX.ShowNotification(_U('ok_work'))
		nouvelledestination()
	end
end

function retourcamionperdu_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	MissionRetourCamion = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapayesanscamion()
end

function retourcamionperdu_non()
	ESX.ShowNotification(_U('scared_me'))
end

function retourcamionannulermission_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	MissionLivraison = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapaye()
end

function retourcamionannulermission_non()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function retourcamionperduannulermission_oui()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	MissionLivraison = false
	livraisonnombre = 0
	MissionRegion = 0
	IstovarioTo = 0
	PritisoTipku = 0
	MiciCP = 0
	
	donnerlapayesanscamion()
end

function retourcamionperduannulermission_non()	
	ESX.ShowNotification(_U('resume_delivery'))
end

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function donnerlapaye()
	ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	vievehicule = GetVehicleEngineHealth(vehicle)
	calculargentretire = round(viemaxvehicule-vievehicule)
	
	if calculargentretire <= 0 then
		argentretire = 0
	else
		argentretire = calculargentretire
	end

    ESX.Game.DeleteVehicle(vehicle)

	local amount = livraisonTotalPaye-argentretire
	
	if vievehicule >= 1 then
		if livraisonTotalPaye == 0 then
			ESX.ShowNotification(_U('not_delivery'))
			ESX.ShowNotification(_U('pay_repair'))
			ESX.ShowNotification(_U('repair_minus')..argentretire)
			TriggerServerEvent("esx_delivererposo:platiljantu", amount)
			livraisonTotalPaye = 0
		else
			if argentretire <= 0 then
				ESX.ShowNotification(_U('shipments_plus')..livraisonTotalPaye)
				TriggerServerEvent("esx_delivererposo:platiljantu", amount)
				livraisonTotalPaye = 0
			else
				ESX.ShowNotification(_U('shipments_plus')..livraisonTotalPaye)
				ESX.ShowNotification(_U('repair_minus')..argentretire)
					TriggerServerEvent("esx_delivererposo:platiljantu", amount)
				livraisonTotalPaye = 0
			end
		end
	else
		if livraisonTotalPaye ~= 0 and amount <= 0 then
			ESX.ShowNotification(_U('van_state'))
			livraisonTotalPaye = 0
		else
			if argentretire <= 0 then
				ESX.ShowNotification(_U('shipments_plus')..livraisonTotalPaye)
					TriggerServerEvent("esx_delivererposo:platiljantu", amount)
				livraisonTotalPaye = 0
			else
				ESX.ShowNotification(_U('shipments_plus')..livraisonTotalPaye)
				ESX.ShowNotification(_U('repair_minus')..argentretire)
				TriggerServerEvent("esx_delivererposo:platiljantu", amount)
				livraisonTotalPaye = 0
			end
		end
	end
end

function donnerlapayesanscamion()
	ped = GetPlayerPed(-1)
	argentretire = Config.TruckPrice
	
	-- donne paye
	local amount = livraisonTotalPaye-argentretire
	
	if livraisonTotalPaye == 0 then
		ESX.ShowNotification(_U('no_delivery_no_van'))
		ESX.ShowNotification(_U('van_price')..argentretire)
					TriggerServerEvent("esx_delivererposo:platiljantu", amount)
		livraisonTotalPaye = 0
	else
		if amount >= 1 then
			ESX.ShowNotification(_U('shipments_plus')..livraisonTotalPaye)
			ESX.ShowNotification(_U('truck_price')..argentretire)
					TriggerServerEvent("esx_delivererposo:platiljantu", amount)
			livraisonTotalPaye = 0
		else
			ESX.ShowNotification(_U('van_state'))
			livraisonTotalPaye = 0
		end
	end
end

function PostaviCPIzaKamiona()
	ESX.ShowNotification("Izadjite iz kamiona, te odite iza da istovarite robu!")
	local trunk = GetWorldPositionOfEntityBone(vozilo, GetEntityBoneIndexByName(vozilo, "platelight"))
	LokCPa = trunk
	PrviDio = 0
	Citizen.CreateThread(function()
		while PritisoTipku == 0 do
			Wait(0)
			--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
			--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			DrawMarker(27, trunk.x , trunk.y, trunk.z, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		end
	end)
end

function PostaviIstovarCP()
	ESX.ShowNotification("Idite do zelenog markera da ostavite robu!")
	LokDos = vector3(destination.Dos.x , destination.Dos.y, destination.Dos.z)
	Citizen.CreateThread(function()
		while IstovarioTo == 0 do
			Wait(0)
			--DrawMarker(20, trunkpos, 0,0,0, 0,0,0, arrowSize, 150, 255, 128, 0, true, true, true)	
			--plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			DrawMarker(1, destination.Dos.x , destination.Dos.y, destination.Dos.z, 0, 0, 0, 0, 0, 0, 1.25, 1.25, 1.0001, 0, 128, 0, 200, 0, 0, 0, 0)
		end
	end)
end

-- Key Controls
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if CurrentAction ~= nil then
        	SetTextComponentFormat('STRING')
        	AddTextComponentString(CurrentActionMsg)
       		DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, 38) and IsJobTrucker() then

                if CurrentAction == 'delivery' then
					SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId(), false),5,false, false)
					PostaviCPIzaKamiona()
					FreezeEntityPosition(vozilo, true)
					MiciCP = 1
                end
				
				if CurrentAction == 'Pokupi' then
					ESX.Streaming.RequestAnimDict("anim@heists@box_carry@", function()
						TaskPlayAnim(PlayerPedId(),"anim@heists@box_carry@", "idle", 8.0, 8.0, -1, 50)
					end)
					prop_ent = CreateObject("prop_sacktruck_02b", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0))
					AttachEntityToEntity(prop_ent, PlayerPedId(), GetEntityBoneIndexByName(PlayerPedId(), "SKEL_Pelvis"), -0.075, 0.90, -0.86, -20.0, 0.5, 181.0, true, false, false, true, 1, true)
					SetVehicleDoorOpen(vozilo,5,false, false)
					FreezeEntityPosition(vozilo, false)
					PritisoTipku = 1
					IstovarioTo = 0
					PostaviIstovarCP()
					if Blips['delivery'] ~= nil then
						RemoveBlip(Blips['delivery'])
						Blips['delivery'] = nil
					end
                end
				
				if CurrentAction == 'Istovari' then
                    nouvelledestination()
					ClearPedSecondaryTask(PlayerPedId())
					DetachEntity(prop_ent, false, false)
					DeleteObject(prop_ent)
					IstovarioTo = 1
                end

                if CurrentAction == 'retourcamion' then
                    retourcamion_oui()
                end

                if CurrentAction == 'retourcamionperdu' then
                    retourcamionperdu_oui()
                end

                if CurrentAction == 'retourcamionannulermission' then
                    retourcamionannulermission_oui()
                end

                if CurrentAction == 'retourcamionperduannulermission' then
                    retourcamionperduannulermission_oui()
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
		
		if MissionLivraison and MiciCP == 0 then
			DrawMarker(destination.Type, destination.Pos.x, destination.Pos.y, destination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, destination.Size.x, destination.Size.y, destination.Size.z, destination.Color.r, destination.Color.g, destination.Color.b, 100, false, true, 2, false, false, false, false)
			DrawMarker(Config.Livraison.AnnulerMission.Type, Config.Livraison.AnnulerMission.Pos.x, Config.Livraison.AnnulerMission.Pos.y, Config.Livraison.AnnulerMission.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Livraison.AnnulerMission.Size.x, Config.Livraison.AnnulerMission.Size.y, Config.Livraison.AnnulerMission.Size.z, Config.Livraison.AnnulerMission.Color.r, Config.Livraison.AnnulerMission.Color.g, Config.Livraison.AnnulerMission.Color.b, 100, false, true, 2, false, false, false, false)
		elseif MissionRetourCamion and MiciCP == 0 then
			DrawMarker(destination.Type, destination.Pos.x, destination.Pos.y, destination.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, destination.Size.x, destination.Size.y, destination.Size.z, destination.Color.r, destination.Color.g, destination.Color.b, 100, false, true, 2, false, false, false, false)
		end

		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do

			if isInService and (IsJobTrucker() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end

		for k,v in pairs(Config.Cloakroom) do

			if(IsJobTrucker() and v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
		
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		if IsJobTrucker() then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if(GetDistanceBetweenCoords(coords, LokCPa, false) < 1) and PritisoTipku == 0 then
				isInMarker  = true
				currentZone = "Pokupi"
			end
			
			if(GetDistanceBetweenCoords(coords, LokDos, true) < 2) and IstovarioTo == 0 then
				isInMarker  = true
				currentZone = "Istovari"
			end
			
			for k,v in pairs(Config.Cloakroom) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			for k,v in pairs(Config.Livraison) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) and MiciCP == 0 then
					isInMarker  = true
					currentZone = k
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone                = currentZone
				TriggerEvent('esx_delivererjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_delivererjob:hasExitedMarker', lastZone)
			end

		end

	end
end)

-- CREATE BLIPS
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Cloakroom.CloakRoom.Pos.x, Config.Cloakroom.CloakRoom.Pos.y, Config.Cloakroom.CloakRoom.Pos.z)
  
	SetBlipSprite (blip, 85)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.4)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_job'))
	EndTextCommandSetBlipName(blip)
end)

-------------------------------------------------
-- Fonctions
-------------------------------------------------
-- Fonction selection nouvelle mission livraison
function MissionLivraisonSelect()
	if MissionRegion == 0 then
		MissionRegion = 1
	end
	
	if MissionRegion == 1 then -- Los santos
		MissionNum = math.random(1, 10)
		while lastpickup == MissionNum do
			Citizen.Wait(50)
			MissionNum = math.random(1, 10)
		end
		if MissionNum == 1 then destination = Config.Livraison.Delivery1LS namezone = "Delivery1LS" namezonenum = 1 namezoneregion = 1
		elseif MissionNum == 2 then destination = Config.Livraison.Delivery2LS namezone = "Delivery2LS" namezonenum = 2 namezoneregion = 1
		elseif MissionNum == 3 then destination = Config.Livraison.Delivery3LS namezone = "Delivery3LS" namezonenum = 3 namezoneregion = 1
		elseif MissionNum == 4 then destination = Config.Livraison.Delivery4LS namezone = "Delivery4LS" namezonenum = 4 namezoneregion = 1
		elseif MissionNum == 5 then destination = Config.Livraison.Delivery5LS namezone = "Delivery5LS" namezonenum = 5 namezoneregion = 1
		elseif MissionNum == 6 then destination = Config.Livraison.Delivery6LS namezone = "Delivery6LS" namezonenum = 6 namezoneregion = 1
		elseif MissionNum == 7 then destination = Config.Livraison.Delivery7LS namezone = "Delivery7LS" namezonenum = 7 namezoneregion = 1
		elseif MissionNum == 8 then destination = Config.Livraison.Delivery8LS namezone = "Delivery8LS" namezonenum = 8 namezoneregion = 1
		elseif MissionNum == 9 then destination = Config.Livraison.Delivery9LS namezone = "Delivery9LS" namezonenum = 9 namezoneregion = 1
		elseif MissionNum == 10 then destination = Config.Livraison.Delivery10LS namezone = "Delivery10LS" namezonenum = 10 namezoneregion = 1
		end
	end
	lastpickup = MissionNum
	MissionLivraisonLetsGo()
end

-- Fonction active mission livraison
function MissionLivraisonLetsGo()
	if Blips['delivery'] ~= nil then
		RemoveBlip(Blips['delivery'])
		Blips['delivery'] = nil
	end
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_delivery'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	Blips['annulermission'] = AddBlipForCoord(Config.Livraison.AnnulerMission.Pos.x,  Config.Livraison.AnnulerMission.Pos.y,  Config.Livraison.AnnulerMission.Pos.z)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_goal'))
	EndTextCommandSetBlipName(Blips['annulermission'])

	if MissionRegion == 1 then -- Los santos
		ESX.ShowNotification(_U('meet_ls'))
	elseif MissionRegion == 2 then -- Blaine County
		ESX.ShowNotification(_U('meet_bc'))
	elseif MissionRegion == 0 then -- au cas ou
		ESX.ShowNotification(_U('meet_del'))
	end

	MissionLivraison = true
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

--Fonction retour au depot
function MissionLivraisonStopRetourDepot()
	destination = Config.Livraison.RetourCamion
	
	Blips['delivery'] = AddBlipForCoord(destination.Pos.x,  destination.Pos.y,  destination.Pos.z)
	SetBlipRoute(Blips['delivery'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blip_depot'))
	EndTextCommandSetBlipName(Blips['delivery'])
	
	if Blips['annulermission'] ~= nil then
		RemoveBlip(Blips['annulermission'])
		Blips['annulermission'] = nil
	end

	ESX.ShowNotification(_U('return_depot'))
	
	MissionRegion = 0
	MissionLivraison = false
	MissionNum = 0
	MissionRetourCamion = true
end

function SavePlaqueVehicule()
	plaquevehicule = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function VerifPlaqueVehiculeActuel()
	plaquevehiculeactuel = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end