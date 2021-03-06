Keys = { ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118 }
ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Licenses                = {}
local CurrentID 			  = nil
local blip = {}

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  Wait(5000)
  ReloadBlip()
  ESX.TriggerServerCallback('esx_weashop:requestDBItems', function(ShopItems)
    for k,v in pairs(ShopItems) do
      Config.Zones[k].Items = v
    end
  end)
end)

RegisterNetEvent('esx_weashop:loadLicenses')
AddEventHandler('esx_weashop:loadLicenses', function (licenses)
  for i = 1, #licenses, 1 do
    Licenses[licenses[i].type] = true
  end
end)

AddEventHandler('onClientMapStart', function()
  ESX.TriggerServerCallback('esx_weashop:requestDBItems', function(ShopItems)
    for k,v in pairs(ShopItems) do
      Config.Zones[k].Items = v
    end
  end)
end)

function OpenBuyLicenseMenu (zone)
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_license',
    {
      title = _U('buy_license'),
      elements = {
        { label = _U('yes') .. ' ($' .. Config.LicensePrice .. ')', value = 'yes' },
        { label = _U('no'), value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes' then
        TriggerServerEvent('oruzje:dajgalicenca')
		OpenShopMenu(zone)
      end

      menu.close()
	  CurrentAction     = 'shop_menu'
	  CurrentActionMsg  = _U('shop_menu')
	  CurrentActionData = {zone = zone}
    end,
    function (data, menu)
      menu.close()
	  CurrentAction     = 'shop_menu'
	  CurrentActionMsg  = _U('shop_menu')
	  CurrentActionData = {zone = zone}
    end
  )
end

function OpenShopMenu(zone)

  local elements = {}

  for i=1, #Config.Zones[zone].Items, 1 do

    local item = Config.Zones[zone].Items[i]

    table.insert(elements, {
      label     = item.label,
      realLabel = item.label,
      value     = item.name,
      price     = item.price
    })

  end
  local st = zone..CurrentID
	local lova = 0
	ESX.TriggerServerCallback('esx_gun:DajSef', function(lov)
		lova = lov
	end, st)
	Wait(400)
	ESX.TriggerServerCallback('esx_gun:DajDostupnost', function(jelje)
			if jelje == 1 then
				table.insert(elements, {
					label      = "Kupite trgovinu".. ' - <span style="color:green;">$5000000 </span>',
					label_real = "kupi",
					item       = "kupit",
					price      = 5000000,
				})
			else
				ESX.TriggerServerCallback('esx_gun:DalJeVlasnik', function(jelje2)
						if jelje2 == 1 then
							table.insert(elements, {
								label      = "Podignite novac".. ' - <span style="color:green;">$' .. lova .. ' </span>',
								label_real = "podigni",
								item       = "podignin",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Ostavite novac",
								label_real = "ostavi",
								item       = "ostavin",
								price      = 0,
							})
							table.insert(elements, {
								label      = "Prodaj".. ' - <span style="color:green;">$12500000 </span>',
								label_real = "prodaj",
								item       = "prodajt",
								price      = 0,
							})
						end
				end, st)
			end
	end, st)
	Wait(1000)


	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'shop',
			{
			  title  = _U('shop'),
			  elements = elements
			},
			function(data, menu)
				if data.current.item == 'kupit' then
						TriggerServerEvent('weapon:piku2', zone, CurrentID)
						menu.close()
						CurrentAction     = 'shop_menu'
						CurrentActionMsg  = _U('shop_menu')
						CurrentActionData = {zone = zone}
				elseif data.current.item == 'podignin' then
						ESX.UI.Menu.Open(
						  'dialog', GetCurrentResourceName(), 'weap_daj_lovu',
						  {
							title = "Unesite koliko novca zelite podici"
						  },
						  function(data3, menu3)

							local count = tonumber(data3.value)

							if count == nil then
								ESX.ShowNotification("Kriva vrijednost!")
							elseif lova < count then
								ESX.ShowNotification("Nemate toliko u sefu!")
							else
								menu3.close()
								menu.close()
								TriggerServerEvent("esx_gun:OduzmiFirmi", st, count)
								CurrentAction     = 'shop_menu'
								CurrentActionMsg  = _U('shop_menu')
								CurrentActionData = {zone = zone}
							end

						  end,
						  function(data3, menu3)
							menu3.close()
						  end
						)
				elseif data.current.item == 'ostavin' then
						ESX.UI.Menu.Open(
						  'dialog', GetCurrentResourceName(), 'weap_ostavi_lovu',
						  {
							title = "Unesite koliko novca zelite ostaviti"
						  },
						  function(data4, menu4)

							local count = tonumber(data4.value)

							if count == nil then
								ESX.ShowNotification("Kriva vrijednost!")
							else
								menu4.close()
								menu.close()
								TriggerServerEvent("esx_gun:DajFirmi", st, count)
								CurrentAction     = 'shop_menu'
								CurrentActionMsg  = _U('shop_menu')
								CurrentActionData = {zone = zone}
							end

						  end,
						  function(data4, menu4)
							menu4.close()
						  end
						)
				elseif data.current.item == 'prodajt' then
						menu.close()
						TriggerServerEvent("esx_gun:ProdajFirmu", st)
				else
					local elements2 = {}
					table.insert(elements2, {
					  label     = "Kupi oruzje".. ' - <span style="color:green;">$' .. data.current.price .. ' </span>',
					  item 		= "kupior"
					})
					if data.current.value == "WEAPON_PISTOL" then
						local hasComponent = HasPedGotWeaponComponent(PlayerPedId(), GetHashKey(data.current.value), GetHashKey('COMPONENT_PISTOL_CLIP_02'))
						if hasComponent then
							table.insert(elements2, {
							  label     = "Kupi extended spremnik".. ' - <span style="color:green;">KUPLJENO </span>',
							  item 		= "kupimagare"
							})
						else
							local hasWeapon = HasPedGotWeapon(PlayerPedId(), GetHashKey(data.current.value), false)
							if hasWeapon then
								table.insert(elements2, {
								  label     = "Kupi extended spremnik".. ' - <span style="color:green;">$700</span>',
								  item 		= "kupimag"
								})
							else
								table.insert(elements2, {
								  label     = "Kupi extended spremnik".. ' - <span style="color:red;">NEMATE ORUZJE </span>',
								  item 		= "kupimagare"
								})
							end
						end
					elseif data.current.value == "WEAPON_CARBINERIFLE" then
						local hasComponent = HasPedGotWeaponComponent(PlayerPedId(), GetHashKey(data.current.value), GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02'))
						if hasComponent then
							table.insert(elements2, {
							  label     = "Kupi extended spremnik".. ' - <span style="color:green;">KUPLJENO </span>',
							  item 		= "kupimagare"
							})
						else
							local hasWeapon = HasPedGotWeapon(PlayerPedId(), GetHashKey(data.current.value), false)
							if hasWeapon then
								table.insert(elements2, {
								  label     = "Kupi extended spremnik".. ' - <span style="color:green;">$700 </span>',
								  item 		= "kupimag"
								})
							else
								table.insert(elements2, {
								  label     = "Kupi extended spremnik".. ' - <span style="color:red;">NEMATE ORUZJE </span>',
								  item 		= "kupimagare"
								})
							end
						end
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'kupi_extended', {
						title    = "Kupovina oruzja",
						align    = 'top-left',
						elements = elements2
					}, function(data5, menu5)
						if data5.current.item == "kupior" then
							TriggerServerEvent('wesh:KuPi', data.current.value, data.current.price, zone, CurrentID)
							menu5.close()
						elseif data5.current.item == "kupimag" then
							if data.current.value == "WEAPON_PISTOL" then
								TriggerServerEvent('wesh:KuPi2', 1, zone, CurrentID)
							else
								TriggerServerEvent('wesh:KuPi2', 2, zone, CurrentID)
							end
							menu5.close()
						end
					end, function(data5, menu5)
						menu5.close()
					end)
				end
			end,
			function(data, menu)

			  menu.close()

			  CurrentAction     = 'shop_menu'
			  CurrentActionMsg  = _U('shop_menu')
			  CurrentActionData = {zone = zone}
			end
	)
end

AddEventHandler("playerSpawned", function()
	ReloadBlip()
end)

AddEventHandler('esx_weashop:hasEnteredMarker', function(zone, id)

  CurrentAction     = 'shop_menu'
  CurrentActionMsg  = _U('shop_menu')
  CurrentActionData = {zone = zone}
  CurrentID = id
end)

AddEventHandler('esx_weashop:hasExitedMarker', function(zone)

  CurrentAction = nil
  ESX.UI.Menu.CloseAll()

end)

RegisterNetEvent('esx_gun:ReloadBlip')
AddEventHandler('esx_gun:ReloadBlip', function()
	ReloadBlip()
end)

function ReloadBlip()
	for k,v in pairs(Config.Zones) do
		if v.legal==0 then
			for i = 1, #v.Pos, 1 do
				local st = k..i
				ESX.TriggerServerCallback('esx_gun:DalJeVlasnik', function(jelje2)
					if jelje2 == 1 then
						blip[st] = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
						SetBlipSprite (blip[st], 154)
						SetBlipDisplay(blip[st], 4)
						SetBlipScale  (blip[st], 1.0)
						SetBlipColour (blip[st], 67)
						SetBlipAsShortRange(blip[st], true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(_U('map_blip'))
						EndTextCommandSetBlipName(blip[st])
					else
						blip[st] = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
						SetBlipSprite (blip[st], 154)
						SetBlipDisplay(blip[st], 4)
						SetBlipScale  (blip[st], 1.0)
						SetBlipColour (blip[st], 2)
						SetBlipAsShortRange(blip[st], true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(_U('map_blip'))
						EndTextCommandSetBlipName(blip[st])
					end
				end, st)
			end
		end
	end
end

-- Display markers
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
          DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end
    end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Wait(0)
    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
    local currentZone = nil
	local ID = nil

    for k,v in pairs(Config.Zones) do
      for i = 1, #v.Pos, 1 do
        if(GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x) then
          isInMarker  = true
          ShopItems   = v.Items
          currentZone = k
          LastZone    = k
		  ID = i
        end
      end
    end
    if isInMarker and not HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = true
      TriggerEvent('esx_weashop:hasEnteredMarker', currentZone, ID)
    end
    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('esx_weashop:hasExitedMarker', LastZone)
    end
  end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0, Keys['E']) then

        if CurrentAction == 'shop_menu' then
          if Config.EnableLicense == true then
            if Licenses['weapon'] ~= nil or Config.Zones[CurrentActionData.zone].legal == 1 then
              OpenShopMenu(CurrentActionData.zone)
            else
              OpenBuyLicenseMenu()
            end
          else
            OpenShopMenu(CurrentActionData.zone)
          end
        end

        CurrentAction = nil

      end

    end
  end
end)

-- thx to Pandorina for script
RegisterNetEvent('esx_weashop:clipcli')
AddEventHandler('esx_weashop:clipcli', function()
  ped = GetPlayerPed(-1)
  if IsPedArmed(ped, 4) then
    hash=GetSelectedPedWeapon(ped)
    if hash~=nil then
      TriggerServerEvent('esx_weashop:remove')
      AddAmmoToPed(GetPlayerPed(-1), hash,25)
      ESX.ShowNotification("Iskoristili ste sarzer")
    else
      ESX.ShowNotification("Nemate oruzje u ruci")
    end
  else
    ESX.ShowNotification("Vrsta sanzera ne odgovara oruzju")
  end
end)
