local PermLvl = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("prodajoruzje:Posalji")
AddEventHandler('prodajoruzje:Posalji', function(id, oruzje, cijena, ammo, pid)
	TriggerClientEvent("prodajoruzje:Saljem", id, oruzje, cijena, ammo, pid)
end)

RegisterNetEvent('VratiPermLevel2')
AddEventHandler('VratiPermLevel2', function(perm)
	PermLvl[source] = perm
end)

RegisterNetEvent("prodajoruzje:PosaljiAdmOdgovor")
AddEventHandler('prodajoruzje:PosaljiAdmOdgovor', function(id, odg)
	TriggerClientEvent("prodajoruzje:VratiAdmOdgovor", id, odg)
end)

ESX.RegisterServerCallback('prodajoruzje:DajNovac', function(source, cb, target)
	local tar = ESX.GetPlayerFromId(target)
	local missingMoney = tar.getMoney()
	cb(missingMoney)
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

RegisterCommand("dajmuskin", function(source, args, rawCommandString)
	TriggerEvent("DajMiPermLevel2", source)
        if PermLvl[source] ~= nil then
	if PermLvl[source] > 0 then
		local id = 0
		id = tonumber(args[1])
		if id ~= 0 and id ~= nil then
			TriggerClientEvent("prodajoruzje:TestSkina", id)
		else
			name = "Admin"..":"
			message = "/dajmuskin [id]"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
		end
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
        end
end, false)

RegisterCommand("oduzmisociety", function(source, args, rawCommandString)
	TriggerEvent("DajMiPermLevel2", source)
        if PermLvl[source] ~= nil then
	if PermLvl[source] > 0 then
		local ime = args[1]
		local broj = tonumber(args[2])
		if ime ~= nil and (args[2] ~= nil or args[2] ~= 0) then
			local soc = "society_"..ime
			local societyAccount = nil
			TriggerEvent('esx_addonaccount:getSharedAccount', soc, function(account)
				societyAccount = account
			end)
			societyAccount.removeMoney(broj)
			societyAccount.save()
		else
			name = "Admin"..":"
			message = "/oduzmisociety [Ime mafije][Iznos]"
			TriggerEvent('chat:addMessage', { args = { name, message }, color = r,g,b })
		end
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
        end
end, false)

RegisterCommand("svilideri", function(source, args, rawCommandString)
		local elements = {}
		MySQL.Async.fetchAll('SELECT name, job, job_grade FROM users', {}, function(result)
			MySQL.Async.fetchAll('SELECT job_name, grade, name FROM job_grades', {}, function(result2)
				for i=1, #result, 1 do
					for j=1, #result2, 1 do
						if result[i].job == result2[j].job_name then
							if result[i].job_grade == result2[j].grade then
								if result2[j].name == "boss" then
									local str = result[i].name.." ["..result[i].job.."]"
									table.insert(elements, { label = str, value = result[i].job })
								end
							end
						end
					end
				end
			end)
		end)
		Wait(3000)
		TriggerClientEvent("prodajoruzje:PokaziSveLidere", source, elements)
end, false)

RegisterCommand("lideri", function(source, args, rawCommandString)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local elements = {}

		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do

		  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		  if xPlayer.job.name ~= nil then
			  local gradeLabel = xPlayer.job.grade_name
			  local job = xPlayer.job.name
			  if gradeLabel == "boss" or gradeLabel == "vlasnik" then
				  local str = xPlayer.getName().." ["..job.."]"
				  table.insert(elements, { label = str, value = gradeLabel })
			  end
		  end
		end
		TriggerClientEvent("prodajoruzje:PokaziLidere", source, elements)
end, false)

RegisterCommand("clanovi", function(source, args, rawCommandString)
		local sourceXPlayer = ESX.GetPlayerFromId(source)
		local elements = {}

		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do

		  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		  if xPlayer.job.name == sourceXPlayer.job.name then
			local gradeLabel = (xPlayer.job.grade_label == '' and xPlayer.job.label or xPlayer.job.grade_label)
			local str = xPlayer.getName().." ["..gradeLabel.."]"
			table.insert(elements, { label = str, value = gradeLabel })
		  end

		end
		TriggerClientEvent("prodajoruzje:PokaziClanove", source, elements)
end, false)

RegisterCommand("r", function(source, args, rawCommandString)
	local br = 0
	local targetXPlayer = ESX.GetPlayerFromId(source)
	if targetXPlayer.job.name == 'police' or targetXPlayer.job.name == 'swat' then
		br = 1
	end
	if br == 1 then
				if args[1] ~= nil then
					local name = getIdentity(source)
		 		 	local fal = name.firstname .. " " .. name.lastname
					TriggerClientEvent("prodajoruzje:PosaljiRadio", -1, table.concat(args, " "), fal)
				else
					name = "System"..":"
					message = "/r [Poruka]"
					TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })
				end	
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
end, false)

RegisterCommand("f", function(source, args, rawCommandString)
	local br = 0
	local targetXPlayer = ESX.GetPlayerFromId(source)
	if targetXPlayer.job.name ~= nil and (targetXPlayer.job.name == 'yakuza' or targetXPlayer.job.name == 'grove' or targetXPlayer.job.name == 'ballas' or targetXPlayer.job.name == 'mafia' or targetXPlayer.job.name == 'cartel'  or targetXPlayer.job.name == 'britvasi' or targetXPlayer.job.name == 'shelby') then
		br = 1
	end
	if br == 1 then
				if args[1] ~= nil then
					local name = getIdentity(source)
		 		 	local fal = name.firstname .. " " .. name.lastname
					TriggerClientEvent("prodajoruzje:PosaljiMafia", -1, table.concat(args, " "), fal, targetXPlayer.job.name)
				else
					name = "System"..":"
					message = "/f [Poruka]"
					TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })
				end	
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
end, false)

RegisterCommand("a", function(source, args, rawCommandString)
	TriggerEvent("DajMiPermLevel2", source)
        if PermLvl[source] ~= nil then
	if PermLvl[source] > 0 and PermLvl[source] ~= nil then
				if args[1] ~= nil then
					local name = getIdentity(source)
					local playerName = GetPlayerName(source)
					TriggerClientEvent("prodajoruzje:PosaljiRadio2", -1, table.concat(args, " "), playerName)
				else
					name = "System"..":"
					message = " /a [Poruka]"
					TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })
				end	
	else
		name = "System"..":"
		message = " Nemate pristup ovoj komandi"
		TriggerClientEvent('chat:addMessage', source, { args = { name, message }, color = r,g,b })	
	end
        end
end, false)

RegisterNetEvent("prodajoruzje:Posalji2")
AddEventHandler('prodajoruzje:Posalji2', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local kola = sourceXPlayer.getInventoryItem("marijuana").count
	if kola >= tonumber(kol) then
		TriggerClientEvent('esx:showNotification', pid, "Ponudili ste igracu drogu!")
		TriggerClientEvent("prodajoruzje:Saljem2", id, cijena, kol, pid)
	else
		TriggerClientEvent('esx:showNotification', pid, "Nemate dovoljnu kolicinu marihuane!")
	end
end)

RegisterNetEvent("prodajoruzje:Posalji3")
AddEventHandler('prodajoruzje:Posalji3', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local kola = sourceXPlayer.getInventoryItem("cocaine").count
	if kola >= tonumber(kol) then
		TriggerClientEvent('esx:showNotification', pid, "Ponudili ste igracu kokain!")
		TriggerClientEvent("prodajoruzje:Saljem3", id, cijena, kol, pid)
	else
		TriggerClientEvent('esx:showNotification', pid, "Nemate dovoljnu kolicinu kokaina!")
	end
end)

RegisterNetEvent("dajpro:oruzje")
AddEventHandler('dajpro:oruzje', function(id, oruzje, cijena, ammo, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	if targetXPlayer.getMoney() >= tonumber(cijena) then
	--if not targetXPlayer.hasWeapon(oruzje) then
			sourceXPlayer.removeWeapon(oruzje)
			targetXPlayer.addWeapon(oruzje, ammo)
			sourceXPlayer.addMoney(cijena/2)
			targetXPlayer.removeMoney(cijena)
			ESX.SavePlayer(sourceXPlayer, function()
			end)
			ESX.SavePlayer(targetXPlayer, function()
			end)
			local societyAccount = nil
			local sime = "society_"..sourceXPlayer.getJob().name
			TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
				societyAccount = account
			end)
			societyAccount.addMoney(cijena/2)
			societyAccount.save()

			local weaponLabel = ESX.GetWeaponLabel(oruzje)
			local str = "Uspjesno ste prodali oruzje "..weaponLabel.." sa "..ammo.." metaka!"
			local str2 = "Uspjesno ste kupili oruzje "..weaponLabel.." sa "..ammo.." metaka!"
			local strm = "Uspjesno ste prodali oruzje "..weaponLabel.." bez metaka!"
			local str2m = "Uspjesno ste kupili oruzje "..weaponLabel.." bez metaka!"
			local str3 = "Pola od cijene ste dobili vi, a druga polovica je otisla bandi na racun!"
			if ammo > 0 then
				TriggerClientEvent('esx:showNotification', pid, str)
				TriggerClientEvent('esx:showNotification', id,  str2)
				TriggerClientEvent('esx:showNotification', pid,  str3)
			else
				TriggerClientEvent('esx:showNotification', pid, strm)
				TriggerClientEvent('esx:showNotification', id,  str2m)
				TriggerClientEvent('esx:showNotification', pid,  str3)
			end
	--else
		--TriggerClientEvent('esx:showNotification', pid, "Osoba vec ima to oruzje!")
		--TriggerClientEvent('esx:showNotification', id, "Vec imate to oruzje!")
	--end
	else
		TriggerClientEvent('esx:showNotification', pid, "Osoba nema dovoljno novca!")
		TriggerClientEvent('esx:showNotification', id, "Nemate dovoljno novca!")
	end
end)

RegisterNetEvent("dajpro:oruzje2")
AddEventHandler('dajpro:oruzje2', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local kola = targetXPlayer.getInventoryItem("marijuana").count
	local maximum = tonumber(kol)+kola
	if maximum <= 14 then
		if targetXPlayer.getMoney() >= tonumber(cijena) then
			sourceXPlayer.removeInventoryItem("marijuana", kol)
			targetXPlayer.addInventoryItem("marijuana", kol)
			sourceXPlayer.addMoney(cijena/2)
			targetXPlayer.removeMoney(cijena)
			ESX.SavePlayer(sourceXPlayer, function()
			end)
			ESX.SavePlayer(targetXPlayer, function()
			end)
			
			local societyAccount = nil
			local sime = "society_"..sourceXPlayer.getJob().name
			TriggerEvent('esx_addonaccount:getSharedAccount', sime, function(account)
				societyAccount = account
			end)
			societyAccount.addMoney(cijena/2)
			societyAccount.save()

			local str = "Uspjesno ste prodali "..kol.."g marihuane!"
			local str2 = "Uspjesno ste kupili "..kol.."g marihuane!"
			local str3 = "Pola od cijene ste dobili vi, a druga polovica je otisla bandi na racun!"

			TriggerClientEvent('esx:showNotification', pid, str)
			TriggerClientEvent('esx:showNotification', id,  str2)
			TriggerClientEvent('esx:showNotification', pid,  str3)
		else
			TriggerClientEvent('esx:showNotification', pid, "Osoba nema dovoljno novca!")
			TriggerClientEvent('esx:showNotification', id, "Nemate dovoljno novca!")
		end
	else
		TriggerClientEvent('esx:showNotification', pid, "Osoba ce imati tada vise droge od dozvoljenoga!")
		TriggerClientEvent('esx:showNotification', id, "Imat cete vise droge od dozvoljenoga(max 14g)!")
	end
end)

RegisterNetEvent("dajpro:oruzje3")
AddEventHandler('dajpro:oruzje3', function(id, cijena, kol, pid)
	local sourceXPlayer = ESX.GetPlayerFromId(pid)
	local targetXPlayer = ESX.GetPlayerFromId(id)
	local kola = targetXPlayer.getInventoryItem("cocaine").count
	local maximum = tonumber(kol)+kola
	if maximum <= 10 then
		if targetXPlayer.getMoney() >= tonumber(cijena) then
			sourceXPlayer.removeInventoryItem("cocaine", kol)
			targetXPlayer.addInventoryItem("cocaine", kol)
			sourceXPlayer.addMoney(cijena)
			targetXPlayer.removeMoney(cijena)
			ESX.SavePlayer(sourceXPlayer, function()
			end)
			ESX.SavePlayer(targetXPlayer, function()
			end)

			local str = "Uspjesno ste prodali "..kol.."g kokaina!"
			local str2 = "Uspjesno ste kupili "..kol.."g kokaina!"

			TriggerClientEvent('esx:showNotification', pid, str)
			TriggerClientEvent('esx:showNotification', id,  str2)
		else
			TriggerClientEvent('esx:showNotification', pid, "Osoba nema dovoljno novca!")
			TriggerClientEvent('esx:showNotification', id, "Nemate dovoljno novca!")
		end
	else
		TriggerClientEvent('esx:showNotification', pid, "Osoba ce tada imati vise kokaina od dozvoljenoga!")
		TriggerClientEvent('esx:showNotification', id, "Imat cete vise kokaina od dozvoljenoga(max 10g)!")
	end
end)
