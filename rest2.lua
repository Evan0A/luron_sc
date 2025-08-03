print("VERSION 5")
---[=== CONFIG ===]---
auto_rest_many_mods = true
minimum_many_mods = 5

auto_rest_specific_mod = true
specific_mod_list = {"kailyx", "misthios", "windyplay"} -- uppercase is not nessesary

auto_rest_schedule = true
schedule_zone = "UTC+7"
schedule_list = {
    "15:00 - 15:50",
    "16:11 - 16:20",
    "23:00 - 02:00",
    "10:00 - 11:00"
}

auto_rest_player = true 
minimum_player = 30000
maximum_player = 130000
minimum_diffrence = -1000 -- minimum diffrence from last count player to new player count (only minus player counted)

auto_rest_banrate = true 
minimum_banrate = 1.0


---[=== SETTINGS ===]---


use_webhook = true
webhook_link = "https://discord.com/api/webhooks/1366255322607517717/hl1MVXqFyjcw8KEYjkqVbBC4S-gjPrJlMlU46mG9ADbftSlT_-LVNLtFqnZEtubcx5se"
edit_message_reconnect = false -- true if edit message rest to reconnect/false if send new message

custom_captain = false
custom_captain_index = 1

hide_bot_identity = true
reconnect_after_rest = true

check_delay = 1 -- minutes
execute_delay = 1000 -- milisecond
delay_connect_disconnect = 1000 -- milisecond

delay_many_mods = 1 --minutes 
delay_specific_mod = 1 -- minutes
delay_schedule = 1 -- minutes
delay_banrate = 1
delay_player = 1

-----[===== CODE AREA =====]-----
cpu_stopper = false
cpu_minimum = 100


json = nil 
api = ""
api_mods = ""
api_player = ""
api_use = ""
image_url = ""
access_url = "https://raw.githubusercontent.com/Evan0A/Nuron_access/refs/heads/main/Rest_Script?t="..os.time()
nexmodule = {"dkjson.lua"} 
myUsername = getUsername() 
myExpired = ""
enable = true
reason = ""
start_utc = 0
bot_indexs = {}
captain = 1 
midrest = 0
whrestdone = false
lastrestid = 0
restmode = false
first = true
rotation = getBot().rotation
mod_detected = ""
mods_list = {}
player_count = 0
banrateApi = 0.0
last_banrate = 0.0 
last_player = -1
last_diff = 0
end_schedule = nil
bot_indexs = {}

--http catch -- 
total_521 = 0

--webhook 
wh_mod_detected = ""
wh_many_mod = -1 
wh_player = -1 
wh_banrate = -1
wh_diff = -1

function getJson()
    print("entering getJson")
    local client = HttpClient.new()
    client.url = "https://raw.githubusercontent.com/LuaDist/dkjson/refs/heads/master/dkjson.lua"

    local code = client:request()  -- Dapatkan isi file Lua sebagai string
    local chunk, err = load(tostring(code.body))

    if not chunk then
        print("Error load code:", err)
        return
    end

    local success, result = pcall(chunk)  -- Jalankan chunk dengan aman
    if success then
        print("success getting json")
        client.url = nil 
        json = result
    else
        print("Error executing bot kode:", result)
    end
end

function getHttp(url)
    if not auto_rest_many_mods and  not auto_rest_specific_mod and not auto_rest_player and url ~= access_url then 
        return false 
    end 
    local client = HttpClient.new()
    client.url = url
    local result = client:request()
    if result.error ~= 0 then
        return true
    else
        if result.status == 200 then
            local success, data = pcall(json.decode, result.body)
            if success and type(data) == "table" then
                errorApi = false
                return data
            else
                webhookAny("Error decoding http data, status: "..success.." data: "..data)
                getBot().custom_status = "stopped"
                getBot():stopScript()
            end
        else
            if result.status == 521 then
                total_521 = total_521 + 1
                if total_521 >= 10 then
                    webhookAny("API currently down, script stopped")
                    getBot().custom_status = "stopped"
                    getBot():stopScript()
                end
            else
                webhookAny("Api currently down, code stopped")
                getBot().custom_status = "stopped"
                getBot():stopScript()
            end
        end
    end
end

local function get_cpu_usage()
    local status, result = 
    pcall(function() 
        local handle = io.popen("powershell -Command \"(Get-Counter '\\Processor(_Total)\\% Processor Time').CounterSamples.CookedValue\"")
        local result = handle:read("*a")
        handle:close()
    
        local usage = result:match("(%d+%.?%d*)")
        return math.floor(tonumber(usage))
    end)
    if status then 
        return result
    else 
        return -1
    end 
end

function webhookRest(nameBot, from)
    if use_webhook then 
        wh = Webhook.new(webhook_link)
        local reason_emoji = {
            ["1"] = "🛡️",--many mod
            ["2"] = "🚨", -- specific mod 
            ["3"] = "⏰", --schedule
            ["4"] = "🚫", -- banrate 
            ["5"] = "😳", -- player
            ["6"] = "😳" --diff player
        }
        local fromS = {
            ["1"] = "MANY MODS DETECTED",
            ["2"] = "SPECIFIC MOD DETECTED",
            ["3"] = "SCHEDULE REST DETECTED",
            ["4"] = "BAN-RATE DETECTED",
            ["5"] = "PLAYER ONLINE DETECTED",
            ["6"] = "PLAYER DIFFRENCE"
        }
        if hide_bot_identity then 
            nameBot = "HIDDEN("..tostring(getBot(nameBot).index)..")"
        else 
            nameBot = nameBot.."("..tostring(getBot(nameBot).index)..")"
        end
        local emoji = reason_emoji[tostring(from)] or "❓"
        local utc_time = os.date("!%Y-%m-%d %H:%M UTC")

        -- Info tambahan
        local extra_info = ""
        if from == 1 then
            extra_info = string.format("👥 Mods Online: %d / %d", #mods_list, minimum_many_mods)
            wh_many_mod = #mods_list
            lastrestid = 1
        elseif from == 2 then
            extra_info = string.format("Mod detected: **%s**", mod_detected)
            wh_mod_detected = mod_detected
            lastrestid = 2
        elseif from  == 3 then 
            extra_info = string.format("Rest until: %s (%s)", end_schedule, schedule_zone)
            lastrestid = 3
        elseif from  == 4 then 
            extra_info = string.format("Rest until Ban-rate lower, ban-rate: %f", banrate)
            wh_banrate = banrate
            lastrestid = 4
        elseif from  == 5 then 
            extra_info = ""
            if player_count >= maximum_player then 
                extra_info = string.format("Rest until player count get lower: %d / %d", player_count, maximum_player)
            else 
                extra_info = string.format("Rest until player count get higher: %d / %d", player_count, minimum_player)
            end
            wh_player = player_count
            lastrestid = 5
        elseif from == 6 then 
            extra_info = string.format(
                "Player count diffrence detected: %s/%s\nPlayer count: %s", tostring(last_diff), tostring(minimum_diffrence), tostring(player_count))
            wh_diff = last_diff
            lastrestid = 6
        end
        wh.embed1.use = true
        wh.embed1.title = string.format("[%s]REST DETECTED", emoji)
        wh.embed1.color = 16711680
        wh.embed1:addField("<:bot_gradient:1389670917755375746> | CAPTAIN NAME: ", nameBot, true)
        wh.embed1:addField("<a:offline:1365647922330603611> | REASON: ", fromS[tostring(from)], true)
        wh.embed1:addField(" <:animated_clock:1389671974552469524> | TIME (UTC): ", utc_time, true)
        wh.embed1:addField("<:emojigg_CPU:1390949692317106196> | CPU USAGE: ", (get_cpu_usage()), true)
        wh.embed1:addField("<:star:1389672145839329360> | EXTRA INFO: ", (string.format("%s", extra_info)), true)
        wh.embed1.footer.text = "Made with love by NEXORA"
        wh.embed1.footer.icon_url = "https://ibb.co/rGt7PN07"
        if getBot().index == captain then 
            if not whrestdone then 
                wh:send()
                whrestdone = true 
                midrest = wh.message_id
            elseif whrestdone and from ~= lastrestid then 
                wh:edit(midrest)
            elseif whrestdone and from == lastrestid and lastrestid == 1 and wh_many_mod ~= #mods_list then 
                wh:edit(midrest)
                wh_many_mod = #mods_list
            elseif whrestdone and from == lastrestid and lastrestid == 2 and wh_mod_detected ~= mod_detected then 
                wh:edit(midrest)
                wh_mod_detected = mod_detected
            elseif whrestdone and from == lastrestid and lastrestid == 5 and selisih(wh_player, player_count, 2000) then wh:edit(midrest)
                wh_player = player_count
            elseif whrestdone and from == lastrestid and lastrestid == 6 and last_diff ~= wh_diff then
                wh:edit(midrest)
                wh_player = player_count
            end
        end 
    end 
end

function webhookRecon(nameBot, from)
    if use_webhook and whrestdone then 
        local wh = Webhook.new(webhook_link)
        local reason_emoji = {
            ["1"] = "🛡️",--many mod
            ["2"] = "🚨", -- specific mod 
            ["3"] = "⏰", -- schedule
            ["4"] = "✅", -- banrate
            ["5"] = "🤠", -- player
            ["6"] = "🤠" -- player
        }
        local fromS = {
            ["1"] = "MANY MODS REST ENDED",
            ["2"] = "SPECIFIC MOD REST ENDED",
            ["3"] = "SCHEDULE REST ENDED",
            ["4"] = "BANRATE DROPPED",
            ["5"] = "PLAYER ACTIVE",
            ["6"] = "PLAYER COUNT DIFFRENCE"
        }
        if hide_bot_identity then 
            nameBot = "HIDDEN("..tostring(getBot(nameBot).index)..")"
        else
            nameBot = nameBot.."("..tostring(getBot(nameBot).index)..")"
        end
        local emoji = "✅"
        local utc_time = os.date("!%Y-%m-%d %H:%M UTC")

        -- Info tambahan
        local extra_info = ""
        if from == 1 then
            extra_info = string.format("Mods Online: %d / %d", #mods_list, minimum_many_mods)
        elseif from == 2 then
            extra_info = "Previous mod: **" .. mod_detected .. "**"
        elseif from == 3 then 
            extra_info = string.format("Schedule ended at: %s (%s)", end_schedule, schedule_zone)
        elseif from == 4 then 
            extra_info = string.format("Last ban-rate: "..last_banrate)
        elseif from == 5 then 
            extra_info = string.format("Last player online: "..last_player)
        elseif from == 6 then 
            extra_info = string.format("Last player diffrence: "..last_diff)
        end

        wh.embed1.use = true
        wh.embed1.title = string.format("[%s]REST TIME DONE", emoji)
        wh.embed1.color = 3066993 -- warna hijau
        wh.embed1:addField("<:bot_gradient:1389670917755375746> | CAPTAIN NAME: ", nameBot, true)
        wh.embed1:addField("<a:Online1:1365647772468117636> | STATUS: ", fromS[tostring(from)], true)
        wh.embed1:addField("<:animated_clock:1389671974552469524> | TIME (UTC): ", utc_time, true)
        wh.embed1:addField("<:emojigg_CPU:1390949692317106196> | CPU USAGE: ", (get_cpu_usage()), true)
        wh.embed1:addField("🔍 | EXTRA INFO: ", (string.format("%s", extra_info)), true)
        wh.embed1.footer.text = "Made with love by NEXORA"
        wh.embed1.footer.icon_url = "https://ibb.co/rGt7PN07"
        if getBot().index == captain then 
            if edit_message_reconnect then 
                wh:edit(midrest)
                whrestdone = false
            else
                wh:send()
                whrestdone = false
            end 
        end 
    end 
end

function webhookAny(cont)
    if getBot().index == captain then
        wh = Webhook.new(webhook_link)
        wh.content = cont 
        wh:send()
    end
end

function cpuStopper() 
    if cpu_stopper then 
        local mycpu = get_cpu_usage()
        if mycpu >= cpu_minimum then 
            if getBot().index == captain then 
                webhookAny("CPU too high, script stopped. CPU: "..mycpu.."/"..cpu_minimum)
            end 
            getBot().custom_status = ""
            getBot():stopScript()
        elseif mycpu == -1 then 
            cpu_stopper = false 
            webhookAny("Cannot get CPU percentage")
        end 
    end 
end 

function haveSame(arr1, arr2)
    for _, a1 in pairs(arr1) do 
        for _, a2 in pairs(arr2) do 
            if a1:upper() == a2:upper() then 
                return true, a1
            end 
        end 
    end 
    return false 
end

function isIn(arr, val)
    val = tostring(val)
    for _, key in pairs(arr) do 
        if tostring(key):upper() == val:upper() then
            return true 
        end 
    end
    return false
end

function cekDouble(arr, val) 
    local available = false
    for i = 1, #arr do 
        if arr[i] == val then 
            available = false
        end 
    end 
    if not available then 
        table.insert(arr, val) 
        return true 
    end 
    return false 
end

function getCaptain()
    local botCount = #getBots()
    getBot().custom_status = ""
    sleep(1000)
    if #getBots() == 1 and not custom_captain then 
        captain = getBot().index 
        getBot().custom_status = "CAPTAIN REST"
        return true
    end
    if custom_captain and getBot(custom_captain_index):isRunningScript() then 
        captain = tonumber(custom_captain_index)
        getBot(captain).custom_status = "CAPTAIN REST"
        return true
    end
    local function cekRunning()
        for i = 1, botCount do
            local Cstatus = tostring(getBot(i).custom_status)
            if Cstatus == "CAPTAIN REST" and getBot(i):isRunningScript() then 
                getBot().custom_status = string.format("Following captain(%s)", getBot(i).name)
                return true, i
            end
        end 
        return false, 0
    end
    local status, num = cekRunning()
    if status then 
        captain = num
        return true
    end
    sleep(5000)
    getBot().custom_status = "REST VERIFICATION 1"
    sleep(7000)
    for i = 1, botCount do 
        if getBot(i).custom_status == "REST VERIFICATION 1" and getBot(i):isRunningScript() then 
            cekDouble(bot_indexs, tonumber(getBot(i).index))
        end 
    end
    sleep(5000)
    captain = bot_indexs[math.ceil(#bot_indexs / 2)]
    if getBot().index == captain then 
        print("captain: "..getBot().name)
        for _, i in pairs(bot_indexs) do 
            print(getBot(i).name)
        end
    else 
        getBot().custom_status = string.format("Following captain(%s)", getBot(captain).name)
        getBot():stopScript()
    end
end


function getUserData(bool)
    bool = bool or false
    local data = getHttp(access_url)
    local found = false
    if bool then 
        api = data.api
        return true
    end
    for _, users in pairs(data.access_list) do
        if users.name == myUsername then
            found = true
            local now_utc = os.time(os.date("!*t"))
            if users.expired == "never" then 
                enable = true
                api = tostring(data.api)
                reason = "License approved, welcome "..myUsername
                if not bool then
                    webhookAny("Username valid, Thanks for buying NEXORA Script!<:pepeheart:1368523385755144223>")
                    print(reason)
                end
                return true 
            else
                local year, month, day = users.expired:match("(%d+)%-(%d+)%-(%d+)")
                local epoch_utc = os.time({
                    year = tonumber(year),
                    month = tonumber(month),
                    day = tonumber(day),
                    hour = 0,
                    min = 0,
                    sec = 0
                }) 
                if epoch_utc < now_utc then 
                    enable = false
                    reason = "Expired script license"
                    print(reason)
                    webhookAny("It seem your license has been expired, script expired from: "..users.expired..", with user: "..myUsername)
                    return false
                else 
                    enable = true
                    api = tostring(data.api)
                    reason = "License approved, welcome "..myUsername
                    if not bool then 
                        webhookAny("Username valid, Thanks for buying NEXORA Script!<:pepeheart:1368523385755144223>")
                        print(reason)
                    end 
                    return true 
                end
            end 
        end
    end
    if not found then 
        enable = false
        reason = "Cannot find your username"
        print(reason)
        webhookAny(reason)
        return false
    end
end 
function cekModInput()
    local pair_mods = {
        MISHTHIOS = "JACKBOWE",
        JACKBOWE = "MISHTHIOS",
        KAILYX = "SOLABOWE",
        SOLABOWE = "KAILYX",
        PINUSKI = "CAITRIONA",
        CAITRIONA = "PINUSKI",
        MONIUET = "OILLA",
        OILLA = "MONIUET",
        WINDYPLAY = "IPLAYFULS",
        IPLAYFULS = "WINDYPLAY",
        ZOHROS = "STYX",
        STYX = "ZOHROS",
    }

    for _, mod in pairs(mods_list) do
        local mod_upper = mod:upper()
        local pasangannya = pair_mods[mod_upper]
        if pasangannya and not isIn(mods_list, pasangannya) then
            table.insert(mods_list, pasangannya)
        end
    end
end

function getModList()
    if getBot().index == captain then 
        local data = getHttp(api)
        if data then 
            player_count = data.playerData.online_user
            banrateApi = data.playerData.ban_rate
            image_url = data.image_url
            local tempmod = {}
            for _, datas in pairs(data.modData.mods) do 
                table.insert(tempmod, datas.name)
            end 
            mods_list = tempmod
        end
    end 
end 

function disconnectBot()
    getBot().auto_reconnect = false
    if getBot().index == captain then 
        for _, ib in ipairs(bot_indexs) do 
            getBot(ib).auto_reconnect = false 
            getBot(ib):disconnect()
            sleep(delay_connect_disconnect)
        end
    end 
end
    
function reconnect() 
    if reconnect_after_rest then 
        if getBot().index == captain then 
            webhookRecon(getBot().name, lastrestid)
            for _, ib in ipairs(bot_indexs) do 
                getBot(ib).auto_reconnect = true
                sleep(delay_connect_disconnect)
            end
        end
    end 
end

function restManyMods()
    if auto_rest_many_mods then 
        if getBot().index == captain then 
            while #mods_list >= minimum_many_mods do
                webhookRest(getBot().name, 1)
                disconnectBot()
                sleep(delay_many_mods * 60 * 1000)
                getModList()
            end
        end 
    end 
    return true
end 

function restSpecificMod()
    if auto_rest_specific_mod then 
        if getBot().index == captain then 
            local status, value = haveSame(specific_mod_list, mods_list)
            while status do 
                mod_detected = value
                webhookRest(getBot().name, 2)
                disconnectBot()
                sleep(delay_specific_mod * 60 * 1000)
                getModList()
                status, value = haveSame(specific_mod_list, mods_list)
            end 
        end
    end 
    return true
end 

function restPlayer() 
    if auto_rest_player then 
        if getBot().index == captain then
            if last_player == -1 then 
                last_player = player_count 
            end
            local diff = player_count - last_player
            while diff <= minimum_diffrence do 
                webhookRest(getBot().name, 6)
                last_diff = diff
                last_player = player_count
                disconnectBot()
                sleep(delay_player * 60 * 1000)
                getModList()
                diff = player_count - last_player
            end
            while player_count > maximum_player or player_count < minimum_player do 
                webhookRest(getBot().name, 5)
                last_player = player_count
                disconnectBot()
                sleep(delay_player * 60 * 1000)
                getModList()
            end
        end
    end 
    return true
end 

function restBanrate()
    if auto_rest_banrate then 
        if getBot().index == captain then
            local banrate = getBanRate()
            while banrate >= minimum_banrate do
                webhookRest(getBot().name, 4)
                last_banrate = banrate
                disconnectBot()
                sleep(delay_specific_mod * 60 * 1000)
                banrate = getBanRate()
            end
        end
    end
    return true
end

-- Helper function: parse UTC offset
local function parse_utc_offset(zone)
    local sign = zone:sub(4,4)
    local hours = tonumber(zone:sub(5,6))
    return (sign == "-" and -hours) or hours
end

local function time_to_minutes(time_str)
    if not time_str then
        return nil
    end
    local hour, min = time_str:match("(%d+):(%d+)")
    if not hour or not min then
        error("Format waktu salah: " .. tostring(time_str))
    end
    return tonumber(hour) * 60 + tonumber(min)
end

local function minutes_to_time(minutes)
    minutes = (minutes + 1440) % 1440
    local hour = math.floor(minutes / 60)
    local min = minutes % 60
    return string.format("%02d:%02d", hour, min)
end

-- Konversi jadwal ke UTC
local function convert_schedule_to_utc(schedule, zone)
    local offset = parse_utc_offset(zone)
    local utc_schedule = {}

    for _, period in ipairs(schedule) do
        local start_time, end_time = period:match("([^%-]+)%s*%-%s*([^%-]+)")
        local start_minutes = time_to_minutes(start_time)
        local end_minutes = time_to_minutes(end_time)

        local start_utc = minutes_to_time(start_minutes - offset * 60)
        local end_utc = minutes_to_time(end_minutes - offset * 60)

        table.insert(utc_schedule, {
            original = period,  -- Simpan referensi ke original jika mau
            start_utc = start_utc,
            end_utc = end_utc,
            end_schedule = end_time, -- Simpan versi lokal di sini
        })
    end

    return utc_schedule
end

local function is_rest_now(utc_schedule)
    local now = os.date("!*t") -- UTC time
    local current_minutes = now.hour * 60 + now.min

    for _, period in ipairs(utc_schedule) do
        local start_minutes = time_to_minutes(period.start_utc)
        local end_minutes = time_to_minutes(period.end_utc)
        end_schedule = period.end_schedule

        -- Di sini kamu masih bisa akses period.end_schedule (versi lokal)
        if start_minutes <= end_minutes then
            if current_minutes >= start_minutes and current_minutes <= end_minutes then
                return true, period.end_schedule
            end
        else
            if current_minutes >= start_minutes or current_minutes <= end_minutes then
                return true, period.end_schedule
            end
        end
    end
    return false, nil
end

function restSchedule()
    if auto_rest_schedule then
        local utc_schedule = convert_schedule_to_utc(schedule_list, schedule_zone)
        
        while true do
            local is_rest, end_schedule = is_rest_now(utc_schedule)
            if not is_rest then break end

            if getBot().index == captain then 
                webhookRest(getBot().name, 3)
                disconnectBot()
                sleep(delay_schedule * 1000 * 60)
            end
        end
    end
    return true
end

function restAll()
    if getBot().index == captain then 
        getModList()
        if restManyMods() and restSpecificMod() and restSchedule() and restBanrate() and restPlayer() then 
            reconnect()
        end
    end
end

function sare(varlist, netid)
    sleep(check_delay * 60 * 1000)
    unlistenEvents()
end 

addEvent(Event.varianlist, sare)

function startThisSoGoodScriptAnjayy()
    if getBot().index == captain then 
        getJson()
        getBot().custom_status = "Verifying your username"
        if not getUserData(false) then 
            enable = false
            getBot().custom_status = "Username invalid"
            getBot():stopScript()
        else 
            enable = true 
            getBot().custom_status = "CAPTAIN"
        end
    end
    
    if enable and getBot().index == captain then 
        while true do 
            restAll()
            listenEvents(1000)
        end
    end
end

function wow()
    print("hi ")
end

getCaptain()
startThisSoGoodScriptAnjayy()

wow()
------------------------------
