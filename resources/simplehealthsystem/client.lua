-----------------------
-- Damaged Walk Mode --
-----------------------

local Neces = false

local hurt = false
Citizen.CreateThread(function()
    while not Neces do
        Wait(0)
        if GetEntityHealth(GetPlayerPed(-1)) <= 159 then
            setHurt()
        elseif hurt and GetEntityHealth(GetPlayerPed(-1)) > 160 then
            setNotHurt()
        end
    end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	DisableControlAction(0, 21) 
	DisableControlAction(0,22)
end

function setNotHurt()
    hurt = false
	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end

RegisterNetEvent('Muvaj:PostaviGa')
AddEventHandler('Muvaj:PostaviGa', function(br)
  Neces = br
end)

----------------
-- Walk Shake --
----------------

playerMoving = false

Citizen.CreateThread(function()
	while true do Wait(0)
		if not IsPedInAnyVehicle(PlayerPedId(), false) and GetEntitySpeed(PlayerPedId()) >= 0.5 and GetFollowPedCamViewMode() ~= 4 then
			if playerMoving == false then
				ShakeGameplayCam("ROAD_VIBRATION_SHAKE", 0.25)
				playerMoving = true
			end
		else
			if playerMoving == true then
				StopGameplayCamShaking(false)
				playerMoving = false
			end
		end
	end
end)