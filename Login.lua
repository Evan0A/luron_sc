
local accounts = [[
fhytf3368@gmail.com|78:f5:4e:51:dd:67:2416a1fbfa46b64aee5ea397873e042e:93064AAB0AECA4ED80CF7B9CDC2DBF7D:poJjFNG7mWhqKFxhLM0KGDjhw11Z1eYUnJoaoG+5/sQbYDzw+tk3vb7dvrPWgP4hJTqJBc6fh52yayy+OLl2u8y9XgxL+U5ksBXWWDELywtv/8g5l4jiOtZrIce6rBEXxSnb6ZQ4dRNhWRM6d8RXKmXCGn0RCCC2WSUC6YYqw+BUFJAx83Twe1omVssSdOmMGpXlCwTSMUXvo3xFfWm2ZQFo3QZ+4RpRMnUBuSmbuEtzaGr0VrQ45jitqRnl+F9NvCi2toyts+XM/kb4MDEIsxiPkOfvTR0UqWjLbOkpKtupARAjPWDBlf3RLNt2S9m3GThDd6nxGVm+e4B1BcAIMTbH5v9KPQdXXd7Sh6t8xoKJcaHAcINrnogCeFbn1H5qg9AQdBGe0P9CifoeJuS8DNtip0VGslJrTSGvZYl7GFMnICjWwREIp6RRoU0H6R54na7HAbou+WQ9MnMaQKmW4A==
gwendolynfitzgerald28@gmail.com|5e:a6:36:57:1a:25:5d177f78ae6b660325d5755790c81a45:B732753BEEDD2ED1CF3C89FA98C8D322:poJjFNG7mWhqKFxhLM0KGFyelWCbEXFM+3px1SSkBxwIAMePx0xGxQES2T4NunyB9vRXjSyM1T9khtYPjfxQIL1+XrfDZyim2SRGMojECcZgS1/zmHIZ4oD0GuE//HGBuGQGVjZZEguc6YWuJ+0ZHX3XzGegcEOiA4YnQlakvVX3CzVDuaJkVVli0wdgjT6Yrt4u0nN/6oMCj/dVy20/HfIaa08lyQ4CfuXnq7Ywkh6kooQyiPLCndvorq2VAQfXb2qvQLlljCAyXdRRcOO+VMURUc5fbngRG73qAGHbPepnLBa0dxMQb+1C/VtPthXPtlY27JtaU9QbAQhPcgQjGJz/OcNpfSS91xDUMc/qAHw7wLUNzSCwtBVEJOtHBdlvrhv7E0YOGrnt3uqU/XwfSFw7R9Jfs9KVmAw7ZMqIrcbn0ByouJF3gjk1y2JRFFc2Nc9DacqLHdbrnIHR/VZX/Q==
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
