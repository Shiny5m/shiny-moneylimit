local framework = Config.Framework

local function esx()
    ESX = exports['es_extended']:getSharedObject()
    return {
        getMoney = function(src)
            local xPlayer = ESX.GetPlayerFromId(src)
            return xPlayer and xPlayer.getMoney() or 0
        end
    }
end

local function oldesx()
    local ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    return {
        getMoney = function(src)
            local xPlayer = ESX.GetPlayerFromId(src)
            return xPlayer and xPlayer.getMoney() or 0
        end
    }
end

local function qbcore()
    local QBCore = exports['qb-core']:GetCoreObject()
    return {
        getMoney = function(src)
            local Player = QBCore.Functions.GetPlayer(src)
            return Player and Player.PlayerData.money["cash"] or 0
        end
    }
end

local function qbox()
    return {
        getMoney = function(src)
            local Player = exports.qbox:GetPlayer(src)
            return Player and Player.cash or 0
        end
    }
end

local function oxcore()
    return {
        getMoney = function(src)
            local player = exports.ox_core:GetPlayer(src)
            return player and player.get("money") or 0
        end
    }
end

local frameworks = {
    esx = esx,
    qbcore = qbcore,
    qbox = qbox,
    oxcore = oxcore
}

return frameworks[framework]()
