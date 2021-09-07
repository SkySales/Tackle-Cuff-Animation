-- 2018 Henric 'Kekke' Johansson

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ffc63c3c-32a2-4cf1-962b-c1616e086b8a')
AddEventHandler('ffc63c3c-32a2-4cf1-962b-c1616e086b8a', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('94ebc57a-d1a7-489b-ba10-f5933849a23d', targetPlayer.source, source)
	TriggerClientEvent('ad702987-b20d-4e9a-ae28-ee37177bde7a', source)
end)

RegisterServerEvent('startcuffanmin')
AddEventHandler('startcuffanmin', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('cufanim1', targetPlayer.source, source)
	TriggerClientEvent('cufanim2', source)
end)