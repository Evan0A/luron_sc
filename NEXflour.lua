print("v2")

--== WORLD ==--
world_farm = {"VAIIIII1140"}
world_farm_row = 5 -- max row in each world
door_farm = "PTVVL1140"

world_storage = {"SOILWARE", "STHRTPA0"} 
door_storage = "PTVVL1140"
max_drop = 20


--== PACK ==-- 
take_gems = false
buy_pack = false
pack_name = "world_lock"
pack_price = 2000
pack_item = {242}
world_packs = {"SOILWARE"}
door_pack = ""
max_drop_pack = 10000 -- max drop items each world


--== MALADY ==-- 
auto_gruken = false --grumbleteeth/chicken feet
spam_messages = {
    "How much?", 
    "Gyattt",
    "Yes bro", 
    "what the hell",
}
blacklist_malady = {} -- 1=torn punching, 2=cut gem


--== WEBHOOK ==--
global_webhook = "https://discord.com/api/webhooks/1114483839444729936/yQzzCt22cCIF3Wz9XdhGMSmD78yCx3UxyzZNGThl01kbmM34Z2ern42Sy3slDjPI3xto"
event_webhook = "https://discord.com/api/webhooks/1114483559114215476/HO4ARS2PrtmvRPO1_T2pvKAdJocqcx9u_K_4ZNMl4nR-H6a5Tl_yIdfk8TGcV6TOR0C3"
storage_webhook = "https:"
bot_webhook = 1 --bot index to send webhook


--== FLOUR ==--
auto_flour = true -- false if didnt use grinder 
world_grinders = {"BUYGRINDER"}
door_grinder = ""
save_flour = 8


--== SETTING ==--
seedID = 881 --881 wheat
row_id = 4584 
pnb_tutorial = false
auto_take_pickaxe = true 
world_pickaxe = "PTVPIC|PTVPIC"
auto_reconnect = true

auto_rotation = false -- auto start rotation if reach X level
level_rotation = 12

auto_offline = false -- auto offline when reach X level 
level_offline = 12
remove_bot = true

delay_hit = 180 
delay_place = 160 
delay_warp = 10000
delay_execute = 1000 
delay_plant = 180 
delay_harvest = 100
dynamic_delay = true -- delay will adapting to bot's ping and random number

goodies = {5030, 12498} -- Example Wind Essence
trash = {5038, 5034, 5044, 5032, 5040, 5042}
warp_random_world = true 
random_world_count = 14
random_world_delay = 8000


--== ADVANCE SETTINGS ==-- 
-- DO NOT CHANGE ANYTHING 
-- IF YOU DONT KNOW WHAT YOU'RE DOING!
delayRandomMin = -15 
delayRandomMax = 10
botCount = #getBots()
webhookMaxShowBot = 5

customStatus = { 
    harvest = "Harvesting",
    plant = "Planting", 
    pnb = "Breaking blocks",
    grind = "Grinding wheat",
    clearing = "Clearing floating items",
    save = "Saving items", 
    ban = "R.I.P",
    removeMalady = "Removing malady", 
    getMalady = "Getting malady",
    reconnect = "Reconnecting",
    data = "Getting farm data"
}
webhookEmoji = {
    bot = ":robot:", 
    storage = ":package:", 
    fossil = "<:fossil:1414081520053911622>",
    flour = "<:flour:1169544889445388319>",
    seed = "<:seeds:1169922333369172048>", 
    block = "<:dirt:1172389549666729994>", 
    vending = "<:vending:1187331638296846346>",
    online = "<a:Online1:1365647772468117636>", 
    offline = ":black_circle:", 
    banned = ":Banned:", 
    takeItem = "Taking item"
}
status_map = {
    [0] = "Offline",
    [1] = "Online",
    [2] = "Wrong Password",
    [3] = "Account Banned",
    [4] = "Account Suspended",
    [5] = "Location Banned",
    [6] = "Version Update",
    [7] = "Advanced Account Protection",
    [8] = "Server Overload",
    [9] = "Too Many Logins",
    [10] = "Maintenance",
    [11] = "Server Busy",
    [12] = "Guest Limit",
    [13] = "HTTP Blocked",
    [14] = "Bad Name Length",
    [15] = "Invalid Account",
    [16] = "Ubi Disabled",
    [17] = "Account Restricted",
    [18] = "Network Restricted",
    [19] = "Error Connecting",
    [20] = "Logon Fail",
    [21] = "Captcha Requested",
    [22] = "Mod Entered",
    [23] = "Player Entered",
    [24] = "High Load",
    [25] = "High Ping",
    [26] = "Changing Subserver",
    [27] = "Stopped",
    [28] = "Getting Server Data",
    [29] = "Bypassing Server Data",
    [30] = "Could Not Warp",
    [31] = "Bad Inventory",
    [32] = "Bad Gateway",
    [33] = "Server Issue",
    [34] = "Retrieving Token",
    [35] = "Two Factor",
    [36] = "Google Logon Fail",
    [37] = "IDK", 
    [38] = "Steam Logon Fail",
    [39] = "Linking Steam",
    [40] = "Steam Not Linked",
    [41] = "Solving Captcha",
    [42] = "Failed Captcha",
    [43] = "Banwave Detected",
    [44] = "SMS Error"
}
getBot().auto_reconnect = auto_reconnect




--== CODE AREA ==--

sleep(delay_execute * getBot().index-1)
bot = getBot()
bot.move_range = 3
bot:setInterval(Action.move, 0.235)
pabrikWorld = ""
position = 0
whiteListOwner = "yourGrowID"


for i, botz in pairs(getBots()) do
    if botz.name:upper() == bot.name:upper() then
        botIndex = i
    end
end
save_vend = false
collect_range = 3
land = 0
math.randomseed(os.time())
worldPackIndex = 1
worldStorageIndex = 1
tileBreak = {}
breakTile = 1
Poss = {}
position = 0
startTime = os.time()
itemInVend = 0
wrenchP = false
noTutorWorld = false
emptyItem = false
json = nil 
Sversion = 1
namaBot = bot.name
worldTutor = ""
totalSeed = 0
tutorNuked = false
savedItems = {}
world_grinder = string.upper(world_grinders[math.random(1,#world_grinders)])
totalFlour = 0
totalPack = 0
blockID = seedID - 1 -- Block ID, not Seed ID
flourID = 4562
pabrikWorld = ""
multiRow = 1 -- 1-27
multiRowDistance = 2 -- The tile distance between each row | Default 2
readyGrind = false
mid = 0

storage = {}

if not auto_flour then 
	flourID = seedID
	save_flour = 50
end

function delay(second)
    if type(second) == "number" and dynamic_delay then 
        local ping = tostring(getBot():getPing()) 
        local off = 0 
        local rand = math.random(-15, 10)
        if #ping >= 3 then 
            off = ping:sub(1,2)
        elseif #ping == 2 then 
            off = ping:sub(1,1)
        else 
            off = "0"
        end 
        off = tonumber(off) or 0
        sleep(second + rand + off)
    elseif not dynamic_delay then 
        sleep(second)
    else 
        sleep(delay_plant)
    end 
end

function getUptime()
    local currentTime = os.time()
    
    local elapsedTime = currentTime - startTime
    
    local days = math.floor(elapsedTime / 86400)
    local hours = math.floor((elapsedTime % 86400) / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    
    return string.format("%dd %02dh %02dm", days, hours, minutes)
end

function isIn(tab, var)
    for _, vol in ipairs(tab) do 
        if tostring(vol) == var then 
            return true 
        end 
    end 
    return false 
end 

function callWebhook()
    if getBot().index == bot_webhook then 
        local all = storageTotal()
        local online = webhookEmoji.online 
        local offline = webhookEmoji.offline
        local banned = webhookEmoji.banned
        local on, off, ban = 0,0,0
        local allping = 0
        local botdata = ""
        local max_show = webhookMaxShowBot
        local max_limit = false
        local savetem = "" 
        local scinfo = "**[START]**: <t:"..startTime..":R>\n**[UPDATED]**: <t:"..os.time()..":R>\n"
        for _, bot in pairs(getBots()) do 
            if bot.index <= max_show then 
                botdata = botdata.."["..bot.index.."]".." ||"..bot.name.."||("..bot.level..") | "..getStatus(bot.status)..status_map[bot.status].."["..bot:getPing().."] | ||"..bot:getWorld().name.."||\n"
            end 
            if bot.index > max_show and not max_limit then 
                botdata = botdata.."...\n"
                max_limit = true 
            end
            if bot.status == 1 then 
                on = on + 1 
            elseif bot.status == 3 or bot.status == 4 then
                ban = ban + 1 
            else 
                off = off + 1
            end 
            allping = allping + bot:getPing()
        end 
        for _, svt in pairs(all) do 
            savetem = savetem.."- **`"..getInfo(svt.id).name.." (x"..svt.count..")`**\n"
        end
        local desc = online..on.." | "..offline..off.." | "..banned..ban.." | <:excellent_signal:1156954228850442240>avg: "..allping//botCount
        local wh = Webhook.new(global_webhook)
        wh.username = "Nexora"
        wh.avatar_url = "https://cdn.discordapp.com/attachments/1365639857241718867/1401710544871751724/file_000000000c0461f8ac3c5a2bc4f38329.png?ex=68d1ddac&is=68d08c2c&hm=11f80575ebfdfec19a34285ea44ff27b17277ade335db1ff5dddd1aef7dd536b&"
        wh.embed1.use = true
        wh.embed1.author.name = "Nexora √Factory Script"
        wh.embed1.author.url = "https://discord.gg/pNSwC5kQHw"
        wh.embed1.color = 65280
        wh.embed1.description = desc
        wh.embed1:addField("Bot status("..webhookMaxShowBot.."/"..botCount..")", botdata, true)
        wh.embed1:addField("Floating items", savetem, true)
        wh.embed1:addField("Script info", scinfo, true )
        wh.embed1.footer.text = os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60)
        if mid ~= 0 then
            wh:edit(mid)
        else
            wh:send()
    		mid = wh.message_id
    	end
    end
end



function callAlert(msg)
    local wh = Webhook.new(event_webhook)
    wh.username = "Nexora"
    wh.avatar_url = "https://cdn.discordapp.com/attachments/1365639857241718867/1401710544871751724/file_000000000c0461f8ac3c5a2bc4f38329.png?ex=68d1ddac&is=68d08c2c&hm=11f80575ebfdfec19a34285ea44ff27b17277ade335db1ff5dddd1aef7dd536b&"
    wh.content = msg.."\n||@everyone||"
	wh:send()
end

function callEvent(msg)
    local wh = Webhook.new(event_webhook)
    wh.username = "Nexora"
    wh.avatar_url = "https://cdn.discordapp.com/attachments/1365639857241718867/1401710544871751724/file_000000000c0461f8ac3c5a2bc4f38329.png?ex=68d1ddac&is=68d08c2c&hm=11f80575ebfdfec19a34285ea44ff27b17277ade335db1ff5dddd1aef7dd536b&"
	wh.content = msg.."\n||@everyone||"
    wh:send()
end

function getStatus(stat)
    local online = webhookEmoji.online
    local offline = webhookEmoji.offline
    if stat == 1 then
        return status_map[stat].." "..online
    else
        return status_map[stat].." "..offline
    end
end



function storageAdd(world, id, count)
    if not storage[world] then 
        storage[world] = {} 
    end 
    local sworld = storage[world]
    for i, name in pairs(sworld) do 
        if name.id == id then 
            name.count = name.count + count 
            return 
        end 
    end 
    table.insert(sworld, {id = id, count = count})
end

function storageFind(id)
    for nama, items in pairs(storage) do 
        for _, item in pairs(items) do 
            if item.id == id then 
                return nama, item.count 
            end 
        end 
    end 
    return false, nil
end

function storageTotalList(idList)
    local total = 0
    local idLookup = {}

    -- buat lookup table biar lebih cepat
    for _, id in ipairs(idList) do
        idLookup[id] = true
    end

    -- loop semua nama dan item
    for _, items in pairs(savedItems) do
        for _, item in ipairs(items) do
            if idLookup[item.id] then
                total = total + item.count
            end
        end
    end

    return total
end

function storageTotal() 
    local result = {}
    for _, saved in pairs(savedItems) do 
        for _, item in pairs(saved) do 
            local found = false 
            for _, res in pairs(result) do 
                if res.id == item.id then 
                    res.count = res.count + items.count
                    found = true 
                end 
            end 
            if not found then 
                table.insert(result, {id = item.id, count = item.count})
            end 
        end 
    end 
    return result 
end

function round(n)
    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)
end

function itemCount(id)
    return getBot():getInventory():getItemCount(id)
end

function findItem(id)
    return getBot():getInventory():findItem(id)
end

for i = math.floor(breakTile/2),1,-1 do
    i = i * -1
    table.insert(tileBreak,i)
end

for i = 0, math.ceil(breakTile/2) - 1 do
    table.insert(tileBreak,i)
end

function gscanFloat(id)
    return bot:getWorld().growscan:getObjects()[id] or 0
end

function gscanBlock(id)
    return bot:getWorld().growscan:getTiles()[id] or 0
end

function isPlantable(x,y)
    local tempTile = getTile(x,y + 1)
    if not tempTile.fg then return false end
    local collision = getInfo(tempTile.fg).collision_type
    return tempTile and ( collision == 1 or collision == 2)
end

function checkNuked(variant, netid)
    if variant:get(0):getString() == "OnConsoleMessage" then
        if variant:get(1):getString():find("That world is inaccessible") then
            worldNuked = true
        end
    end
end

function warps(worldName, doorID)
	doorID = doorID or ""
    worldNuked = false
    warpAttempt = 0
    addEvent(Event.variantlist, checkNuked)
    while not bot:isInWorld(worldName:upper()) and not worldNuked do
        print("Warping to "..worldName)
        if bot.status == BotStatus.online and bot:getPing() == 0 then
            bot:disconnect()
            sleep(2000)
        end

        while bot.status ~= BotStatus.online do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                sleep(8000)
            end
        end

        if doorID ~= "" then
            bot:warp(worldName, doorID)
        else
            bot:warp(worldName)
        end

        listenEvents(6)

        if warpAttempt == 5 then
            callAlert("Hard Warping to "..worldName.." "..bot.name:upper().." Resting.")
            print(worldName, " Hard Warp")
            sleep(3 * 60000)
            bot:disconnect()
            sleep(1000)
            while bot.status ~= BotStatus.online do
                sleep(1000)
            end
            warpAttempt = 0
        else
            warpAttempt = warpAttempt + 1
        end
    end

    if worldNuked then
        callAlert(worldName.." is Nuked!")
        print(worldName, "Nuked")
    end
    
    if doorID ~= "" and getTile(bot.x, bot.y).fg == 6 then
        while bot.status ~= BotStatus.online or bot:getPing() == 0 do
            sleep(1000)
            while bot.status == BotStatus.account_banned do
                callAlert(bot.name:upper() .. " got Banned!")
                bot.auto_reconnect = false
                bot:stopScript()
            end
        end
        for i = 1,3 do
            if getTile(bot.x,bot.y).fg == 6 then
                bot:warp(worldName, doorID)
                sleep(2000)
            end
        end
        if getTile(bot.x,bot.y).fg == 6 then
            print("Cant go to Door ID at ".. worldName)
            callAlert("Cant go to Door ID at ".. worldName)
            sleep(100)
            worldNuked = true
        end
    end
    sleep(100)
    removeEvent(Event.variantlist)
end

function reconnect(worldName, doorID, posX, posY)
    while getBot().status ~= 1 and not auto_reconnect do 
        sleep(10000)
    end
    if pnb_tutorial and bot.name:upper() ~= namaBot:upper() then
        
        getBot().custom_status = customStatus.reconnect
        namaBot = bot.name
        warps(worldTutor,"")
        checkTutorial()
        for i = 1,3 do
            if worldTutor == "" then
                checkTutorial()
                sleep(500)
            end
        end

        if worldTutor ~= "" then
            if itemCount(seedID) == 0 then
                takeItem(seedID, 50)
            end
            warps(worldTutor,"")
            if worldNuked then
                print(worldName.." is Nuked!, Bot Stopping Script")
                callAlert(worldName.." is Nuked!, Bot Stopping Script")
                bot:stopScript()
            end
        else
            print(bot.name:upper().." Doesn't Have Tutorial World!")
            callAlert(bot.name:upper().." Doesn't Have Tutorial World!, Will PNB in Pabrik")
            bot:stopScript()
        end

        if posX and posY and not bot:isInTile(posX, posY) then
            sleep(300)
            bot:findPath(posX, posY)
            sleep(200)
        end
    end
    

    if bot.status ~= BotStatus.online then
        local bstatus = getBot().custom_status
        print(bot.name:upper().." | Reconnecting")
        callWebhook()
        getBot().custom_status = customStatus.reconnect

        while bot.status ~= BotStatus.online do
            sleep(1000)
            if bot.status == BotStatus.account_banned then
                getBot().custom_status = customStatus.ban
                print(bot.name:upper() .. " got Banned")
                callAlert(bot.name:upper().." got Banned")
                bot.auto_reconnect = false
                bot:stopScript()
            end
        end
        warpingBackAttempt = 0
        while not bot:isInWorld(worldName:upper()) do
            
            print(bot.name:upper().." | Warping Back to "..worldName)
            bot:warp(worldName)
            delay(delay_warp)
            
            if warpingBackAttempt == 5 then

                print(bot.name:upper().." | Failed to Join Back to "..worldName.." Hard Warp Called!, Bot Resting.")

                warpingBackAttempt = 0
                sleep(3 * 60000)

                if bot:getWorld().name ~= worldName:upper() then
                    bot.auto_reconnect = false
                    bot:disconnect()
                    sleep(math.random(5000, 30000))
                    bot.auto_reconnect = true
                    sleep(1000)
                    while bot.status ~= BotStatus.online do
                        sleep(1000)
                    end
                end
            else
                warpingBackAttempt = warpingBackAttempt + 1
            end
        end

        if doorID ~= "" and getTile(bot.x, bot.y).fg == 6 then
            sleep(3000)
            while getTile(bot.x, bot.y).fg == 6 and bot.status == BotStatus.online do
                print(bot.name:upper().." | Warping to Door ID")
                bot:warp(worldName, doorID)
                sleep(delay_warp)
            end
        end

        if posX and posY and not bot:isInTile(posX, posY) then
            sleep(300)
            bot:findPath(posX, posY)
            sleep(200)
        end
        getBot().custom_status = bstatus
    end
end

function harvestPlant()
    warps(pabrikWorld, door_farm)
    
    bot.ignore_gems = not take_gems
    bot.auto_collect = true
    bot.object_collect_delay = 100
    bot.collect_range = collect_range
    
    if bot:isInWorld(pabrikWorld:upper()) then
        callWebhook()
        for _, ye in pairs(pnbY) do
            if itemCount(blockID) < 196 then
                getBot().custom_status = customStatus.harvest
                for _, tile in pairs(getTiles()) do
                    reconnect(pabrikWorld, door_farm)
                    while tile.fg == seedID and tile:canHarvest() and hasAccess(tile.x, tile.y) > 0 and #bot:getPath(tile.x, tile.y) > 0 and tile.y == ye and itemCount(blockID) < 200 do
                        bot:findPath(tile.x, tile.y)
                        if bot:isInTile(tile.x, tile.y) then
                            bot:hit(bot.x, bot.y)
                            delay(delay_harvest)
                            malady()
                            reconnect(pabrikWorld, door_farm, tile.x, tile.y)
							getBot().custom_status = "Farming"
                        end
                    end
                    if itemCount(blockID) == 200 then
                        break
                    end
                end
            end

            sleep(300)
            getBot().custom_status = customStatus.plant
            if itemCount(seedID) > 0 and getTile(bot.x, bot.y).fg == 0 then
                bot:place(bot.x, bot.y, seedID)
                delay(delay_plant)
                reconnect(pabrikWorld, door_farm)
            end

            for ex = 99, 0, -1 do
                reconnect(pabrikWorld, door_farm)
                if ex <= bot.x and getTile(ex, bot.y).fg == 0 and isPlantable(ex, bot.y) and itemCount(seedID) > 0 and hasAccess(ex, bot.y) > 0 and #bot:getPath(ex, bot.y) > 0 then
                    bot:findPath(ex, bot.y)
                    if itemCount(seedID) > 0 then
                        bot:place(bot.x, bot.y, seedID)
                        delay(delay_plant)
                        reconnect(pabrikWorld, door_farm)
                    end
                end
            end
            
            sleep(300)

            if itemCount(seedID) > 0 then
                for _, tile in pairs(getTiles()) do
                    reconnect(pabrikWorld, door_farm)
                    if tile.fg == 0 and isPlantable(tile.x, tile.y) and itemCount(seedID) > 0 and hasAccess(tile.x, tile.y) > 0 and #bot:getPath(tile.x, tile.y) > 0 and tile.y == ye then
                        bot:findPath(tile.x, tile.y)
                        if bot:isInTile(tile.x, tile.y) then
                            bot:place(bot.x, bot.y, seedID)
                            delay(delay_plant)
                            reconnect(pabrikWorld, door_farm, tile.x, tile.y)
                        end
                    end
                end
            end

        end
    end
end

function pnb()
    getBot().custom_status = customStatus.pnb
    warps(pabrikWorld, door_farm)
    callWebhook()
    if bot:isInWorld(pabrikWorld:upper()) then
        bot:findPath(pnbX, pnbY[1])
        sleep(100)

        bot.auto_collect = true
        bot.object_collect_delay = 100
        bot.ignore_gems = false
        bot.collect_range = collect_range

        if bot:isInTile(pnbX, pnbY[1]) then
            while itemCount(blockID) > 0 and bot:isInWorld(pabrikWorld:upper()) and getTile(bot.x, bot.y).fg ~= 6 do
                malady()
                reconnect(pabrikWorld, door_farm, pnbX, pnbY[1])
                if bot:isInWorld(pabrikWorld:upper()) and not bot:isInTile(pnbX, pnbY[1]) then
                    bot:warp(pabrikWorld, door_farm)
                    sleep(2000)
                    bot:findPath(pnbX, pnbY[1])
                    sleep(100)
                end
                
                for _,i in pairs(tileBreak) do
                    if getTile(pnbX - 1,pnbY[1] + i).fg == 0 and getTile(pnbX - 1,pnbY[1] + i).bg == 0 then
                        bot:place(bot.x-1, bot.y+i, blockID)
                        delay(delay_place)
                        reconnect(pabrikWorld, door_farm, pnbX, pnbY[1])
                    end
                end
                
                for _,i in pairs(tileBreak) do
                    while getTile(pnbX - 1,pnbY[1] + i).fg ~= 0 or getTile(pnbX - 1,pnbY[1] + i).bg ~= 0 do
                        bot:hit(bot.x-1, bot.y+i)
                        delay(delay_hit)
                        reconnect(pabrikWorld, door_farm, pnbX, pnbY[1])
                    end
                end
    
            end
        end
    end
end

function vendCheck(v, netid)
    if v:get(0):getString() == "OnDialogRequest" then
        if v:get(1):getString():find("This machine is empty.") then
            vendStatus = 1
            unlistenEvents()
        elseif v:get(1):getString():find("addstock") then
            itemInVend = v:get(1):getString():match("The machine contains a total of (%d+)")
            vendStatus = 2
            unlistenEvents()
        else
            vendStatus = 3
            unlistenEvents()
        end
    end
end

function putVend(itemid)
    bot.auto_collect = false
    getBot().custom_status = customStatus.save
    warps(world_storage, door_storage)
    if bot:isInWorld(world_storage:upper()) then
        for _, tile in pairs(getTiles()) do
            reconnect(world_storage, door_storage)
            if tile.fg == 2978 or tile.fg == 9268 and hasAccess(tile.x, tile.y) > 0 then
                if getTile(tile.x, tile.y):getExtra().id == itemid or getTile(tile.x, tile.y):getExtra().id == 0 then
                    reconnect(world_storage, door_storage)
                    bot:findPath(tile.x, tile.y)
                    sleep(200)
                    if bot:isInTile(tile.x, tile.y) then
                        addEvent(Event.variantlist, vendCheck)
                        runThread(function()
                            getBot():wrench(getBot().x, getBot().y)
                        end)
                        listenEvents(5)
                        itemInVend = itemInVend + itemCount(itemid)
                        if vendStatus == 1 then
                            sleep(300)
                            bot:sendPacket(2,"action|dialog_return\ndialog_name|vending\ntilex|".. bot.x .."|\ntiley|".. bot.y .."|\nstockitem|"..itemid)
                            sleep(1000)
                            bot:sendPacket(2,"action|dialog_return\ndialog_name|vending\ntilex|".. bot.x .."|\ntiley|".. bot.y .."|\nsetprice|0\nchk_peritem|0\nchk_perlock|1")
                            sleep(1000)
                        elseif vendStatus == 2 then
                            sleep(300)
                            bot:sendPacket(2,"action|dialog_return\ndialog_name|vending\ntilex|".. bot.x .."|\ntiley|".. bot.y .."|\nbuttonClicked|addstock\n\nsetprice|0\nchk_peritem|0\nchk_perlock|1")
                            sleep(1000)
                        end
                    end
                    callWebhook()
                    if itemCount(itemid) == 0 then
                        break
                    end
                end
            end
        end
    end
end

function dropItem(itemID)
    bot.auto_collect = false
    getBot().custom_status = customStatus.save
    while true do 
        local world = world_storage[worldStorageIndex]
        warps(world, door_storage)
        scanStorage()
        if scanItem(itemID) < max_drop then 
            reconnect(world, door_storage)
            if bot:isInWorld(world) then
                while itemCount(itemID) > 0 do 
                    getBot():findOutput()
                    sleep(500)
                    bot:drop(itemID, itemCount(itemID))
                    sleep(1000)
                    reconnect(world, door_storage)
                end
                scanStorage()
                break 
            end
        else 
            worldStorageIndex = worldStorageIndex + 1 
            if worldStorageIndex > #world_storage then 
                bmax = max_drop 
                callAlert(string.format("All storage reached max drop, max drop pack will be doubled\n%d --> %d", bmax, max_drop_pack))
                max_drop = max_drop * 2 
                worldStorageIndex = 1
            end 
        end
    end 
end

function autoWear(itemID)
    bot.auto_collect = false
    bot.object_collect_delay = 100
    if getBot():getInventory():findItem(98) == 0 then
		getBot().auto_wear = true
        getBot().wear_storage = world_pickaxe  
        while getBot():getInventory():findItem(98) ~= 1 do 
            sleep(500)
        end 
    end
end

function takeItem(itemID, amount)
    getBot().custom_status = customStatus.takeItem
    emptyItem = false
    bot.auto_collect = false
    bot.object_collect_delay = 100
    local name, count = storageFind(itemID)
    local found = false
    if name then 
        warps(name, door_storage)
        if gscanFloat(itemID) >= amount then 
            found = true 
        end
        scanStorage()
    end 
    if not found then 
        for i = 1, #world_storage do
            warps(world_storage[i], door_storage) 
            reconnect(world_storage[i], door_storage)
            scanStorage() 
            if gscanFloat(itemID) >= amount then 
                found = true 
                name = world_storage[i]
                break 
            end 
        end 
        if not found then
            name = world_storage[1]
            warps(name, door_storage)
            callAlert(getBot().name.. " looking for item "..getInfo(itemID).name.."("..amount..") drop it at world: "..name)
            reconnect(name, door_storage)
        end
    end
    while not found do 
        reconnect(name, door_storage) 
        for _, obj in pairs(getObjects()) do 
            reconnect(name, door_storage)
            if obj.id == itemID then 
                found = true 
                break
            end 
        end 
        sleep(20000)
    end 
    if found then 
        for _, obj in pairs(getObjects()) do 
            if obj.id == itemID and itemCount(itemID) < amount then
                local objX = obj.x//32
                local objY = obj.y//32 
                getBot():findPath(objX, objY) 
                reconnect(name, door_storage, objX, objY)
                sleep(200)
                getBot():collectObject(obj.oid, 2)
                sleep(500)
                getit = true
                while amount ~= nil and itemCount(itemID) > amount do 
                    bot:findOutput() 
                    reconnect(name, door_storage)
                    bot:drop(itemID, itemCount(itemID) - amount)
                    sleep(1000)
                end 
                scanStorage()
            end 
        end 
        if not getit then 
            sleep(5000) 
            reconnect(name, door_storage)
        end 
        if getit then 
            scanStorage()
        end
    end
end

function checkWrench(varlist, netid)
    if varlist:get(0):getString() == "OnDialogRequest" and varlist:get(1):getString():find("my_worlds") then
        wrenchP = true
        unlistenEvents()
    end
end

function checkMyWorld(varlist, netid)
    if varlist:get(0):getString() == "OnDialogRequest" and varlist:get(1):getString():find("add_button") then
        teks = varlist:get(1):getString()
        worldTutor = string.match(teks, "add_button|([^|]+)|")
        print(bot.name:upper().." Tutor World: "..worldTutor)
        callEvent(bot.name:upper().." Tutorial World: "..worldTutor)
        unlistenEvents()
    end
end

function findHomeWorld(variant, netid)
    if variant:get(0):getString() == "OnRequestWorldSelectMenu" and variant:get(1):getString():find("Your Worlds") then
        local text = variant:get(1):getString()
        local lines = {}
        for line in text:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        for i, value in ipairs(lines) do
            if i == 3 then
                kalimat = lines[3]
                local nilai = kalimat:match("|([a-zA-Z0-9s]+)|"):gsub("|", ""):gsub("%s", "")
                worldTutor = nilai
                print("[R] "..bot.name:upper().." > Tutorial World: "..worldTutor)
            end
        end
    end
end

function checkTutorial()
    while bot:isInWorld() do
        bot:leaveWorld()
        sleep(3000)
    end

    worldTutor = ""
    noHomeWorld = false
    print("[R] "..bot.name:upper().." > Checking Tutorial/Home World")

    addEvent(Event.variantlist, findHomeWorld)
    for i = 1, 3 do
        if worldTutor == "" and bot:getWorld().name:upper() == "EXIT" then
            bot:sendPacket(3,"action|world_button\nname|_16")
            listenEvents(5)
        end
    end

    if worldTutor == "" then
        print("[CRITICAL] "..bot.name:upper().." > Doesn't Have Tutorial/Home World!")
        noHomeWorld = true
    end
    
    sleep(100)
    removeEvent(Event.variantlist)
end

function pnbTutorial()
    warps(worldTutor,"")
	getBot().custom_status = customStatus.pnb
    if not worldNuked then
        callWebhook()
        if bot:isInWorld(worldTutor:upper()) and hasAccess(bot.x-1, bot.y) > 0 then
            bot.auto_collect = true
            bot.object_collect_delay = 100
            bot.ignore_gems = false
            pnbTX, pnbTY = 50, 23

            if #bot:getPath(pnbTX, pnbTY) > 0 then
                bot:findPath(pnbTX, pnbTY)
                sleep(100)
            end

            if bot:isInTile(pnbTX, pnbTY) then
                while bot:isInTile(pnbTX, pnbTY) and itemCount(blockID) > breakTile and bot:isInWorld(worldTutor:upper()) and getTile(bot.x, bot.y).fg ~= 6 and getTile(bot.x, bot.y - 1).fg ~= 9640 and getTile(bot.x, bot.y - 1).fg ~= 242 do
                    malady()
                    reconnect(worldTutor, "", pnbTX, pnbTY)
                    if bot:isInWorld(worldTutor:upper()) and not bot:isInTile(pnbTX, pnbTY) then
                        bot:findPath(pnbTX, pnbTY)
                        sleep(200)
                    end
                    
                    for i,player in pairs(getPlayers()) do
                        if player.netid ~= getLocal().netid and player.name:upper() ~= whiteListOwner:upper() then
                            bot:say("/ban " .. player.name)
                            sleep(1000)
                        end
                    end
        
                    for _,i in pairs(tileBreak) do
                        if getTile(pnbTX + i,pnbTY - 1).fg == 0 and getTile(pnbTX + i,pnbTY - 1).bg == 0 then
                            bot:place(bot.x + i,bot.y - 1, blockID)
                            delay(delay_place)
                            reconnect(worldTutor,"", pnbTX, pnbTY)
                        end
                    end
                    
                    for _,i in pairs(tileBreak) do
                        while getTile(pnbTX + i,pnbTY - 1).fg ~= 0 or getTile(pnbTX + i,pnbTY - 1).bg ~= 0 and getTile(pnbTX+i, pnbTY-1).fg ~= 9640 do
                            bot:hit(bot.x+i, bot.y-1)
                            delay(delay_hit)
                            reconnect(worldTutor,"", pnbTX, pnbTY)
                        end
                    end
                end
            end
        else
            pnb()
        end
    end
    if worldNuked then
        tutorNuked = true
        pnb()
    end
end

function scanMarker()
    warps(pabrikWorld, door_farm)
    getBot().custom_status = customStatus.data
    if bot:isInWorld(pabrikWorld:upper()) then
        for _, tile in pairs(getTiles()) do
            reconnect(pabrikWorld, door_farm)
            if tile.fg == row_id or tile.bg == row_id then
                table.insert(Poss, {x = tile.x, y = tile.y})
            end
        end

        pnbX = Poss[position].x
        posY = Poss[position].y
        pnbY = {}
        local count = 0
        for _, tile in pairs(getTiles()) do 
            if tile.y == posY  then 
                if isPlantable(tile.x, tile.y) then 
                    count = count + 1 
                end 
            end 
        end 
        land = count or 100

        for i = 0, multiRow-1 do
            table.insert(pnbY, posY)
            posY = posY + multiRowDistance
        end
        
    end
end

function scanStorage() 
    local world = getBot():getWorld().name
    if world == "EXIT" then 
        return 
    end 
    for _, obj in pairs(getObjects()) do 
        storageAdd(world, obj.id, obj.count)
    end 
end

function scanItem(id) 
    local total = 0
    for _, obj in pairs(getObjects()) do 
        if obj.id == id then
            total = total + obj.count 
        end 
    end 
    return total 
end

function scanPack()
    local totalPacks = 0
    for _, obj in pairs(getObjects()) do
        if isIn(pack_item, tostring(obj.id)) then
            totalPacks = totalPacks + obj.count
            storageAdd(obj.id, obj.count)
        end
    end
    totalPack = totalPack + totalPacks 
    
    return totalPacks
end

function scanSeed()
    local scanTotal = 0
    for _, ye in pairs(pnbY) do
        for _, tile in pairs(getTiles()) do
            if tile.fg == seedID and tile.y == ye then
                scanTotal = scanTotal + 1
            end
        end
    end
    return scanTotal
end

function scanEmptyTiles()
    local emptyTiles = 0
    for _, ye in pairs(pnbY) do
        for _, tile in pairs(getTiles()) do
            if tile.fg == 0 and isPlantable(tile.x, tile.y) and tile.y == ye then
                emptyTiles = emptyTiles + 1
            end
        end
    end
    return emptyTiles
end

function scanFloating() 
    getBot().auto_collect = false
    for _, obj in pairs(getObjects()) do 
        if obj.id == blockID or obj.id == seedID then 
            getBot().custom_status = customStatus.clearing
        end
        if obj.id == blockID and itemCount(blockID) ~= 200 then 
            local x = round(obj.x/32) 
            local y = round(obj.y/32) 
            if posY - 1 == y then 
                if #getBot():getPath(x,y) > 0 then
                    getBot():findPath(x,y) 
                end 
                getBot():collectObject(obj.oid, 3)
                sleep(500)
            end 
        end 
        if obj.id == seedID and itemCount(seedID) ~= 200 then 
            local x = round(obj.x/32) 
            local y = round(obj.y/32)  
            if posY - 1 == y then 
                if #getBot():getPath(x,y) > 0 then
                    getBot():findPath(x,y) 
                end 
                getBot():collectObject(obj.oid, 3)
                sleep(500)
            end 
        end 
    end 
end 

function readyTreeScan()
    local readyTree = 0
    for _, ye in pairs(pnbY) do
        for _, tile in pairs(getTiles()) do
            if tile.fg == seedID and tile:canHarvest() and tile.y == ye then
                readyTree = readyTree + 1
            end
        end
    end
    return readyTree
end

function countPack() 
    local count = 0
    for _, obj in pairs(getObjects()) do 
        if isIn(pack_item, tostring(obj.id)) then 
            count = count + obj.count 
        end 
    end 
    return count 
end

function dropGoods()
    warps(world_storage[worldStorageIndex], door_storage)
    for _, goodz in pairs(goodies) do
        while itemCount(goodz) > 0 do 
            getBot():findOutput()
            bot:drop(goodz, itemCount(goodz))
            sleep(1000)
        end
    end
end

function trashJunk()
    for _, trsh in pairs(trash) do
        if itemCount(trsh) > 5 then
            reconnect(world_storage, door_storage)
            bot:trash(trsh, itemCount(trsh))
            sleep(1000)
        end
    end
end

function buyPacks()
    bot.auto_collect = false
    getBot().custom_status = customStatus.save
    bot.object_collect_delay = 60000
    while true do
        warps(world_packs[worldPackIndex], door_pack)
        if countPack() < max_drop_pack then 
            if bot:isInWorld(world_packs[worldPackIndex]:upper()) then
                availSlot = getBot():getInventory().slotcount - getBot():getInventory().itemcount
                while bot.gem_count >= pack_price and availSlot > 0 do
                    bot:buy(pack_name)
                    sleep(2000)
                    reconnect(world_packs[worldPackIndex], door_pack)
                    for _, itemz in pairs(pack_item) do
                        getBot():findOutput() 
                        getBot():drop(itemz, itemCount(itemz))
                        sleep(500)
                    end
                end 
                break
                scanStorage()
                callWebhook()
            end
        elseif countPack() >= max_drop_pack then 
            if worldPackIndex >= #world_packs then 
                local bmax = max_drop_pack
                worldPackIndex = 1 
                max_drop_pack = max_drop_pack * 2 
                callAlert(string.format("All storage reached max drop, max drop pack will be doubled\n%d --> %d", bmax, max_drop_pack))
            elseif worldPackIndex < #world_packs then
                worldPackIndex = worldPackIndex + 1
            end 
        end
    end
end


function plant()
    getBot().custom_status = customStatus.plant
    for _, ye in pairs(pnbY) do
        for _, tile in pairs(getTiles()) do
            reconnect(pabrikWorld, door_farm)
            while tile.fg == 0 and isPlantable(tile.x, tile.y) and itemCount(seedID) > 0 and hasAccess(tile.x, tile.y) > 0 and tile.y == ye and bot:isInWorld(pabrikWorld:upper()) do
                bot:findPath(tile.x, tile.y)
                if bot:isInTile(tile.x, tile.y) then
                    bot:place(bot.x, bot.y, seedID)
                    delay(delay_plant)
                    reconnect(pabrikWorld, door_farm)
                end
            end
        end
    end
end

function autoRemove()
    if bot.level >= level_rotation and auto_rotation then
        if itemCount(seedID) > 0 then
            dropItem(seedID)
        end
        if itemCount(blockID) > 0 then
            dropItem(blockID)
        end
        bot.rotation.enabled = true
        callAlert(bot.name:upper().." has reached a certain level, Starting rotation..")
        getBot():stopScript()
    end 
    if bot.level >= level_offline and auto_offline then
        if itemCount(seedID) > 0 then
            dropItem(seedID)
        end
        if itemCount(blockID) > 0 then
            dropItem(blockID)
        end
        bot.rotation.enabled = true
        callAlert(bot.name:upper().." has reached a certain level, bot offline")
        getBot().auto_reconnect = false 
        if remove_bot then 
            removeBot(bot.name)
        else 
            getBot():disconnect()
            getBot():stopScript()
        end 
    end 
end

function isReadyGrind(variant, netid)
    if variant:get(0):getString() == "OnDialogRequest" then
        if variant:get(1):getString():lower():find("grind wheat") then
            readyGrind = true
            unlistenEvents()
        end
    end
end

function grindWheat(worldName, doorID)
    if bot:isInWorld(worldName:upper()) then
        readyGrind = false
        for _, tile in pairs(getTiles()) do
            reconnect(worldName, doorID)
            if tile.fg == 4582 and hasAccess(tile.x, tile.y) > 0 then
                if #bot:getPath(tile.x, tile.y-1) > 0 then
                    bot:findPath(tile.x, tile.y-1)
                    sleep(100)
                elseif #bot:getPath(tile.x, tile.y+1) > 0 then
                    bot:findPath(tile.x, tile.y+1)
                    sleep(100)
                elseif #bot:getPath(tile.x-1, tile.y) > 0 then
                    bot:findPath(tile.x-1, tile.y)
                    sleep(100)
                elseif #bot:getPath(tile.x+1, tile.y) > 0 then
                    bot:findPath(tile.x+1, tile.y)
                    sleep(100)
                end
                ex, ye = bot.x, bot.y
                addEvent(Event.variantlist, isReadyGrind)
                while itemCount(blockID) == 200 do
                    reconnect(worldName, doorID, ex, ye)
                    bot:place(tile.x, tile.y, blockID)
                    listenEvents(2)
                    if readyGrind then
                        bot:sendPacket(2, "action|dialog_return\ndialog_name|grinder\ntilex|".. tile.x .."|\ntiley|".. tile.y .."|\nitemID|880|\ncount|4")
                        sleep(800)
                    end
                end
                removeEvent(Event.variantlist)
            end
            if itemCount(blockID) == 0 then
                break
            end
        end
    end
end

function autoGrind()
    getBot().custom_status = customStatus.grind
    bot.auto_collect = false
    if pabrikWorld ~= world_grinder then 
        warps(world_grinder, door_grinder)
    else 
        if getTile(getBot().x, getBot().y).fg == 6 then 
            warps(world_grinder, door_grinder)
        end 
    end 
    if not worldNuked then
        if bot:isInWorld(world_grinder:upper()) then
            if gscanBlock(4582) > 0 then
                grindWheat(world_grinder, door_grinder)
            else 
                print("Grinder Not Found!")
                callAlert("Grinder not Found!")
                bot:stopScript()
            end
        end
    else
        print("Public World got Nuked")
        callAlert("Grinder not Found!")
        bot:stopScript()
    end
end

function randomW()
    local length = 8
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end

firstWork = true
function malady()
    local function first()
        if firstWork then
            local malady = getBot().auto_malady
            malady.auto_grumbleteeth = true
            malady.auto_refresh = true
            malady.auto_chicken_feet = true
            local spam = getBot().auto_spam
            spam.random_interval = true
            spam.show_emote = false
            spam.randomizer = true
            spam.interval = 3.2
            spam.use_color = false
            local messages = spam.messages
            for _, msg in pairs(spam_messages) do
                messages:add(msg)
                sleep(50)
            end
            firstWork = false 
        end
    end 
	first()
    local function isPlayer() 
        local count = 0 
        for _, plr in pairs(getBot():getWorld():getPlayers()) do 
            if plr.name ~= getBot().name then 
                count = count + 1 
            end 
        end 
        return count 
    end 
    local function removeMalady() 
        if not isIn(blacklist_malady, tostring(getBot().malady)) then 
            return true 
        end
		print(bot.name.."removing malady")
		getBot().custom_status = customStatus.removeMalady
        local worldRemove = randomW()
        warps(worldRemove)
        while worldNuked do 
            worldRemove = randomW() 
            warps(worldRemove, "")
        end
        while isIn(blacklist_malady, tostring(getBot().malady)) do
            if isPlayer() > 0 then 
                worldRemove = randomW() 
                warps(worldRemove, "")
            end 
            reconnect(worldRemove,"")
            sleep(1 * 1000 * 60)
            callWebhook()
        end 
        if not isIn(blacklist_malady, tostring(getBot().malady)) then 
            return true 
        end
    end
	if isIn({3,4}, tostring(getBot().malady)) then 
		return true 
	end
    removeMalady()
    if auto_gruken and not isIn({3,4}, tostring(getBot().malady)) then
        local worldMalady = randomW() 
		getBot().custom_status = customStatus.getMalady
		print(bot.name.."getting malady")
        warps(worldMalady, "") 
        while worldNuked do 
            worldMalady = randomW() 
            warps(worldMalady, "")
        end 
        while not isIn({3,4}, tostring(getBot().malady)) do
            getBot().auto_malady.enabled = true 
            reconnect(worldMalady, "")
            if isPlayer() > 0 then 
                getBot().auto_malady.enabled = false
                worldMalady = randomW()
                warps(worldMalady, "")
                getBot().auto_malady.enabled = true 
            end
            sleep(1*1000*60)
            callWebhook()
        end 
    end
    return true
end

function joinRandom() 
	if warp_random_world then 
		for i = 1, random_world_count do 
			getBot():warp(randomW())
			sleep(random_world_delay) 
		end 
	end 
end

function main()
    while getBot().status ~= 1 do
        getBot().custom_status = customStatus.reconnect
    end
    if pnb_tutorial then
        checkTutorial()
        for i=1,3 do
            if worldTutor == "" then
                checkTutorial()
                sleep(500)
            end
        end
        if worldTutor == "" then
            print(bot.name:upper().." Doesn't Have Tutorial World!")
            callAlert(bot.name:upper().." Doesn't Have Tutorial World!, Will PNB in Pabrik")
            noTutorWorld = true
        end
    end
	autoWear(98)
    malady()
    if pabrikWorld then
        pabrikWorld = pabrikWorld:upper()

        while bot:isInWorld() do
            bot:leaveWorld()
            sleep(1000)
        end
        
        warps(pabrikWorld, door_farm)

        if not worldNuked then
			getBot().custom_status = customStatus.data
            scanMarker()
            sleep(200)

            if bot:isInWorld(pabrikWorld:upper()) then
				scanFloating()
                while scanEmptyTiles() > 0 and not emptyItem do

                    if scanEmptyTiles() >= 200 then
                        if itemCount(seedID) < scanEmptyTiles() then
                            takeItem(seedID, 200)
                            sleep(200)
                        end
                    else
                        if itemCount(seedID) < scanEmptyTiles() then
                            takeItem(seedID, scanEmptyTiles())
                            sleep(200)
                        end
                    end
                    
                    warps(pabrikWorld, door_farm)
                    if bot:isInWorld(pabrikWorld:upper()) then
                        plant()
                        sleep(200)
                    end

                end
                
                if gscanBlock(778) > 0 then
                    bot.anti_toxic = true
                    while gscanBlock(778) > 0 do
                        sleep(1000)
                    end
                    bot.anti_toxic = false
                end

            end
        end

        while not worldNuked do
            if auto_rotation and bot.level >= level_rotation then
                autoRemove()
            end
            if auto_take_pickaxe and itemCount(98) == 0 then
                print(bot.name:upper().." Taking Pickaxe")
                autoWear(98)
                sleep(200)
            end
            
            warps(pabrikWorld, door_farm)
            if bot:isInWorld(pabrikWorld:upper()) then
                if readyTreeScan() > 0 then
                    print(bot.name:upper().." Harvesting")
                    harvestPlant()
                    sleep(200)
                    if itemCount(seedID) >= 50 and itemCount(blockID) == 200 and auto_flour then
                        for i = 1,3 do
                            if itemCount(blockID) == 200 then
                                autoGrind()
                                sleep(200)
                            end
                        end
                        if itemCount(blockID) == 200 then
                            callAlert("Grind Fail!")
                        end
                    end

                    if itemCount(flourID) >= save_flour then
                        if save_vend then
                            for i = 1,3 do
                                if itemCount(flourID) >= save_flour then
                                    putVend(flourID)
                                    sleep(200)
                                end
                            end
                            if itemCount(flourID) > 0 then
                                callAlert("Vending are FULL!, Stopping Script")
                                bot:stopScript()
                            end
                        else
                            dropItem(flourID)
                            sleep(200)
                        end
                        
                        trashJunk()
                        dropGoods()

                        if buy_pack then
                            buyPacks()
                            sleep(200)
                        end
						joinRandom()

                        warps(pabrikWorld, door_farm)
                    end
                    
                    if itemCount(blockID) > 0 then
                        print(bot.name:upper().." PNB")
                        if pnb_tutorial then
                            if noTutorWorld or tutorNuked then
                                pnb()
                            else
                                pnbTutorial()
                            end
                        else
                            pnb()
                        end
                        sleep(200)
                    end
                else
                    print(bot.name:upper().." Waiting for Tree")
                    bot:say("/sleep")
                    sleep(30000)
                end
                warps(pabrikWorld, door_farm)
            end
        end
        if worldNuked then 
            callAlert(pabrikWorld.."got nuked, bot stopped")
            getBot():stopScript()
        end
    end
end

function getJson()
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

function verify() 
    local url = "https://gist.github.com/Evan0A/9b0209b1d2aa9edb44185e01332ca70b/raw"
    local client = HttpClient.new()
    client.url = url 
    local respond = client:request().body
    getJson() 
    if respond and json then 
        local succes, data = pcall(json.decode, respond)
        if succes and data then 
            local newver = data.current_version
            local found = false
            for _, datas in ipairs(data.accessList) do 
                if datas.lucifer == getUsername() then
                    found = true
                    if datas.version >= Sversion then
                        print("Username valid, welcome "..getUsername())
                        --webhook valid 
                        return true
                    elseif datas.version < Sversion then 
                        print("You can't use this script, script version: "..Sversion.."your version: "..datas.version)
                        return false
                    end 
                end 
            end 
            if not found then
                --webhook not found user 
                return false 
            end 
        else 
            --webhook error json 
            print("error at json, status: "..tostring(status)..", data: "..tostring(data))
            getBot():stopScript()
        end 
    else 
        print("error at json, respond: "..tostring(respond))
        getBot():stopScript()
    end 
end 

function getData()
    local mrow = #world_farm * world_farm_row
    local index = getBot().index - 1
    if botCount > mrow then 
        error("Need more farm world, total bot: "..cbot..", Total row: "..mrow)
    end 
    local duniaIndex = (index % #world_farm) + 1
    local barisIndex = math.floor(index / #world_farm) + 1

    local worldName = world_farm[duniaIndex]
    pabrikWorld = worldName 
    position = barisIndex
    return worldName, barisIndex
end

if verify() then 
    getData()
    main() 
else 
    getBot().custom_status = "User not found"
    print("user not found")
end





































