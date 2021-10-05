ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('spasioc:isplata')
AddEventHandler('spasioc:isplata', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.job.name == 'fastfood' then
		xPlayer.addMoney(250)
		TriggerEvent("biznis:StaviUSef", "fastfood", math.ceil(250*0.30))
	else
        TriggerEvent("DiscordBot:Anticheat", GetPlayerName(_source).."[".._source.."] je pokusao pozvati event za novac fastfood-a, a nije zaposlen kao fastfoodovac!")
	    TriggerEvent("AntiCheat:Citer", _source)
    end
end)
