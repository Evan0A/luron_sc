
local accounts = [[
fhytf3368@gmail.com|6f:71:f3:1b:4e:ab:7f2cbecb0b60e8323e54055aad2b38d8:F9BCABB54DFF919057A5BC1EEFFE0328:poJjFNG7mWhqKFxhLM0KGDjhw11Z1eYUnJoaoG+5/sQscimpaod07umuFghE5nk1nyMhNnwrIdYqrECHZS2YmsElhZWFtOcBvtBtm303wDH9t6wwS2XzQmmEcvzgyBXT1XLnb5u/bFHqvXXcMOVK2zvp5xfKZzO7OxgzpZe26uHmz2RJRQCeO8yrPXmi+KJUDVacDK7B0xrcR7Bg6LkUBs9xRephLXxl3zGbSK0gC2Apxg1xbE5gNC5scdIOnx7kSOSSrmkr4TYLkLvZKmQyncMoHzxEEfvCYAKjH5eTgCGNB56hKFM9lI/25Um5iVtegrsRdYkIoIKXaXkUEUX0m1sViQAYUvdMRR7BXkIA3UPn8DdShnpkogOuiHJm2LO8hZIRkJZ8AUsStIb4WHpr+jAP3BaUJn/a+mKq0uv2KyTWm/nwq+n/zcPcNr79a50Xdt9F4lIZ98Ef+8E+JYDCPQ==
gwendolynfitzgerald28@gmail.com|e9:e3:6e:15:7a:96:bbdda235af3be3a0dc09f415b2ba374d:ED7BED9CCE71CF785F4FCFAA2AB6DCAA:poJjFNG7mWhqKFxhLM0KGFyelWCbEXFM+3px1SSkBxwQLk7x3tJL3CrZDJyKJP1dqDTXdtHPD9QZZu3YwQWQRd+RXPmRM11XLQ3FTILB0w6BMAsJ0mpqxDWQ7t3cdhJ2DTlsRASfuApSuWjQ7v2IeWuL9AYH1qOnlr6y4lQJommKXz2tJF26YB6aveC7+Nm2Q9i7Mx6pjHisV/zP+Y1oJemloznSYniMasng+tvbYf0pXvlAT+QUCtRmn9fiOIasTvreS22JyJT+IDNH9dH8ux1wL575BJ0J42al0f2IqSFo7A/gGzVcW05ivdLZ/MSGHav46cHfSokstVw2ZhXlHtUYk8yixKtMUsJvp7JNEgFp5GNT45jHRNaAcEfr/LM3LMofUB//hTtSxhS/nkeCxwtFo1ebGsc+w3my3/xdLF0dNADv4tRP9OoiGByF82ZNsM3PF8khU/CM2kycKM1jrA==
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
