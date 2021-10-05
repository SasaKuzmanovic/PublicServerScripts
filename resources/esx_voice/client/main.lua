local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local voice = {default = 12.0, shout = 19.0, whisper = 1.0, current = 0, level = nil}

ESX = nil

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

function ProvjeriPosao()
	ESX.PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	voice.current = 0
	NetworkSetTalkerProximity(voice.default)
	NetworkClearVoiceChannel()
end)

function drawLevel(r, g, b, a)
	SetTextFont(4)
	SetTextScale(0.5, 0.5)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(_U('voice', voice.level))
	EndTextCommandDisplayText(0.175, 0.90)
end

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(500)
	end
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(5)
		if voice.current == 3 then
			if (IsControlJustPressed(0, 249))  then
				local player = PlayerPedId()
				if ( DoesEntityExist( player ) and not IsEntityDead( player ) ) then 
					loadAnimDict( "random@arrests" )
					TaskPlayAnim(player, "random@arrests", "generic_radio_chatter", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
					RemoveAnimDict("random@arrests")
				end
			end
			if (IsControlJustReleased(0, 249))  then
				local player = PlayerPedId()
				if ( DoesEntityExist( player ) and not IsEntityDead( player ) ) then 
					ClearPedSecondaryTask(player)
				end
			end
		end
	end
end)

AddEventHandler('onClientMapStart', function()
	if voice.current == 0 then
		NetworkSetTalkerProximity(voice.default)
	elseif voice.current == 1 then
		NetworkSetTalkerProximity(voice.shout)
	elseif voice.current == 2 then
		NetworkSetTalkerProximity(voice.whisper)
	elseif voice.current == 3 then
		if ESX.PlayerData.job.name == "police" then
			NetworkSetTalkerProximity(0.0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if IsControlJustPressed(1, Keys['H']) and IsControlPressed(1, Keys['LEFTALT']) then
			if ESX.PlayerData.job.name == "police" then
				voice.current = (voice.current + 1) % 4
			else
				voice.current = (voice.current + 1) % 3
			end
			if voice.current == 0 then
				NetworkClearVoiceChannel()
				NetworkSetTalkerProximity(voice.default)
				voice.level = _U('normal')
			elseif voice.current == 1 then
				NetworkClearVoiceChannel()
				NetworkSetTalkerProximity(voice.shout)
				voice.level = _U('shout')
			elseif voice.current == 2 then
				NetworkClearVoiceChannel()
				NetworkSetTalkerProximity(voice.whisper)
				voice.level = _U('whisper')
			elseif voice.current == 3 then
				NetworkClearVoiceChannel()
				NetworkSetTalkerProximity(0.0)
				if ESX.PlayerData.job.name == "police" then
					NetworkSetVoiceChannel("policija")
					voice.level = firstToUpper("policija")
				end
			end
		end

		if voice.current == 0 then
			voice.level = _U('normal')
		elseif voice.current == 1 then
			voice.level = _U('shout')
		elseif voice.current == 2 then
			voice.level = _U('whisper')
		elseif voice.current == 3 then
			if ESX.PlayerData.job.name == "police" then
				voice.level = firstToUpper("policija")
			end

		end

		if NetworkIsPlayerTalking(PlayerId()) then
			drawLevel(41, 128, 185, 255)
		elseif not NetworkIsPlayerTalking(PlayerId()) then
			drawLevel(185, 185, 185, 255)
		end
	end
end)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
