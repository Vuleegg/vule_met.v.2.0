ESX = exports['es_extended']:getSharedObject()
local RSE = RegisterServerEvent
local TE = TriggerEvent
local AEH = AddEventHandler

Citizen.CreateThread(function()
    print("[^1"..GetCurrentResourceName().."^7] Trenutna verzija | 2.0.0")
end)


RSE('met:prodajav2', function()
    local igrac = ESX.GetPlayerFromId(source)
    local met = igrac.getInventoryItem('pure_meth').count 
    local distanca = #(GetEntityCoords(GetPlayerPed(source)) - vector3(2164.657, 4989.139, 40.361))
    local isplata = 0 
    isplata = 147 * met



    if distanca < 4.5 then
        if met >= 1 then

            igrac.removeInventoryItem('pure_meth', met)
            igrac.addInventoryItem("black_money", isplata)
            TriggerClientEvent("esx:showNotification", source, "Prodali ste met dileru")
        else
            TriggerClientEvent("esx:showNotification", source, "Nemate dovoljno cistog meta za prodaju")
        end    
    else
        DropPlayer(source, 'Posaftas mi labuda kidaro')
    end
end)

RSE("met:kuvanje", function()
local igrac = ESX.GetPlayerFromId(source)
  if igrac.getInventoryItem('methlab').count >= 1 and igrac.getInventoryItem('propan').count >= 10 and igrac.getInventoryItem('lithium').count >= 10 and igrac.getInventoryItem('etanol').count >= 10 then
      TriggerClientEvent("met:kuvanje2", source)
  else 
    TriggerClientEvent("esx:showNotification", source, "Nemate potrebne iteme za kuvanje meta")
  end
end)

RSE("met:prerada", function()
    local igrac = ESX.GetPlayerFromId(source)
      if igrac.getInventoryItem('pouches').count >= 30 and igrac.getInventoryItem('unprocessed_meth').count >= 30  then
          TriggerClientEvent("met:prerada2", source)
      else 
        TriggerClientEvent("esx:showNotification", source, "Nemate dovoljno nepreradjenog meta ili kesica")
      end
    end)

RSE('met:dajeitem', function()
    local igrac = ESX.GetPlayerFromId(source)
    local kuvanje = igrac.getInventoryItem('methlab').count  and igrac.getInventoryItem('propan').count  and igrac.getInventoryItem('lithium').count  and igrac.getInventoryItem('etanol').count 
    local distanca = #(GetEntityCoords(GetPlayerPed(source)) - vector3(3559.503, 3673.973, 29.367))
    local isplata = 0 
    isplata = 4 * kuvanje



    if distanca < 4.5 then
        if kuvanje >= 10 then

            igrac.addInventoryItem("unprocessed_meth", isplata)
            igrac.removeInventoryItem('propan', kuvanje)
            igrac.removeInventoryItem('etanol', kuvanje)
            igrac.removeInventoryItem('lithium', kuvanje)
            TriggerClientEvent("esx:showNotification", source, "Gotovo je kuvanje!")
        else
            TriggerClientEvent("esx:showNotification", source, "Nemate dovoljno itema za kuvanje")
        end    
    else
        DropPlayer(source, 'Posaftas mi labuda kidaro')
    end
end)


RSE('met:preradio', function()
    local igrac = ESX.GetPlayerFromId(source)
    local prerada = igrac.getInventoryItem('pouches').count  and igrac.getInventoryItem('unprocessed_meth').count   
    local distanca = #(GetEntityCoords(GetPlayerPed(source)) - vector3(1391.379, 3605.587, 39.061))
    local isplata = 0 
    isplata = 2 * prerada



    if distanca < 4.5 then
        if prerada >= 10 then

            igrac.addInventoryItem("pure_meth", isplata)
            igrac.removeInventoryItem('pouches', prerada)
            igrac.removeInventoryItem('unprocessed_meth', prerada)
            TriggerClientEvent("esx:showNotification", source, "Preradili ste")
        else
            TriggerClientEvent("esx:showNotification", source, "Nemate dovoljno nepreradjenog meta ili kesica")
        end    
    else
        DropPlayer(source, 'Posaftas mi labuda kidaro')
    end
end)



ESX.RegisterUsableItem("pure_meth", function()
    igrac.removeInventoryItem("pure_meth")
  igrac.TE("sposobnost")
end)

RSE('meth:bure')
AEH('meth:bure', function()


    local luck = math.random(1, 3)

    local items = { 
        'lithium',
        'etanol',
        'propan'
    }

    local igrac = ESX.GetPlayerFromId(source)
    local randomItems = items[math.random(#items)]
    local quantity = math.random(#items)
    local itemfound = ESX.GetItemLabel(randomItems)

    igrac.addInventoryItem(randomItems, quantity)


end)
