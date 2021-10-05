ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("tattoos:GetPlayerTattoos_s")
AddEventHandler("tattoos:GetPlayerTattoos_s", function()
	local _source = source
	local playerId = getPlayerID(_source)

	MySQL.Async.fetchAll("SELECT * FROM playersTattoos WHERE identifier = @identifier", {['@identifier'] = playerId}, function(result)
		if(result[1] ~= nil) then
			local tattoosList = json.decode(result[1].tattoos)
			TriggerClientEvent("tattoos:getPlayerTattoos", _source, tattoosList)
		else
			local tattooValue = json.encode({})
			MySQL.Async.execute("INSERT INTO playersTattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['@identifier'] = playerId, ['@tattoo'] = tattooValue})
			TriggerClientEvent("tattoos:getPlayerTattoos", _source, {})
		end
	end)
end)

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function (source, cb)
	local _source = source
	local playerId = getPlayerID(_source)

	MySQL.Async.fetchAll("SELECT * FROM playersTattoos WHERE identifier = @identifier", {['@identifier'] = playerId}, function(result)
		if(result[1] ~= nil) then
			local tattoosList = json.decode(result[1].tattoos)
			cb(tattoosList)
		end
	end)
end)

RegisterServerEvent("tattoos:save")
AddEventHandler("tattoos:save", function(tattoosList, price, value)
	local _source = source
	local playerId = getPlayerID(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)

	if(xPlayer.getMoney() >= price) then
		xPlayer.removeMoney(price)
		ESX.SavePlayer(xPlayer, function() 
		end)
		table.insert(tattoosList,value)
		MySQL.Async.execute("UPDATE playersTattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode(tattoosList), ['@identifier'] = playerId})
		TriggerClientEvent("tattoo:buySuccess", _source, value)
		TriggerClientEvent("esx:showNotification", _source, "~g~Kupili ste ovu tetovazu.")
	else
		TriggerClientEvent("esx:showNotification", _source, "~r~Nemate dovoljno novca.")
	end
end)

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

