version = 2

auto_rest_many_mods = true
minimum_many_mods = 5

auto_rest_specific_mod = true
specific_mod_list = {"kailyx", "misthios", "windyplay"} -- uppercase is not nessesary

auto_rest_schedule = true
schedule_zone = "UTC+7"
schedule_list = {
    "10:30 - 11:00"
}

auto_rest_player = true 
minimum_player = 30000
maximum_player = 70000

auto_rest_banrate = true 
minimum_banrate = 2.0 

--====================--

use_webhook = true
webhook_link = "https://discord.com/api/webhooks/1366255322607517717/hl1MVXqFyjcw8KEYjkqVbBC4S-gjPrJlMlU46mG9ADbftSlT_-LVNLtFqnZEtubcx5se"

hide_bot_identity = false
reconnect_after_rest = true
edit_message_reconnect = true -- true if edit message rest to reconnect/false if send new message

any_check_delay = 2 -- for "ROTATION" mode only
execute_delay = 1000 -- milisecond
delay_many_mods = 1 --minutes 
delay_specific_mod = 1 -- minutes
delay_schedule = 1 -- minutes
delay_banrate = 1
delay_player = 1



----- ===== CODE AREA ===== -----
script_mode = "ANY"
local json = require("dkjson")
api = ""
api_mods = ""
api_player = ""
api_use = ""
image_url = ""
access_url = "https://raw.githubusercontent.com/Evan0A/Nuron_access/refs/heads/main/Rest_Script?t="..os.time()
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
banrate = 0.0
last_banrate = 0.0 
last_player = 0
captainStatus = {"Online", "ManyMod", "SpecificMod", "Banrate", "Schedule", "Player"}

cekplant = false 
cekpnb = false
cekharvest = false
cekdropseed = false
cekdroppack = false

function getHttp(url)
    local client = HttpClient.new()
    client.url = url
    local result = client:request()
    if result.error ~= 0 then
        print("error result: " ..result:getError().." | link: "..url)
    else
        if result.status == 200 then
            local success, data = pcall(json.decode, result.body)
            if success then
                return data
            else
                print("Error get http: success: "..success.." data: "..data)
            end
        else
            if result.status == 521 then
                webhookAny("API down, just wait a moment, code: 521")
                getBot().custom_status = "error"
                getBot():stopScript()
            else
                webhookAny("Something wrong with API, ask owner for fix. code: "..result.status)
                getBot().custom_status = "error"
                getBot():stopScript()
            end
        end
    end
end

function lastCekStatus(name)
    if name == "ht" then 
        cekplant = false 
        cekpnb = false
        cekharvest = true
        cekdropseed = false 
        cekdroppack = false
    elseif name == "pt" then 
        cekplant = true
        cekpnb = false
        cekharvest = true
        cekdropseed = false 
        cekdroppack = false
    elseif name == "pnb" then 
        cekplant = false 
        cekpnb = true
        cekharvest = false
        cekdropseed = false 
        cekdroppack = false 
    elseif name == "dpack" then 
        cekplant = false 
        cekpnb = false
        cekharvest = false
        cekdropseed = false 
        cekdroppack = true 
    elseif name == "dseed" then 
        cekplant = false 
        cekpnb = false
        cekharvest = false
        cekdropseed = true
        cekdroppack = false
    end 
end 

local function get_cpu_usage()
    local status, result = 
    pcall(function() 
        local handle = io.popen("powershell -Command \"(Get-Counter '\\Processor(_Total)\\% Processor Time').CounterSamples.CookedValue\"")
        local result = handle:read("*a")
        print(result)
        handle:close()
    
        local usage = result:match("(%d+%.?%d*)")
        return math.floor(tonumber(usage))
    end)
    if status then 
        return result
    else 
        return "Failed to get CPU percentage"
    end 
end

function webhookRest(nameBot, from)
    if use_webhook and from ~= lastrestid then 
        wh = Webhook.new(webhook_link)
        local reason_emoji = {
            ["1"] = "🛡️",--many mod
            ["2"] = "🚨", -- specific mod 
            ["3"] = "⏰", --schedule
            ["4"] = "🚫", -- banrate 
            ["5"] = "😳" -- player
        }
        local fromS = {
            ["1"] = "MANY MODS DETECTED",
            ["2"] = "SPECIFIC MOD DETECTED",
            ["3"] = "SCHEDULE REST DETECTED",
            ["4"] = "BAN-RATE DETECTED",
            ["5"] = "PLAYER ONLINE DETECTED"
        }
        if hide_bot_identity then 
            nameBot = "HIDDEN"
        else 
            nameBot = nameBot.."(CAPTAIN)"
        end
        local emoji = reason_emoji[tostring(from)] or "❓"
        local utc_time = os.date("!%Y-%m-%d %H:%M UTC")

        -- Info tambahan
        local extra_info = ""
        if from == 1 then
            extra_info = string.format("👥 Mods Online: %d / %d", #mods_list, minimum_many_mods)
            lastrestid = 1
        elseif from == 2 then
            extra_info = string.format("Mod detected: **%s**", mod_detected)
            lastrestid = 2
        elseif from  == 3 then 
            extra_info = string.format("Rest until: %s (%s)", end_schedule, schedule_zone)
            lastrestid = 3
        elseif from  == 4 then 
            extra_info = string.format("Rest until Ban-rate lower, ban-rate: %f", banrate)
            lastrestid = 4
        elseif from  == 5 then 
            extra_info = ""
            if player_count >= maximum_player then 
                extra_info = string.format("Rest until player count get lower: %d / %d", player_count, maximum_player)
            else 
                extra_info = string.format("Rest until player count get higher: %d / %d", player_count, minimum_player)
            end
            lastrestid = 5
        end
        wh.embed1.use = true
        wh.embed1.title = string.format("[%s]REST DETECTED", emoji)
        wh.embed1.color = 16711680
        wh.embed1:addField("<:bot_gradient:1389670917755375746> | BOT NAME: ", nameBot, true)
        wh.embed1:addField("<a:offline:1365647922330603611> | REASON: ", fromS[tostring(from)], true)
        wh.embed1:addField(" <:animated_clock:1389671974552469524> | TIME (UTC): ", utc_time, true)
        wh.embed1:addField("<:star:1389672145839329360> | EXTRA INFO: ", (string.format("%s", extra_info)), true)
        wh.embed1.footer.text = "Made with love by NEXORA"
        wh.embed1.footer.icon_url = image_url
        if getBot().index == captain then 
            if whrestdone and lastrestid ~= from then 
                wh:edit(midrest)
                whrestdone = true
                lastrestid = from
                if edit_message_reconnect then 
                    midrest = wh.message_i
                end
            elseif not whrestdone then
                wh:send()
                whrestdone = true 
                lastrestid = from
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
            ["5"] = "🤠" -- player
        }
        local fromS = {
            ["1"] = "MANY MODS REST ENDED",
            ["2"] = "SPECIFIC MOD REST ENDED",
            ["3"] = "SCHEDULE REST ENDED",
            ["4"] = "BANRATE DROPPED",
            ["5"] = "PLAYER ACTIVE"
        }
        if hide_bot_identity then 
            nameBot = "HIDDEN"
        else
            nameBot = nameBot.."(CAPTAIN)"
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
        end

        wh.embed1.use = true
        wh.embed1.title = string.format("[%s]REST TIME DONE", emoji)
        wh.embed1.color = 3066993 -- warna hijau
        wh.embed1:addField("<:bot_gradient:1389670917755375746> | BOT NAME: ", nameBot, true)
        wh.embed1:addField("<a:Online1:1365647772468117636> | STATUS: ", fromS[tostring(from)], true)
        wh.embed1:addField("<:animated_clock:1389671974552469524> | TIME (UTC): ", utc_time, true)
        wh.embed1:addField("🔍 | EXTRA INFO: ", (string.format("%s", extra_info)), true)
        wh.embed1.footer.text = "Made with love by NEXORA"
        wh.embed1.footer.icon_url = image_url
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

function haveSame(arr1, arr2)
    for _, a1 in pairs(arr1) do 
        for _, a2 in pairs(arr2) do 
            if a1 == a2 then 
                return true, a1
            end 
        end 
    end 
    return false 
end

function isIn(arr, val)
    for _, key in pairs(arr) do 
        if key == val then 
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
    for i = 1, botCount do
        if isIn(captainStatus, tostring(getBot(i).custom_status)) and getBot(i):isRunningScript() then 
            captain = i
            getBot().custom_status = string.format("Following captain(%s)", getBot(i).name)
            return true
        end 
    end
    sleep(500)
    getBot().custom_status = "REST VERIFICATION 1"
    sleep(3000)
    local bot1 = {}
    for i = 1, botCount do 
        if getBot(i).custom_status == "REST VERIFICATION 1" then 
            cekDouble(bot_indexs, tonumber(getBot(i).index))
        end 
    end
    sleep(2000)
    captain = bot_indexs[math.ceil(#bot_indexs / 2)]
    if getBot().index == captain then 
        print("done, captain rest: "..captain)
    else 
        getBot().custom_status = string.format("Following captain(%s)", getBot(captain).name)
    end
end

function getUserData()
    local data = getHttp(access_url)
    local found = false
    for _, users in pairs(data.access_list) do
        if users.name == myUsername then
            found = true
            local now_utc = os.time(os.date("!*t"))
            if users.expired == "never" then 
                enable = true
                api = tostring(data.api)
                reason = "License approved, welcome "..myUsername
                webhookAny("Username valid, Thanks for buying NEXORA Script!<:pepeheart:1368523385755144223>")
                print(reason)
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
                    webhookAny("It seem your license has been expired, script expired from: "..users.expired)
                    return false
                else 
                    enable = true
                    api = tostring(data.api)
                    reason = "License approved, welcome "..myUsername
                    webhookAny("Username valid, Thanks for buying NEXORA Script!<:pepeheart:1368523385755144223>")
                    print(reason)
                    api = data.api 
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

function getModList()
    if getBot().index == captain then 
        local data = getHttp(api)
        if data then 
            player_count = data.playerData.online_user
            banrate = data.playerData.ban_rate
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
    if getBot().status == 1 then 
        getBot():disconnect()
    end 
end
    

function reconnect() 
    if reconnect_after_rest then 
        if getBot().index == captain then 
            webhookRecon(getBot().name, lastrestid)
            getBot().custom_status = "Online"
        end
        sleep(500 + math.random(500,4000))
        if getBot(captain).custom_status == "Online" then 
              
            getBot().auto_reconnect = true
            if script_mode == "ROTATION" then 
                rotation.enabled = true
            end 
        end
    end 
end

function restManyMods()
    if auto_rest_many_mods then 
        if getBot().index == captain then 
            while #mods_list >= minimum_many_mods do
                webhookRest(getBot().name, 1)
                getBot().custom_status = "ManyMod"
                disconnectBot()
                sleep(delay_many_mods * 60 * 1000)
                getModList()
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end
        else 
            while getBot(captain).custom_status == "ManyMod" and getBot(captan).status ~= 1 do 
                disconnectBot()
                sleep(delay_many_mods * 60 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
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
                getBot(captain).custom_status = "SpecificMod"
                webhookRest(getBot().name, 2)
                mod_detected = value
                disconnectBot()
                sleep(delay_banrate * 60 * 1000)
                getModList()
                status, value = haveSame(specific_mod_list, mods_list)
                if script_mode == "ROTATION" then 
                rotation.enabled = false
                end
            end 
        else 
            while getBot(captain).custom_status == "SpecificMod" do 
                disconnectBot()
                sleep(delay_banrate * 61 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end 
        end
    end 
    return true
end 

function restPlayer() 
    if auto_rest_player then 
        if getBot().index == captain then 
            while player_count > maximum_player or player_count < minimum_player do 
                webhookRest(getBot().name, 5)
                last_player = player_count
                getBot().custom_status = "Player" 
                disconnectBot()
                sleep(delay_player * 60 * 1000)
                getModList()
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end 
            end
        else 
            while getBot(captain).custom_status == "Player" do 
                disconnectBot()
                sleep(delay_player* 60 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
            end 
        end 
    end 
    return true
end 

function restBanrate()
    if auto_rest_banrate then 
        if getBot().index == captain then 
            while banrate >= minimum_banrate do
                webhookRest(getBot().name, 4)
                last_banrate = banrate
                getBot().custom_status = "Banrate" 
                disconnectBot()
                sleep(delay_specific_mod * 60 * 1000)
                getModList()
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end 
            end
        else 
            while getBot(captain).custom_status == "Banrate" do 
                disconnectBot()
                sleep(delay_specific_mod * 62 * 1000)
                if script_mode == "ROTATION" then 
                    rotation.enabled = false
                end
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

-- Helper function: convert minutes to time string
local function minutes_to_time(minutes)
    minutes = (minutes + 1440) % 1440 -- biar tetap di 0-1439 menit
    local hour = math.floor(minutes / 60)
    local min = minutes % 60
    return string.format("%02d:%02d", hour, min)
end

-- Convert schedule ke UTC
local function convert_schedule_to_utc(schedule, zone)
    local offset = parse_utc_offset(zone)
    local utc_schedule = {}

    for _, period in ipairs(schedule) do
        local start_time, end_time = period:match("([^%-]+)%s*%-%s*([^%-]+)")
        local start_minutes = time_to_minutes(start_time)
        local end_minutes = time_to_minutes(end_time)
        end_schedule = end_time

        local start_utc = minutes_to_time(start_minutes - offset * 60)
        local end_utc = minutes_to_time(end_minutes - offset * 60)

        table.insert(utc_schedule, start_utc .. " - " .. end_utc)
    end

    return utc_schedule
end

-- Check apakah sekarang waktu rest
local function is_rest_now(utc_schedule)
    local now = os.date("!*t") -- waktu UTC
    local current_minutes = now.hour * 60 + now.min

    for _, period in ipairs(utc_schedule) do
        local start_time, end_time = period:match("([^%-]+)%s*%-%s*([^%-]+)")
        local start_minutes = time_to_minutes(start_time)
        local end_minutes = time_to_minutes(end_time)

        if start_minutes <= end_minutes then
            -- normal case
            if start_minutes <= current_minutes and current_minutes <= end_minutes then
                return true
            end
        else
            -- nyebrang hari
            if current_minutes >= start_minutes or current_minutes <= end_minutes then
                return true
            end
        end
    end
    return false
end

function restSchedule()
    if auto_rest_schedule then
        local utc_schedule = convert_schedule_to_utc(schedule_list, schedule_zone)
        
        -- Cek apakah sekarang waktu rest
        while is_rest_now(utc_schedule) do
            if getBot().index == captain then 
                webhookRest(getBot().name, 3)
                getBot(captain).custom_status = "Schedule"
                webhookRest(getBot().name, 3)
                disconnectBot()
                sleep(delay_schedule * 1000 * 60)
            else 
                while getBot(captain).custom_status == "Schedule" do
                    disconnectBot()
                    sleep(delay_schedule * 1000 * 62)
                    if script_mode == "ROTATION" then 
                        rotation.enabled = false 
                    end 
                end 
            end 
        end
    end
    return true
end

function restAll()
    if getBot().index == captain then 
        getModList()
        restManyMods()
        restSpecificMod()
        restPlayer()
        restBanrate()
        restSchedule()
    else
        sleep(1000)
        if first then 
            sleep(3000)
            first = false
        end 
        restManyMods()
        restSpecificMod()
        restPlayer()
        restBanrate()
        restSchedule()
    end
    if restManyMods() and restSpecificMod() and restSchedule() and restBanrate() and restPlayer() then 
        reconnect()
    end
end

print("version: "..version)
getCaptain() 

if getBot().index == captain then 
    getBot().custom_status = "wait"
    sleep(100)
    print(get_cpu_usage())
    if not getUserData() then 
        getBot().custom_status = "invalid"
        enable = false
        getBot():stopScript()
    end
else 
    sleep(1000)
    while getBot(captain).custom_status == "wait" do 
        sleep(100)
    end 
    if getBot(captain).custom_status == "invalid" then 
        enable = false
        getBot():stopScript()
    end 
end 

if enable then 
    sleep(execute_delay * getBot().index)
    if script_mode:upper() == "ANY" or script_mode == "" then 
        lastCheckedMinute = -1
        if getBot().index == captain then 
            restAll()
        end
        while true do 
            local now = os.date("*t")
            local nowMin = now.hour * 60 + now.min  -- menit total sejak tengah malam
            if nowMin % any_check_delay == 0 and nowMin ~= lastCheckedMinute then
                restAll()
                print(get_cpu_usage())
            end
        end
    elseif script_mode:upper() == "ROTATION" then 
        if getBot().index == captain then 
            restAll()
        end
        while true do 
            if (rotation.status == 1 or rotation.status == 7) and not cekharvest then 
                restAll()
                lastCekStatus("ht")
            elseif rotation.status == 2 and not cekpnb then 
                restAll()
                lastCekStatus("pnb")
            elseif rotation.status == 3 and not cekplant then 
                restAll()
                lastCekStatus("pt")
            elseif rotation.status == 4 and not cekdropseed then 
                restAll()
                lastCekStatus("dseed")
            elseif rotation.status == 5 and not cekdroppack then 
                restAll()
                lastCekStatus("dpack")
                print("loop rotation, cpu: "..get_cpu_usage())
            end
        end
    end 
end