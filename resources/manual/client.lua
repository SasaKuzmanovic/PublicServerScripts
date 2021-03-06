local setGear = GetHashKey('SET_VEHICLE_CURRENT_GEAR') & 0xFFFFFFFF
local function SetVehicleCurrentGear(veh, gear)
	Citizen.InvokeNative(setGear, veh, gear)
end

local nextGear = GetHashKey('SET_VEHICLE_NEXT_GEAR') & 0xFFFFFFFF
local function SetVehicleNextGear(veh, gear)
	Citizen.InvokeNative(nextGear, veh, gear)
end

local function ForceVehicleGear (vehicle, gear)
	SetVehicleCurrentGear(vehicle, gear)
	SetVehicleNextGear(vehicle, gear)
	return gear
end

--------------------------------------------------------------------------------
local Manual = false

local mode

RegisterCommand("mjenjac", function(source, args, rawCommandString)
	if Manual == false then
		Manual = true
		TriggerEvent('chat:addMessage', { args = { '[MJENJAC]', 'Lijevi shift za visu brzinu' } })
		TriggerEvent('chat:addMessage', { args = { '[MJENJAC]', 'Lijevi ctrl za nizu brzinu' } })
	else
		Manual = false
		TriggerEvent("SaljiGear", -69)
	end
end, false)

Citizen.CreateThread(function ()
	local vehicle, lastVehicle, ped
	local gear, maxGear
	local nextMode, maxMode

	local braking
	local function HandleVehicleBrake ()
		if gear == 0 then -- Prevent reversing
			DisableControlAction(2, 72, true)
			-- use parking brake once stopped
			if IsDisabledControlPressed(2, 72) then
				SetControlNormal(2, 76, 1.0)
				braking = true
			end
		elseif IsControlPressed(2, 72) then
			braking = true
		end
	end
	
	local function Brejkaj ()
		Citizen.CreateThread(function ()
			if gear == 1 then
				SetVehicleHandbrake(vehicle, true)
				Wait(1000)
				SetVehicleHandbrake(vehicle, false)
			end
		end)
	end

	local function OnTick()
			braking = false

			-- Reverse
			if mode == 1 then
				DisableControlAction(2, 71, true)
				-- gas
				if IsDisabledControlPressed(2, 71) then
					SetControlNormal(2, 72, GetDisabledControlNormal(2, 71))
				else
					HandleVehicleBrake()
				end

			-- Neutral
			elseif mode == 2 then
				HandleVehicleBrake()
				ForceVehicleGear(vehicle, 1)

				-- gas
				DisableControlAction(2, 71, true)
				DisableControlAction(2, 72, true)
				if IsDisabledControlPressed(2, 71) then
					SetVehicleCurrentRpm(vehicle, 1.0)
				end
				if IsDisabledControlPressed(2, 72) then
					SetVehicleBrakeLights(vehicle, true)
					SetVehicleNextGear(vehicle, 0)
					braking = true
				end
			-- Drive
			else
				HandleVehicleBrake()
				ForceVehicleGear(vehicle, mode - 2)
			end

			-- Brake
			if braking or IsControlPressed(2, 76) then
				SetVehicleBrakeLights(vehicle, true)
				--SetVehicleNextGear(vehicle, 0)
				braking = true
			end
	end

	while true do
		if Manual == true then
			ped = PlayerPedId()
			vehicle = GetVehiclePedIsUsing(ped)

			if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
				gear = GetVehicleCurrentGear(vehicle)

				-- Entered vehicle
				if lastVehicle ~= vehicle then
					lastVehicle = vehicle
					maxGear = GetVehicleHighGear(vehicle)
					maxMode = 2 + maxGear

					-- Use current gear | neutral
					if gear >= 1 then
						mode = gear + 2
					else
						mode = 2
					end
				end

				-- Gear up | down
				if IsControlJustPressed(0, 131) and GetIsVehicleEngineRunning(vehicle) then
					nextMode = math.min(mode + 1, maxMode)
					local modeText = { 'R', 'N'}
					
					local gira
					if mode >=2 then
						gira = nextMode - 2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end

					TriggerEvent("SaljiGear", gira)
				elseif IsControlJustPressed(0, 132) and GetIsVehicleEngineRunning(vehicle) then
					nextMode = math.max(mode - 1, 1)
					local modeText = { 'R', 'N'}
					
					local gira
					if nextMode >=2 then
						gira = nextMode-2
					else
						gira = modeText[nextMode]
						--gira = mode - 1 -- GetVehicleCurrentGear(vehicle)
					end
					
					if gira == nil or gira == 0 or gira == '' then
						gira = "N"
					end

					TriggerEvent("SaljiGear", gira)
					Brejkaj()
				else
					nextMode = mode
				end

				-- On Shift
				if nextMode ~= mode then
					mode = nextMode
				end

				OnTick()
			elseif lastVehicle then
				lastVehicle = false
				mode = false
			end
			
			local speed = GetEntitySpeed(vehicle)
			local kmh = (speed * 3.6)
			if IsControlPressed(0, 71) then
				if kmh < 5 then
					if gear > 1 and GetIsVehicleEngineRunning(vehicle) then
						SetVehicleEngineOn( vehicle, false, true, true )
					end
				end
			end
			if kmh < 2 then
				SetVehicleNextGear(vehicle, 0)
			end
		end
		Wait(0)
	end
end)

--------------------------------------------------------------------------------
