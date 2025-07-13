
local accounts = [[
fhytf3368@gmail.com|f3:f0:b8:78:a8:93:0681912b460b27a59fcdbc7224f72622:FBB6EFC75732FDCE4F20DCE6C5DA8D56:poJjFNG7mWhqKFxhLM0KGDjhw11Z1eYUnJoaoG+5/sSkO2yLO47EJIFz44NsQ9TQrTD0zXybo12yxME/7uDiuwNRG0s3ofaLiSJyIVcNZI4I2UoxokxebCReRwCiRLtXFqpcVabWCHEk3XJycqr6Y4VCVX+dIV2zLszo9jMZmqgjQqrj2dMiqI0NxHh5Xk3J0ElxBkJVUBPPLeB0Qfxf783uh5e5IiI+mMyDOyHn6+aSP0sCvE70UQ3BhNUK5knNaj0u73JdoTJjLa1Mt0QQieHyPth0hiyRF9NUAjxWS2OEDLqOtvBbZxWnr6dVZ4tLPCb4SQNKMi+6zdyRunBjN+z97ErHFxBFe46FsSsk/jfIYG0N0FrINgupl9npcJQaRt3GwLdKbZmQDPgMxVM4gtrZJVMey7EE75yYaxidCwE3sfJdCcbarLWFtI3XHA5qwHR33f4szR2sYDtNw61R1w==
gwendolynfitzgerald28@gmail.com|9d:54:47:a2:1a:66:62add5dab04cf0e2b6ee2c0976251625:92BD9D90DDCB0BAF6A31AA724DDABBB8:poJjFNG7mWhqKFxhLM0KGFyelWCbEXFM+3px1SSkBxytTtie1c+v8BhxSBB/j+GM/x+xoCb7c/b6wxcqLN8Ag0R5zQpzb55gFSrXgixsx+vNqbmfudDMYqmiZXxTDcip1K85lndHln5wUjAhOz9PPwsLIXY+FvOmyXKtoO7XmK9eVlcAeOd6cMMM3i21nZi3xh5yuggF/q6F3skD2yVIozVsSD+N/DZQpXJBa31oAan84bTbvpocOjgJGLPQDxvXW7UpZrOMtQu8JIJ/UrIsONlqENUynHJ+K4vruwNtgh8Zk6V7xBNiHuEVGMET316PAcVOrmEt62s2weawVnqzwnUl8RlOcCSZS6yCf6t9vtg+tLtG/c8lVaqyjIF6djQG9B7mlo4FVG5xJUlhW79u2EBWzOKfgkzaYx2kTPM0ws5cyIBKR0XMWvF3Ird9IhA74CCMUBGf7Kq32GbzhD/fFQ==
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
