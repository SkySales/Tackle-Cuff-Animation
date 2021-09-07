-- 2018 Henric 'Kekke' Johansson

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

ESX               				= nil
local PlayerData                = {}
local PoliceJob 				= 'police'
local Job 				= 'ambulance'

local isTackling				= false
local isGettingTackled			= false

local tackleLib					= 'missmic2ig_11'
local tackleAnim 				= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim			= 'mic_2_ig_11_intro_p_one'

local lastTackleTime			= 0
local isRagdoll					= false

----var cuff anim 
local Aresztuje					= false		
local Aresztowany				= false		
 
local SekcjaAnimacji			= 'mp_arrest_paired'	
local AnimAresztuje 			= 'cop_p2_back_left'	
local AnimAresztowany			= 'crook_p2_back_left'	
local OstatnioAresztowany		= 0	

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if isRagdoll then
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('94ebc57a-d1a7-489b-ba10-f5933849a23d')
AddEventHandler('94ebc57a-d1a7-489b-ba10-f5933849a23d', function(target)
	isGettingTackled = true

	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)
	DetachEntity(PlayerPedId(), true, false)

	isRagdoll = true
	Citizen.Wait(3000)
	isRagdoll = false

	isGettingTackled = false
end)

RegisterNetEvent('ad702987-b20d-4e9a-ae28-ee37177bde7a')
AddEventHandler('ad702987-b20d-4e9a-ae28-ee37177bde7a', function()
	local playerPed = PlayerPedId()

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)

	isTackling = false

end)

RegisterNetEvent('cufanim1')
AddEventHandler('cufanim1', function(target)
	Aresztowany = true

	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(SekcjaAnimacji)

	while not HasAnimDictLoaded(SekcjaAnimacji) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
	TaskPlayAnim(playerPed, SekcjaAnimacji, AnimAresztowany, 8.0, -8.0, 5500, 33, 0, false, false, false)

	Citizen.Wait(950)
	DetachEntity(GetPlayerPed(-1), true, false)

	Aresztowany = false
end)

RegisterNetEvent('cufanim2')
AddEventHandler('cufanim2', function()
	local playerPed = GetPlayerPed(-1)

	RequestAnimDict(SekcjaAnimacji)

	while not HasAnimDictLoaded(SekcjaAnimacji) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, SekcjaAnimacji, AnimAresztuje, 8.0, -8.0, 5500, 33, 0, false, false, false)

	Citizen.Wait(3000)

	Aresztuje = false

end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Wait(0)

		if IsControlPressed(0, Keys['LEFTSHIFT']) and IsControlPressed(0, Keys['H']) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 and PlayerData.job.name == PoliceJob then
			Citizen.Wait(10)
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= Config.Distance and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
				isTackling = true
				lastTackleTime = GetGameTimer()

				TriggerServerEvent('ffc63c3c-32a2-4cf1-962b-c1616e086b8a', GetPlayerServerId(closestPlayer))
			else
				exports['mythic_notify']:DoHudText('error', 'No Player Nearby!')
			end
		elseif IsControlPressed(0, Keys['LEFTSHIFT']) and IsControlPressed(0, Keys['H']) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 and PlayerData.job.name == Job then
			Citizen.Wait(10)
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= Config.Distance and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
				isTackling = true
				lastTackleTime = GetGameTimer()

				TriggerServerEvent('ffc63c3c-32a2-4cf1-962b-c1616e086b8a', GetPlayerServerId(closestPlayer))
			else
				exports['mythic_notify']:DoHudText('error', 'No Player Nearby!')
			end
		elseif IsControlPressed(0, Keys['LEFTSHIFT']) and IsControlPressed(0, Keys['G']) and not Aresztuje and GetGameTimer() - OstatnioAresztowany > 10 * 1000 and PlayerData.job.name == PoliceJob then	
			Citizen.Wait(10)
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= Config.Distance and not Aresztuje and not Aresztowany and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
				Aresztuje = true
				OstatnioAresztowany = GetGameTimer()

				ESX.ShowNotification("~b~Aresztujesz Obywatela~r~ " .. GetPlayerServerId(closestPlayer) .. "")						
				TriggerServerEvent('startcuffanmin', GetPlayerServerId(closestPlayer))									

				Citizen.Wait(2100)																									
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuffseffect', 0.7)									

				Citizen.Wait(3100)																									
				ESX.ShowNotification("~b~Zaresztowano Obywatela ~r~ " .. GetPlayerServerId(closestPlayer) .. "")					
				TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))	
			else
				exports['mythic_notify']:DoHudText('error', 'No Player Nearby!')								
			end
		end
	end
end)


-----------YOU CAN ADD MORE JOBS VIA STATEMENT ENJOY!! THANKS ME LATER -SKY!!-------------