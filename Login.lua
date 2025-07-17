
local accounts = [[
gwendolynfitzgerald28@gmail.com|8d:1f:a5:1c:21:3b:ccc5717fc86d1f44a64873d720dc289e:B46A97AC6BA2BF9D9BAA522E9112ED5C:poJjFNG7mWhqKFxhLM0KGFyelWCbEXFM+3px1SSkBxwy5u4/KtMeLPJCMw8hqBuCcZOq3EXlNFCyfkzEXUSvqx2rBC1y3jt7D+RabQhHveQ+gqzeK4NGrSjfkxoKxc8HJLfGzBtFi3W97C/vmRLB0YyMJO0LYmoGMYbKGQXXWiBard6a+8nbxQi2F0+0xtxtmdpmEgOLPABGbKkOEJ76SfW0yBQaVJJOqEQYEPFvk5L3wd2+GPocTOYiETIzfJXyP+kBYSmJ6t9QM5wXOdluw7vjppE9SpjvfpEEPT+MDEsGVyETDiUOm5LGo0UkcycNfNsbx6oyc5dKFcjMY7Xcih28Hunr9/Uw2TDNrIZcPTsk/f5OHnAiHQuYK/+ePSqiQew269E8hucDxCN8pRDxeb4RmwZ5RYnvq6lGVSnpN2tAhhUEmAT4jyJAktu5UnMLFEUQZjkSCDqHONwGzLdGqA==
fhytf3368@gmail.com|5b:da:2a:a0:5d:97:0b4ad5048e14ae9fd09100b3792258c3:CB571DA51DAEE28EBEAEED6F9139623F:poJjFNG7mWhqKFxhLM0KGDjhw11Z1eYUnJoaoG+5/sQHdc830DX3UWtjAhsCNd/BXhbWnQvshLixRY9q3J6X31LQLHuYpbbk0VwdWbQelBpKYnBwImMHdDLHjB4pukXUT43JSoKNrt90JMKBNcdO6eUx1tk63mYWWMNmkE3p2DkbB7WYn2bYLgUYhZsbQzqJZSuJ0hp2IvdaqCOlILZuo03tN8QkoPoORIG68NWJ+wBawpJoosJexFuCy99oc5CqCUqoVQdjTp0t+QOpe01uh5t1HWNRyIga9o6wVwOA52n441SQ3xx1NFqytHHmKCfx4PQwaUfMZjn5ylTphK2r1lM1F7SsCgsBUVMrmc1+vYrs5oV3PNgjsmnKODyTIErsrVVDyD9QjmTsG5Pmm4awPnHF+FlU0/nEAaSDMX+fSEHVWHOchK4st+Fz7NNUxeijuywZHgt00vQW6+TVJ50aAA==
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
