ESX = exports['es_extended']:getSharedObject()
exports('AddBoxZone', AddBoxZone)
local RNE = RegisterNetEvent
local TE = TriggerEvent
local AEH = AddEventHandler 
local TSE = TriggerServerEvent
local burad = {}
local spawnedBurad = 0
local BuradPlants = {}
local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	ESX.ShowNotification(Config.Prevod["ulaznaporuka"]["message"],Config.Prevod["ulaznaporuka"]["type"])
  end)

--[[burici sistem]]

local function AddPolyZone(name, points, options, targetoptions)
	local _points = {}
	if type(points[1]) == 'table' then
		for i = 1, #points do
			_points[i] = vec2(points[i].x, points[i].y)
		end
	end
	Zones[name] = PolyZone:Create(#_points > 0 and _points or points, options)
	targetoptions.distance = targetoptions.distance or Config.MaxDistance
	Zones[name].targetoptions = targetoptions
	return Zones[name]
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.Pretraga.methsearch.coords, true) < 50 then
			SpawnBuradPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(BuradPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnBuradPlants()
	while spawnedBurad < 15 do
		Citizen.Wait(0)
		local bureCoords = GenerateCocaLeafCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_01a', bureCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(BuradPlants, obj)
			spawnedBurad = spawnedBurad + 1
		end)
	end
end

function ValidateCocaLeafCoord(plantCoord)
	if spawnedBurad > 0 then
		local validate = true

		for k, v in pairs(BuradPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.Pretraga.methsearch.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCocaLeafCoords()
	while true do
		Citizen.Wait(1)

		local bureCoordX, bureCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		bureCoordX = Config.Pretraga.methsearch.coords.x + modX
		bureCoordY = Config.Pretraga.methsearch.coords.y + modY

		local coordZ = GetCoordZBurad(bureCoordX, bureCoordY)
		local coord = vector3(bureCoordX, bureCoordY, coordZ)

		if ValidateCocaLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZBurad(x, y)
	local groundCheckHeights = { 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 77
end


function OpenPlant()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    Citizen.Wait(10000)
    ESX.Game.DeleteObject(nearbyObject)
    TriggerServerEvent('vule:dajitem')
    ClearPedTasksImmediately(PlayerPedId())
end

local function GetBuradLabel(name)
    for _, burad in pairs(Config.Burici) do
        if burad.zone.name == name then return burad.label end
    end
end 
Citizen.CreateThread(function()
    for k, v in pairs(Config.Burici) do

        burad[k] = BoxZone:Create(
            vector3(v.zone.x, v.zone.y, v.zone.z),
            v.zone.l, v.zone.w, {
                name = v.zone.name,
                heading = v.zone.h,
                debugPoly = false,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ
            }
        )
		burad[k].type = v.type
        burad[k].label = v.label
    end
end)
function IsInsideZone(type, entity)
    local entityCoords = GetEntityCoords(entity)

	for k, v in pairs(burad) do
		if burad[k]:isPointInside(entityCoords) then
			currentburad = Config.Burici[k]
			return true
		end
		if k == #burad then return false end
	end
    
end


Citizen.CreateThread(function()
	exports.qtarget:AddTargetModel({-1738103333}, {
		options = {
			{
				event = "meth:search",
				icon = "fa-solid fa-bucket",
				label = "Pretrazi bure",
				canInteract = function(entity)
					hasChecked = false
					if IsInsideZone('burad', entity) and not hasChecked then
						hasChecked = true
						return true
					end
				end
			},
		},
		distance = 2
	})
end)




RNE("meth:search", function()
	
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #BuradPlants, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(BuradPlants[i]), false) < 1 then
			nearbyObject, nearbyID = BuradPlants[i], i
		end
	end
	if nearbyObject and IsPedOnFoot(playerPed) then
	
		TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)

		Citizen.Wait(2000)
		ClearPedTasks(playerPed)
		Citizen.Wait(1500)

		ESX.Game.DeleteObject(nearbyObject)

		table.remove(BuradPlants, nearbyID)
		spawnedBurad = spawnedBurad - 1

		TriggerServerEvent('meth:bure')
	end


end)


--[[prodaja]]

Citizen.CreateThread(function()
	for k, v in pairs(Config.Prodaja)do
  RequestModel(GetHashKey('a_m_m_og_boss_01'))
  while not HasModelLoaded(GetHashKey('a_m_m_og_boss_01')) do
  Wait(1)
  end
  PostaviPeda = CreatePed(4, 'a_m_m_og_boss_01', v.kordinateped , v.headingped, false, true)
  FreezeEntityPosition(PostaviPeda, true) 
  SetEntityInvincible(PostaviPeda, true)
  SetBlockingOfNonTemporaryEvents(PostaviPeda, true)
	  end
  end)

  Citizen.CreateThread(function()
	for k, v in pairs(Config.Prodaja)do
  exports.qtarget:AddBoxZone("prodajameta", v.kordinateped, 0.85, 0.65, {
	  name="prodajameta",
	  heading=11.0,
	  debugPoly=v.pokazizonu,
	minZ= v.kordinateped.z -1,
	maxZ= v.kordinateped.z +2,
	  }, {
		options = {
			{
				event = 'prodajazoveserver',
				label = "Prodajte met",
				job = v.posao,
			},
		  },
		  distance = 4.5
  })
  end 
  end)

  
  RNE("prodajazoveserver", function()
	TriggerServerEvent("met:prodajav2")
  end)

  --[[usableitem]]
  RNE("sposobnost", function()
	lib.progressCircle({
		duration = 30000,
		useWhileDead = false,
		canCancel = false,
		disable = {
			move = true,
			car = true,
			combat = true,
		},
        anim = {
            dict =  'mp_player_inteat@burger',
            clip = 'mp_player_int_eat_burger_fp' ,
        },
        prop = { model = 'prop_meth_bag_01', pos = { x = 0.020000000000004, y = 0.020000000000004, y = -0.020000000000004}, rot = { x = 0.0, y = 0.0, y = 0.0} },
    })
    Wait(500)
SetPedMotionBlur(PlayerPedId(), true)
AddArmourToPed(PlayerPedId(), 50)
SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 100)
Wait(500)
ESX.ShowNotification(Config.Prevod["iskoristiliste"]["message"],Config.Prevod["iskoristiliste"]["type"])
end)


  ----[blipovi]
  Citizen.CreateThread(function()
	for k, v in pairs(Config.Blipovi)do
    blip = AddBlipForCoord(v.kordinatablipa)
    SetBlipSprite(blip, v.idblipa)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, v.velicina)
    SetBlipColour(blip, v.boja)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(v.ime)
    EndTextCommandSetBlipName(blip)
	end
end)   

--[[kuvanje meta]]
Citizen.CreateThread(function()
	for k, v in pairs(Config.Kuvanje)do
  exports.qtarget:AddBoxZone("kuvanjemeta", v.kuvanjekord, 0.85, 0.65, {
	  name="kuvanjemeta",
	  heading=11.0,
	  debugPoly=v.prikazizonu,
	minZ= v.kuvanjekord.z -1,
	maxZ= v.kuvanjekord.z +2,
	  }, {
		options = {
			{
				event = 'klijentzovemet',
				label = "Kuvajte met",
				job = v.posao,
			},
		  },
		  distance = 4.5
  })
  end 
  end)

  RNE("klijentzovemet", function()
	TriggerServerEvent("met:kuvanje")
  end)

  RNE("met:kuvanje2", function()
	lib.progressCircle({
		duration = 420000,
		useWhileDead = false,
		canCancel = false,
		disable = {
			move = true,
			car = true,
			combat = true,
		},
        anim = {
            dict =  'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer' ,
        },
        prop = { model = 'prop_meth_bag_01', pos = { x = 0.020000000000004, y = 0.020000000000004, y = -0.020000000000004}, rot = { x = 0.0, y = 0.0, y = 0.0} },
    })
	TriggerServerEvent("met:dajeitem")
end)



--[[prerada]]

Citizen.CreateThread(function()
	for k, v in pairs(Config.Prerada)do
  exports.qtarget:AddBoxZone("preradameta", v.preradakord, 0.85, 0.65, {
	  name="preradameta",
	  heading=11.0,
	  debugPoly=v.vidizonu,
	minZ= v.preradakord.z -1,
	maxZ= v.preradakord.z +2,
	  }, {
		options = {
			{
				event = 'met:zoveprerada',
				label = "Preradite met",
				job = v.posao,
			},
		  },
		  distance = 4.5
  })
  end 
  end)
  RNE("met:zoveprerada", function()
	TriggerServerEvent("met:prerada")
  end)

  RNE("met:prerada2", function()
	lib.progressCircle({
		duration = 420000,
		useWhileDead = false,
		canCancel = false,
		disable = {
			move = true,
			car = true,
			combat = true,
		},
        anim = {
            dict =  'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer' ,
        },
        prop = { model = 'prop_meth_bag_01', pos = { x = 0.020000000000004, y = 0.020000000000004, y = -0.020000000000004}, rot = { x = 0.0, y = 0.0, y = 0.0} },
    })
	TriggerServerEvent("met:preradio")
end)