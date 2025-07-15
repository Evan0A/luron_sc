
local accounts = [[
fhytf3368@gmail.com|26:96:2e:47:f5:b3:f60948c3f51fa8dd91ffec45a939335d:FEEBB3D1BCFEAFD8D84C3CE10AF8FFCC:poJjFNG7mWhqKFxhLM0KGDjhw11Z1eYUnJoaoG+5/sTamU1tUE5Tb5vsKBM9RbP/ECBnSoRXnaOvtvp/lkd9GFebSX3wdvS+xLTijHaa/daaQ3C1L6zvr/KVN/qQx2BGpwUDoUpznQnkjRkngyVWeRtkkrVPExXa4JTpHikDlI+bBRZAsz2mst9FcAPOyI74EuvCzS//heBoOuq13S+3Pzo4sOsRcOYpdBqHKAm7+nvSleKHUvfRB3MHbo9CCk0c+pHjy1n5Hp+0B71qcjLCBo95A8jREWe/Ye/rt4PZOEUkSPSIiEo0OgaSY9UnmBwRxKW2DGXz75pafIt/Pr08J+7pKnWjlo9VU25hZHgIlkSBILm8dSN43b10SRhrR0pmckrc8rtJc5Z7UXDq8sz4YM3VozeQIlYwF+qGXJo/DKvQcAy+jgV9Rcry0SajOBaeNl2YGMhYScMlHA0/Pkz65Q==
gwendolynfitzgerald28@gmail.com|fc:86:ad:9d:46:db:df20b4e7aa24fabf12e04e519ca08c9d:60ABED739BAE3B87B565EF2C17FDCAE3:poJjFNG7mWhqKFxhLM0KGFyelWCbEXFM+3px1SSkBxylOw4vSTS1qsH6kLK3OUHKIA265hlOGxJ81xLYO10Z68U7w4230pDrTyBfh2byaYiveOVKAsVPwSOMyugW+uMWcEQTifHDe76OARyBnYpzVGm1b2sXWmUSiguzvVBh+V/8XAkcKda9lY0yBWCAs6RQBibx247yBJMnEj9rda/LmtJ5aXBdTnLmeecvY0d5s7xWbpexFH/WfKTEnPVF6J0PWpDgo895I6MK+LroEJYqljtvVLJRJ7ucWMLCqCGK05zvpPxI4zvIaVHjhojVajZhcnvw2rFr+IQzMbjuRkcU/Wf5EEW9/AApVT+JcJYSn44sUZ52a94FrIDi/ThYmkVFrsevE5BxA5h7b1Whwl2noRJ3F94FcMqIIw1x5+dEUiUOvAzPVkoFNP31JKlgHkVUWwFG1akWW+P+KD1OQ1+yWQ==
]]

for account in accounts:gmatch("[^\n]+") do
    local email, sisa = account:match("([^|]+)|(.+)")

    if email and sisa then
        local mac, rid, wk, ltoken = sisa:match("([^|]+):([^|]+):([^|]+):(.+)")
        if mac and rid and wk and ltoken then
            local details = {
                ["display"] = email,
                ["secret"] = email,
                ["name"] = ltoken,
                ["rid"] = rid,
                ["mac"] = mac,
                ["wk"] = wk,
                ["platform"] = 0,
            }
            local bot = addBot(details)
            bot:getConsole().enabled = true
            sleep(3)
        end
    else
        local mac, rid, wk, ltoken = sisa:match("([^|]+):([^|]+):([^|]+):(.+)")
        if mac and rid and wk and ltoken then
            local details = {
                ["name"] = ltoken,
                ["rid"] = rid,
                ["mac"] = mac,
                ["wk"] = wk,
                ["platform"] = 0,
            }
            local bot = addBot(details)
            bot:getConsole().enabled = true
            sleep(3)
        end
    end
end
