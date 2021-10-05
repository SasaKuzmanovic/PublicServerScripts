ESX = nil

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

local VehiclesForSale = 0

RegisterNetEvent("Pijaca:Cijena")
AddEventHandler('Pijaca:Cijena', function(id, tablica)
	MySQL.Async.fetchAll("SELECT vehicleProps, price FROM vehicles_for_sale", {}, function(result)
        local vehicleTable = 0
        if result[1] ~= nil then
            for i = 1, #result, 1 do
				local prop = json.decode(result[i]["vehicleProps"])
				local tabl = prop["plate"]
				if Trim(tabl) == Trim(tablica) then
					vehicleTable = tonumber(result[i]["price"])
					TriggerClientEvent('Pijaca:VCijena', id, vehicleTable)
					break
				end 
            end
        end
    end)
end)

RegisterNetEvent("Pijaca:Refreshaj")
AddEventHandler('Pijaca:Refreshaj', function()
	TriggerClientEvent("Pijaca:refreshVehicles", -1)
end)

ESX.RegisterServerCallback("Pijaca:retrieveVehicles", function(source, cb)
	local src = source
	local identifier = ESX.GetPlayerFromId(src)["identifier"]

    MySQL.Async.fetchAll("SELECT seller, vehicleProps, price FROM vehicles_for_sale", {}, function(result)
        local vehicleTable = {}

        VehiclesForSale = 0

        if result[1] ~= nil then
            for i = 1, #result, 1 do
                VehiclesForSale = VehiclesForSale + 1

				local seller = false

				if result[i]["seller"] == identifier then
					seller = true
				end

                table.insert(vehicleTable, { ["price"] = result[i]["price"], ["vehProps"] = json.decode(result[i]["vehicleProps"]), ["owner"] = seller })
            end
        end

        cb(vehicleTable)
    end)
end)

ESX.RegisterServerCallback("Pijaca:isVehicleValid", function(source, cb, vehicleProps, price)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    
    local plate = vehicleProps["plate"]

	local isFound = false

	RetrievePlayerVehicles(xPlayer.identifier, function(ownedVehicles)

		for id, v in pairs(ownedVehicles) do

			if Trim(plate) == Trim(v.plate) and #Config.VehiclePositions ~= VehiclesForSale then
                
                MySQL.Async.execute("INSERT INTO vehicles_for_sale (seller, vehicleProps, price) VALUES (@sellerIdentifier, @vehProps, @vehPrice)",
                    {
						["@sellerIdentifier"] = xPlayer["identifier"],
                        ["@vehProps"] = json.encode(vehicleProps),
                        ["@vehPrice"] = price
                    }
                )

				MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', { ["@plate"] = plate})

                TriggerClientEvent("Pijaca:refreshVehicles", -1)

				isFound = true
				break

			end		

		end

		cb(isFound)

	end)
end)

ESX.RegisterServerCallback("Pijaca:buyVehicle", function(source, cb, vehProps, prodaja)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local plate = vehProps["plate"]
	local price = nil
	if prodaja == 1 then
		MySQL.Async.fetchAll("SELECT vehicleProps, price FROM vehicles_for_sale", {}, function(result)
			local vehicleTable = nil
			if result[1] ~= nil then
				for i = 1, #result, 1 do
					local platea = json.decode(result[i]["vehicleProps"])
					if Trim(platea["plate"]) == Trim(plate) then
						price = result[i]["price"]
						break
					end 
				end
			end
		end)
	else
		price = 0
	end
	while price == nil do
		Wait(1)
	end
	if xPlayer.getMoney() >= price or price == 0 then
		print(xPlayer.getMoney())
		print(price)
		xPlayer.removeMoney(price)

		MySQL.Async.execute("INSERT INTO owned_vehicles (plate, owner, vehicle, state) VALUES (@plate, @identifier, @vehProps, 0)",
			{
				["@plate"] = plate,
				["@identifier"] = xPlayer["identifier"],
				["@vehProps"] = json.encode(vehProps)
			}
		)

		--TriggerClientEvent("Pijaca:refreshVehicles", -1)

		MySQL.Async.fetchAll('SELECT seller FROM vehicles_for_sale WHERE vehicleProps LIKE "%' .. plate .. '%"', {}, function(result)
			if result[1] ~= nil and result[1]["seller"] ~= nil and prodaja == 1 then
				UpdateCash(result[1]["seller"], price)
			else
				print("Something went wrong, there was no car.")
			end
		end)

		MySQL.Async.execute('DELETE FROM vehicles_for_sale WHERE vehicleProps LIKE "%' .. plate .. '%"', {})

		cb(true)
	else
		cb(false, xPlayer.getAccount("bank")["money"])
	end
end)

function RetrievePlayerVehicles(newIdentifier, cb)
	local identifier = newIdentifier

	local yourVehicles = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier", {['@identifier'] = identifier}, function(result) 

		for id, values in pairs(result) do

			local vehicle = json.decode(values.vehicle)
			local plate = values.plate

			table.insert(yourVehicles, { vehicle = vehicle, plate = plate })
		end

		cb(yourVehicles)

	end)
end

function UpdateCash(identifier, cash)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	if xPlayer ~= nil then
		xPlayer.addMoney(cash)

		TriggerClientEvent("esx:showNotification", xPlayer.source, "Netko je kupio vase vozilo za $" .. cash)
	else
		MySQL.Async.fetchAll('SELECT bank FROM users WHERE identifier = @identifier', { ["@identifier"] = identifier }, function(result)
			if result[1]["bank"] ~= nil then
				MySQL.Async.execute("UPDATE users SET bank = @newBank WHERE identifier = @identifier",
					{
						["@identifier"] = identifier,
						["@newBank"] = result[1]["bank"] + cash
					}
				)
			end
		end)
	end
end

Trim = function(word)
	if word ~= nil then
		return word:match("^%s*(.-)%s*$")
	else
		return nil
	end
end