Config = {}

-- Money limit configuration (changeable per framework if needed)
Config.MoneyLimit = 1000000
Config.Framework = 'esx' -- options: 'esx', 'qbcore', 'qbox', 'oxcore', 'oldesx' --- If the script gives an error from esx change this to oldesx

-- Interval in seconds to check all players' money
Config.CheckInterval = 300

-- Webhook for logging
Config.Webhook = 'https://discord.com/api/webhooks/YOUR_WEBHOOK_URL_HERE'

-- Bypass list (can be any identifier type: discord: steam: license: etc)
Config.BypassIdentifiers = {
    ["discord:123456789012345678"] = true,
    ["steam:110000112345678"] = true,
    ["license:abcd1234efgh5678"] = true
}

-- Custom action when player hits limit
Config.OnLimitReached = function(src, currentAmount, limitAmount)
    DropPlayer(src, "💰 | You have been kicked because you gone over the money limit.")
end
