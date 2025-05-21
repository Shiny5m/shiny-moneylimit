local GetMoney

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
    GetMoney = function(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.getMoney()
        end
        return 0
    end

elseif Config.Framework == 'qbcore' or Config.Framework == 'qbox' then
    local QBCore = exports['qb-core']:GetCoreObject()
    GetMoney = function(src)
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.GetMoney('cash')
        end
        return 0
    end

elseif Config.Framework == 'oxcore' then
    GetMoney = function(src)
        local player = exports.ox_core:GetPlayer(src)
        if player and player.get then
            return player.get('money') or 0
        end
        return 0
    end
else
    print('[shiny-moneylimit] ❌ Invalid framework selected in config.lua')
end


local function isBypassed(identifiers)
    for _, id in pairs(identifiers) do
        if Config.BypassIdentifiers[id] then
            return true
        end
    end
    return false
end

local function logToDiscord(playerId, money)
    if not Config.Webhook or Config.Webhook == "" then return end

    local name = GetPlayerName(playerId) or "Unknown"
    local ids = GetPlayerIdentifiers(playerId)

    local idText = ""
    for _, id in ipairs(ids) do
        idText = idText .. id .. "\n"
    end

    local embed = {
        {
            title = "💰 Player exceeded money limit",
            description = ("**Player:** %s\n**Money:** %d\n\n**Identifiers:**\n%s"):format(name, money, idText),
            color = 16711680
        }
    }

    PerformHttpRequest(Config.Webhook, function() end, "POST", json.encode({ embeds = embed }), {
        ["Content-Type"] = "application/json"
    })
end

local function checkPlayerMoney(playerId)
    if not GetMoney then return end
    local money = GetMoney(playerId)
    if not money then return end

    if money > Config.MoneyLimit then
        local identifiers = GetPlayerIdentifiers(playerId)
        if isBypassed(identifiers) then return end

        Config.OnLimitReached(playerId, money, Config.MoneyLimit)


        logToDiscord(playerId, money)
    end
end


AddEventHandler("playerConnecting", function(_, _, deferrals)
    local src = source
    SetTimeout(1500, function()
        checkPlayerMoney(src)
    end)
end)


CreateThread(function()
    while true do
        Wait(Config.CheckInterval * 1000)
        for _, playerId in ipairs(GetPlayers()) do
            checkPlayerMoney(tonumber(playerId))
        end
    end
end)
