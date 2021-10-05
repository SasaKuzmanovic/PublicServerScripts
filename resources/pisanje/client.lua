ESX                             = nil

local Odjeca = nil

Config = {
    Commands = false,
    StatusBars = true,
    Key = 344
}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterNetEvent('pisanje:openMenu')
AddEventHandler('pisanje:openMenu', function()
    OpenNeedsMenu()
end)

RegisterCommand("testpee", function(source, args, rawCommandString)
	TriggerEvent('esx_status:set', 'pee', args[1])
end, false)

RegisterCommand("testshit", function(source, args, rawCommandString)
	TriggerEvent('esx_status:set', 'shit', args[1])
end, false)

if Config.Commands then
    RegisterCommand('pee', function()
        if Config.StatusBars then
			local PEEe_STATUS
            TriggerEvent('esx_status:getStatus', 'pee', function(status)
                    TriggerServerEvent('pisanje:add', 'pee', 1000000)
					PEEe_STATUS = status.getPercent()
                    local hashSkin = GetHashKey("mp_m_freemode_01")

                    if GetEntityModel(PlayerPedId()) == hashSkin then
                        TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'male')
                    else
                        TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'female')
                    end
            end)
			exports.trew_hud_ui:setStatus({
			    name = 'pee',
			    value = PEEe_STATUS
			});
        else
            local hashSkin = GetHashKey("mp_m_freemode_01")

            if GetEntityModel(PlayerPedId()) == hashSkin then
                TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'male')
            else
                TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'female')
            end
        end
    end, false)

    RegisterCommand('poop', function()
        if Config.StatusBars then
			local SHITt_STATUS
            TriggerEvent('esx_status:getStatus', 'shit', function(status)
                    TriggerServerEvent('pisanje:add', 'shit', 1000000)
					SHITt_STATUS = status.getPercent()
                    TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'poop')
            end)
			exports.trew_hud_ui:setStatus({
			    name = 'shit',
			    value = SHITt_STATUS
			});
        else
            TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'poop')
        end
    end, false)
else
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            if IsControlJustReleased(0, Config.Key) then
                OpenNeedsMenu()
            end
        end
    end)
end

function OpenNeedsMenu()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pisanjemenu',
        {
            title    = 'WC Menu',
            align    = 'top-left',
            elements = { 
                { label = 'Pišaj', value = 'pee' },
                { label = 'Seri', value = 'poop' }
            }
        },
    function(data, menu)
        local value = data.current.value

        if value == 'pee' then
            menu.close()
            if Config.StatusBars then
                TriggerEvent('esx_status:getStatus', 'pee', function(status)
					if tonumber(status.val) < 300000 then
                        TriggerServerEvent('pisanje:add', 'pee', 1000000)
						exports.trew_hud_ui:setStatus({
							name = 'pee',
							value = status.getPercent()
						});
                        local hashSkin = GetHashKey("mp_m_freemode_01")

                        if GetEntityModel(PlayerPedId()) == hashSkin then
                            TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'male')
                        else
                            TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'female')
                        end
					else
                        ESX.ShowNotification('Ne piša ti se jos!')
                    end
                end)
            else
                local hashSkin = GetHashKey("mp_m_freemode_01")

                if GetEntityModel(PlayerPedId()) == hashSkin then
                    TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'male')
                else
                    TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'pee', 'female')
                end
            end

        elseif value == 'poop' then
            menu.close()
            if Config.StatusBars then
                TriggerEvent('esx_status:getStatus', 'shit', function(status)
					if tonumber(status.val) < 300000 then
                        TriggerServerEvent('pisanje:add', 'shit', 1000000)
                        TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'poop')
						exports.trew_hud_ui:setStatus({
							name = 'shit',
							value = status.getPercent()
						});
					else
                        ESX.ShowNotification('Ne sere ti se jos!')
                    end
                end)
            else
                TriggerServerEvent('pisanje:sync', GetPlayerServerId(PlayerId()), 'poop')
            end
        end

    end,
    function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('pisanje:syncCL')
AddEventHandler('pisanje:syncCL', function(ped, need, sex)
    if need == 'pee' then
        Pee(ped, sex)
    else
        Poop(ped)
    end
end)

function Pee(ped, sex)
    local Player = ped
    local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))
	if GetPlayerServerId(PlayerId()) == ped then
		TriggerEvent('skinchanger:getSkin', function(skin)
			Odjeca = skin
			local clothesSkin = {
			['pants_1'] = 21, ['pants_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end

    local particleDictionary = "core"
    local particleName = "ent_amb_peeing"
    local animDictionary = 'misscarsteal2peeing'
    local animName = 'peeing_loop'

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end

    RequestAnimDict(animDictionary)

    while not HasAnimDictLoaded(animDictionary) do
        Citizen.Wait(0)
    end

    RequestAnimDict('missfbi3ig_0')

    while not HasAnimDictLoaded('missfbi3ig_0') do
        Citizen.Wait(1)
    end

    if sex == 'male' then

        SetPtfxAssetNextCall(particleDictionary)

        local bone = GetPedBoneIndex(PlayerPed, 11816)

        local heading = GetEntityPhysicsHeading(PlayerPed)

        TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.2, 0.0, -140.0, 0.0, 0.0, bone, 2.5, false, false, false)

        Wait(3500)

        StopParticleFxLooped(effect, 0)
        ClearPedTasks(PlayerPed)
    else

        SetPtfxAssetNextCall(particleDictionary)

        bone = GetPedBoneIndex(PlayerPed, 11816)

        local heading = GetEntityPhysicsHeading(PlayerPed)

        TaskPlayAnim(PlayerPed, 'missfbi3ig_0', 'shit_loop_trev', 8.0, -8.0, -1, 0, 0, false, false, false)

        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.55, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)

        Wait(3500)

        Citizen.Wait(100)
        StopParticleFxLooped(effect, 0)
        ClearPedTasks(PlayerPed)
    end
	if GetPlayerServerId(PlayerId()) == ped then
		if Odjeca ~= nil then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, Odjeca)
			end)
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end
end

function Poop(ped)
    local Player = ped
    local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))
	if GetPlayerServerId(PlayerId()) == ped then
		TriggerEvent('skinchanger:getSkin', function(skin)
			Odjeca = skin
			local clothesSkin = {
			['pants_1'] = 21, ['pants_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end)
	end

    local particleDictionary = "scr_amb_chop"
    local particleName = "ent_anim_dog_poo"
    local animDictionary = 'missfbi3ig_0'
    local animName = 'shit_loop_trev'

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(0)
    end

    RequestAnimDict(animDictionary)

    while not HasAnimDictLoaded(animDictionary) do
        Citizen.Wait(0)
    end

    SetPtfxAssetNextCall(particleDictionary)

    --gets bone on specified ped
    bone = GetPedBoneIndex(PlayerPed, 11816)

    --animation
    TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

    --2 effets for more shit
    effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)
    Wait(3500)
    effect2 = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)
    Wait(1000)

    StopParticleFxLooped(effect, 0)
    Wait(10)
    StopParticleFxLooped(effect2, 0)
	Wait(3300)
	if GetPlayerServerId(PlayerId()) == ped then
		if Odjeca ~= nil then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, Odjeca)
			end)
		else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end
end

local SHIT_ACTIVE = false
local PEE_ACTIVE = false
AddEventHandler('playerSpawned', function()
	if SHIT_ACTIVE == false then
		exports.trew_hud_ui:createStatus({
			status = 'shit',
			color = '#996633',
			icon = '<i class="fas fa-poop"></i>'
		});
		SHIT_ACTIVE = true
	end
	if PEE_ACTIVE == false then
		exports.trew_hud_ui:createStatus({
			status = 'pee',
			color = '#ffeb3b',
			icon = '<i class="fas fa-toilet"></i>'
		});
		PEE_ACTIVE = true
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			
		local SHIT_STATUS
		local PEE_STATUS
	
		TriggerEvent('esx_status:getStatus', 'shit', function(status)
			SHIT_STATUS = status.getPercent()
		end)
		
		TriggerEvent('esx_status:getStatus', 'pee', function(status)
			PEE_STATUS = status.getPercent()
		end)
	
		exports.trew_hud_ui:setStatus({
			name = 'shit',
			value = SHIT_STATUS
		});
		
		exports.trew_hud_ui:setStatus({
			name = 'pee',
			value = PEE_STATUS
		});
	end
end)
