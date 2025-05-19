local Framework = require("frameworks/framework")
local getMoney = Framework.getMoney

local function sendLogToDiscord(src, name, amount)
    local identifiers = GetPlayerIdentifiers(src)
    local idList = table.concat(identifiers, '\n')
    local message = {
        username = "Shiny MoneyLimit",
        embeds = {
            {
                title = "Player Money Limited",
                color = 15158332,
                description = ("**Player:** %s\n**Amount:** %d\n**Identifiers:**\n%s"):format(name, amount, idList),
                footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
            }
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
end

local function isBypassed(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if Config.BypassIdentifiers[id] then
            return true
        end
    end
    return false
end

local function checkPlayerMoney(src)
    if isBypassed(src) then return end
    local money = getMoney(src)
    if money > Config.MoneyLimit then
        Config.OnLimitReached(src, money, Config.MoneyLimit)
        local name = GetPlayerName(src) or "Unknown"
        sendLogToDiscord(src, name, money)
    end
end

CreateThread(function()
    while true do
        Wait(Config.CheckInterval * 1000)
        for _, playerId in ipairs(GetPlayers()) do
            checkPlayerMoney(tonumber(playerId))
        end
    end
end)
