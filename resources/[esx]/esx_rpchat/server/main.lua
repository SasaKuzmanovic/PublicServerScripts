--[[

  ESX RP Chat

--]]

local Global = 1
local CekajZaOglas = 0

AddEventHandler('es:invalidCommandHandler', function(source, command_args, user)
	CancelEvent()
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', _U('unknown_command', command_args[1]) } })
end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end

 AddEventHandler('chatMessage', function(source, name, message)
	  CancelEvent()
	  if string.sub(message, 1, string.len("/")) ~= "/" then
		  local playerName = GetPlayerName(source)
		  local name = getIdentity(source)
		  local fal = name.firstname .. " " .. name.lastname
		  local msg = message
		  local imee = playerName.." ("..fal..")"
		  if Global == 1 then
			  TriggerClientEvent('chat:addMessage', -1, {
					template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i>(OOC) {0}:<br> {1}</div>',
					args = { imee, msg }
			  })
		  else
			TriggerClientEvent('sendProximityMessage', -1, source, imee, msg)
		  end
	  end
  end)
  
  
	RegisterNetEvent("PromjeniGlobal")
	AddEventHandler('PromjeniGlobal', function(br)
		if br == 1 then
			TriggerClientEvent('chat:addMessage', -1, { args = { 'SYSTEM ', "Chat(T) je globalan (svi vide sta pisete)" } })
		else
			TriggerClientEvent('chat:addMessage', -1, { args = { 'SYSTEM ', "Chat(T) je lokalan (osobe blizu vas vide sta pisete)" } })
		end
		Global = br
	end)
  
  -- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  --    local name = getIdentity(source)
  --    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 



  --- TriggerEvent('es:addCommand', 'me', function(source, args, user)
  ---    local name = getIdentity(source)
  ---    TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, table.concat(args, " "))
  -- end) 
  --[[TriggerEvent('es:addCommand', 'me', function(source, args, user)
    local name = getIdentity(source)
    table.remove(args, 2)
    TriggerClientEvent('sendProximityMessageMe', -1, source, name.firstname, table.concat(args, " "))
end)--]]

RegisterCommand('me', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
	if args[1] ~= nil then
    local name = getIdentity(source)
	TriggerClientEvent('sendProximityMessageMe', -1, source, name.firstname, table.concat(args, " "))
	end
end, false)

RegisterCommand('do', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
	if args[1] ~= nil then
    local name = getIdentity(source)
	TriggerClientEvent('sendProximityMessageDo', -1, source, name.firstname, table.concat(args, " "))
	end
end, false)

 RegisterCommand('tweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
	if args[1] ~= nil then
    local msg = rawCommand:sub(6)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent("rpchat:SaljiTweet", -1, fal, msg, source)
	end
end, false)

 RegisterCommand('anontweet', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    if args[1] ~= nil then
    local msg = rawCommand:sub(11)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    local imee = playerName.." ["..source.."]"
    TriggerClientEvent("rpchat:SaljiAnon", -1, imee, msg)
    end
end, false)

 RegisterCommand('ad', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
	local broj
	if args[1] ~= nil then
		if CekajZaOglas <= 0 then
			local msg = rawCommand:sub(4)
			local name = getIdentity(source)
			fal = name.firstname .. " " .. name.lastname
			local identifier = GetPlayerIdentifiers(source)[1]
			local result = MySQL.Sync.fetchAll("SELECT phone_number FROM users WHERE identifier = @identifier", {
				['@identifier'] = identifier
			})
			broj = result[1].phone_number
			local imee = playerName.." ["..source.."]"
			TriggerClientEvent("rpchat:SaljiOglas", -1, imee, msg, broj)
			CekajZaOglas = 120
			Citizen.CreateThread(function()
				while CekajZaOglas > 0 do
					Citizen.Wait(1000)
					CekajZaOglas = CekajZaOglas-1
				end
			end)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM ', " Morate pricekati jos "..CekajZaOglas.." sekundi za novi oglas!" } })
		end
	end
end, false)

 --[[RegisterCommand('ooc', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> {0}:<br> {1}</div>',
        args = { playerName, msg }
    })
end, false)--]]


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
