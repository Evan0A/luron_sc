
local accounts = [[
fhytf3368@gmail.com|e7:1a:bd:7e:b9:ec:cf3461e42ce5aed4c726dfb3be2308d9:CDA37FDDB2265D3D3EF2B6F3AA811FDE:poJjFNG7mWhqKFxhLM0KGDjhw11Z1eYUnJoaoG+5/sSsK2P7tg4D+TpcNwFnaSsm7xavY2NTEXwUsAy5xchOw4teKQSAT/7FK6akJPZJ5/OG/9/a7ItzYXFMSv6smxrsyMt5R56/WLsT7NSKInVggKcT8iHmTUn9ZMVD5iO6vvw2nCEdOx2/pH9NptuJEUNkFyXv9iT5tCGJJeYnUO8I/U9A60urg8AsIPqfcltWF+EY8htGRzH3RsRxTVYyS8wFdgipR0sak6Q2acd8sJJQJJQAwHem7+Xf9SE7vxAMa+zDh1Qu1foKeh7c+O0M17UvcJcB+niqFMf3B40pCnX6A9AVY2Xs96ZOhXBVO25Dg0Au469MzeMGMgR1WpM4Go32Kd3ETHQ9h92dkM/aJtKbtVEQjZuiSM6bxJqR80dXxUO5IE7qv8mFywr+A7vHwzpctJ7Duzd9a94l2DHC+4aRaQ==
gwendolynfitzgerald28@gmail.com|2c:f3:ba:a4:36:68:9556955ecfeb7bcf7be3f9cb3e621515:381CADC93C5FCADFD1FF0B393CDB9E5C:poJjFNG7mWhqKFxhLM0KGFyelWCbEXFM+3px1SSkBxxDYJ4EuMn4epN0B1KGPMSQzAd015aWR4R1VuO+g3J16zAGWRHwvG6V3pRYe94goLJ8Pq6uQTzDg+29HLUm5zvwOhI+No42B+G3Qku1kWDcBm7AdTXid33BnjT6rz4SF0TTLMs2+d3wgyUGTsub3fFNscK+z01n5hiYMWp/tntI5bXQZOHe42TlvTWdnmTyb2wo2k9SYsV4BgrvK0vprRQNf6/cVQPTO2Awe69aHGedOM5S5PmbP2uXyDbVlALRmnaPrB6GF0JFutSU3WuOJd9MvzUI3gA6ROI/X3yY1ZWR+plXbmWW2VFBCYjeHulDtcQmFbGrxIqYMX/61JTajXc26teR4Vm5SYMkNeJoiZB6tCSzZP523goXI2yyYMEsBHiVgZ80It5htMLRArAnVJku3q5ILVjPmGwEQKwmDSkirA==
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
