local br = 1

RegisterCommand("pos", function(source, args, rawCommandString)
	CancelEvent()
	TriggerClientEvent("SaveCommand", source, args[1])
end, false)

RegisterCommand("spos", function(source, args, rawCommandString)
	CancelEvent()
	TriggerClientEvent("SaveCommand2", source, args[1])
end, false)

RegisterCommand("rpos", function(source, args, rawCommandString)
	CancelEvent()
	br = 1
end, false)

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

RegisterServerEvent("SaveCoords")
AddEventHandler("SaveCoords", function( x , y , z, kom )
    local PlayerName = GetPlayerName(source)
	filea = io.open( PlayerName .. "-Coords.txt", "a")
    if filea then
		if kom == nil then
			kom = "Nema komentara"
		end
        filea:write("["..br.."] = {x = " .. x .. ", y = " .. y .. ", z = " .. z .. "}, --"..kom.."\n")
		filea:close()
    end
	br=br+1
end)

RegisterServerEvent("SaveCoords2")
AddEventHandler("SaveCoords2", function( x , y , z , h, kom )
 local PlayerName = GetPlayerName(source)
 filea = io.open( PlayerName .. "-Coords.txt", "a")
    if filea then
		if kom == nil then
			kom = "Nema komentara"
		end
        filea:write("{x = " .. x .. ", y = " .. y .. ", z = " .. z .. ", h = " .. h .. "}, --"..kom.."\n")
		filea:close()
    end
end)