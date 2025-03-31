start = 1
Bot = {}

Bot[getBot().name:upper()] = {

    slot = 1, -- Bot slot info in webhook

    password = "hrtmain1140", -- Bot Password

    proxyIp = "92.119.183.180:61110:jevanshop123:jevanshop123", -- Proxy ip | ip:port:user:pass

    webhookLink = "https://discord.com/api/webhooks/1114483738169061407/qTtcN8JaYq4yUbB7UUA3ATFD1keCObX9cJcSNvEU0ut1qG4S3_Ywg0veu-0VaAgh3IWA", -- Bot webhook link

    messageId = "",-- Webhook message id

    worldList = {"XYJMWXNMLTJC"}, -- World list

    doorFarm = "0858ptvvl", -- Rotation world door id

    webhookLinkPack = "https://discord.com/api/webhooks/1114483559114215476/HO4ARS2PrtmvRPO1_T2pvKAdJocqcx9u_K_4ZNMl4nR-H6a5Tl_yIdfk8TGcV6TOR0C3", -- Pack info webhook link

    messageIdPack = "", -- Pack info message id

    webhookLinkSeed = "https://discord.com/api/webhooks/1114483792632107039/EddcAS6GrI354fx_4n1YPq9l7YBBIeSiINGjK0S_zsCPkK6eU7rJLp3_wwtixbHoNdF4", -- Seed info webhook link

    messageIdSeed = "", -- Seed info message id

    storagePack = "HEARTPTVPA0", -- Storage world

    doorPack = "0858PTVVL", -- Storage world door

    storageSeed = "HEARTPTVSE0", -- Storage world

    doorSeed = "0858PTVVL" -- Storage world door

}




webhookOffline = "https://discord.com/api/webhooks/1114483391446913024/fxbR3p8-UzNNj2uTPykEZefq7iibKSoKazREgod2rDgo5c2Q95X4fSAHehy2fugh1W9s" -- Bot On/Off with tag webhook link

patokanSeed, patokanPack = 858, 858 -- Patokan Seed and Pack



blacklistTile = true

blacklist = {

    {x = -1, y = -1},

    {x = 0, y = -1},

    {x = 1, y = -1}

}



detectFarmable = false -- Set true if auto detect farmable

itmId = 4584 -- Item id

itmSeed = itmId + 1 -- Item seed / Dont edit



delayHarvest = 170 -- Harvesting delay

delayPlant = 150 -- Planting delay

delayPunch = 190 -- Punching delay

delayPlace = 200 -- Placing delay



tileNumber = 3 -- Customable from 1 to 5

customTile = false -- Set true if custom breaking pos

customX = 0 -- Custom breaking pos x

customY = 0 -- Custom breaking pos y



proxy = true -- Set true if using proxy

separatePlant = true
-- Set true if separate harvest and plant

dontPlant = false -- Set true if store all seed and dont plant any

buyAfterPNB = true -- Set true if buying and storing pack after each pnb

root = false -- Set true if farming root

looping = true -- Set false if not looping

takePick = false -- Auto take pickaxe from storage



pack = "SSP" -- Pack name to display on webhook

packList = {5706} -- List of pack id

packName = "ssp_10_pack" -- Pack name in store

minimumGem = 2000 -- Minimum gems to buy pack

packPrice = 1000 -- Pack price

packLimit = 1 -- Limit of buying pack before bp full



joinWorldAfterStore = false -- Set true if join random world after each rotation

worldToJoin = {"world1","world2","world3","world4","world5","world6","world7","world8","world9"} -- List of world to join after finishing 1 world

joinDelay = 10000 -- World join delay



restartTimer = true -- Set true if restart time of farm after looping

customShow = false -- Set true if showing only custom amount of world

showList = 5 -- Number of custom worlds to be shown



goods = {98, 18, 32, 6336, 9640} -- Item whitelist (don't edit)



items = {

    {name = "World Lock", id = 242, emote = "<:world_lock:1011929928519925820>"},

    {name = "Pepper Tree", id = 4584, emote = "<:pepper_tree:1011930020836544522>"},

    {name = "Pepper Tree Seed", id = 4585, emote = "<:pepper_tree_seed:1011930051744374805>"},

} -- List of item info



------------------ Dont Touch ------------------

bots = getBot()

list = {}

tree = {}

waktu = {}

worlds = {}

fossil = {}

tileBreak = {}

loop = 0

profit = 0

listNow = 1

strWaktu = ""

t = os.time()
getBot().collect_range = 4
proxyIp = Bot[getBot().name:upper()].proxyIp

password = Bot[getBot().name:upper()].password

stop = #Bot[getBot().name:upper()].worldList

doorFarm = Bot[getBot().name:upper()].doorFarm

worldList = Bot[getBot().name:upper()].worldList

totalList = #Bot[getBot().name:upper()].worldList

webhookLink = Bot[getBot().name:upper()].webhookLink

messageId = Bot[getBot().name:upper()].messageId

webhookLinkPack = Bot[getBot().name:upper()].webhookLinkPack

messageIdPack = Bot[getBot().name:upper()].messageIdPack

webhookLinkSeed = Bot[getBot().name:upper()].webhookLinkSeed

messageIdSeed = Bot[getBot().name:upper()].messageIdSeed

storagePack = Bot[getBot().name:upper()].storagePack

doorPack = Bot[getBot().name:upper()].doorPack

storageSeed = Bot[getBot().name:upper()].storageSeed

doorSeed = Bot[getBot().name:upper()].doorSeed



for i = start,#worldList do

    table.insert(worlds,worldList[i])

end



if looping then

    for i = 0,start - 1 do

        table.insert(worlds,worldList[i])

    end

end



for _,pack in pairs(packList) do

    table.insert(goods,pack)

end



for i = math.floor(tileNumber/2),1,-1 do

    i = i * -1

    table.insert(tileBreak,i)

end

for i = 0, math.ceil(tileNumber/2) - 1 do

    table.insert(tileBreak,i)

end



if (showList - 1) >= #worldList then

    customShow = false

end



if not detectFarmable then

    table.insert(goods,itmId)

    table.insert(goods,itmSeed)

end



if dontPlant then

    separatePlant = false

end



function includesNumber(table, number)

    for _,num in pairs(table) do

        if num == number then

            return true

        end

    end

    return false

end



function detect()

    local store = {}

    local count = 0

    for _,tile in pairs(getBot():getWorld():getTiles()) do

        if tile.flags == 0 and tile.fg ~= 0 then

            if store[tile.fg] then

                store[tile.fg].count = store[tile.fg].count + 1

            else

                store[tile.fg] = {fg = tile.fg, count = 1}

            end

        end

    end

    for _,tile in pairs(store) do

        if tile.count > count then

            count = tile.count

            itmSeed = tile.fg

            itmId = itmSeed - 1

        end

    end

    if not includesNumber(goods,itmId) then

        table.insert(goods,itmId)

    end

    if not includesNumber(goods,itmSeed) then

        table.insert(goods,itmSeed)

    end

end



function bl(world)

    blist = {}

    fossil[world] = 0

    for _,tile in pairs(getBot():getWorld():getTiles()) do

        if tile.fg == 6 then

            doorX = tile.x

            doorY = tile.y

        elseif tile.fg == 3918 then

            fossil[world] = fossil[world] + 1

        end

    end

    if blacklistTile then

        for _,tile in pairs(blacklist) do

            table.insert(blist,{x = doorX + tile.x, y = doorY + tile.y})

        end

    end

end



function tilePunch(x,y)

    for _,num in pairs(tileBreak) do

        if getTile(x - 1,y + num).fg ~= 0 or getTile(x - 1,y + num).bg ~= 0 then

            return true

        end

    end

    return false

end



function tilePlace(x,y)

    for _,num in pairs(tileBreak) do

        if getTile(x - 1,y + num).fg == 0 and getTile(x - 1,y + num).bg == 0 then

            return true

        end

    end

    return false

end



function check(x,y)

    for _,tile in pairs(blist) do

        if x == tile.x and y == tile.y then

            return false

        end

    end

    return true

end

function warps(world, id)
    print("warps called"..world.." "..id)
    world = world:upper()
    getBot():warp(world, id)
    sleep(10000)
    id = id or ''
    nuked = false
    stuck = false
    if not getBot():isInWorld(world) then
        getBot():leaveWorld()
        sleep(2000)
        addEvent(Event.variantlist, function(var, netid)
            if var:get(0):getString() == 'OnConsoleMessage' then
                if var:get(1):getString() == 'That world is inaccessible.' then
                    nuked = true
                    unlistenEvents()
                end
            end
        end)
        while not getBot():isInWorld(world) and not nuked do
            while client.status ~= BotStatus.online do
                sleep(5000)
            end
            getBot():warp(world, id)
            listenEvents(math.floor(10000 / 1000))
            sleep(10000)
        end
        removeEvent(Event.variantlist)
    end
    if getBot():isInWorld(world) and id ~= '' and getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 then
        local count = 0
        while getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 and not stuck do
            getBot():warp(id == '' and world or world .. ('|' .. id))
            sleep(10000)
            count = count + 1
            if count == 3 then
                stuck = true
            end
        end
    end
end

                
    --nuked = false

    --cok = 0

--    while not getBot():isInWorld(world) and not nuked do
--
  --      while getBot().status ~= "online" do

    --        getBot():connect()

      --      sleep(5000)

       -- end

       -- getBot():warp(world, id)

        --sleep(5000)

        --if cok == 10 then

          --  nuked = true

        --else

          --  cok = cok + 1

        --end

    --end

    --if id ~= "" and not nuked then

      --  while getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 and not nuked do

        --    while getBot().status ~= "online" do

          --      getBot():connect()

            --    sleep(5000)

            --end

            --getBot():warp(world, id)

            --sleep(1000)

        --end

    --end

--end



function waktuWorld()

    strWaktu = ""

    if customShow then

        for i = showList,1,-1 do

            newList = listNow - i

            if newList <= 0 then

                newList = newList + totalList

            end

            strWaktu = strWaktu.."\n"..worldList[newList]:upper().." ( "..(waktu[worldList[newList]] or "?").." | "..(tree[worldList[newList]] or "?").." )"

        end

    else

        for _,world in pairs(worldList) do

            strWaktu = strWaktu.."\n"..world:upper().." ( "..(waktu[world] or "?").." | "..(tree[world] or "?").." )"

        end

    end

end

function translatestatus(number)
    local statusList = {
        "offline",
        "online",
        "wrong_password",
        "account_banned",
        "location_banned",
        "version_update",
        "advanced_account_protection",
        "server_overload",
        "too_many_login",
        "maintenance",
        "server_busy",
        "guest_limit",
        "guest_disabled",
        "account_restricted",
        "network_restricted",
        "http_block",
        "bad_name_length",
        "invalid_account",
        "error_connecting",
        "logon_fail",
        "captcha_requested",
        "mod_entered",
        "player_entered",
        "high_load",
        "high_ping",
        "changing_subserver",
        "stopped",
        "getting_server_data",
        "bypassing_server_data"
    }

    return statusList[number + 1] or "unknown_status" -- Lua index mulai dari 1, jadi tambahkan 1
end


function botInfo(info)
    botstatus = translatestatus(getBot().status)

    te = os.time() - t

    fossill = fossil[getBot():getWorld().name] or 0

    webhook = Webhook.new("webhookLink") 
    webhook.embed1.use = true
    webhook.embed1.thumbnail = "https://komikkamvret.com/wp-content/uploads/2021/04/Pus-Nyangami-Roger-1024x978.png"
    
    webhook.embed1.title = "<:exclamation_sign:1011934940096630794> **BOT INFORMATION** | SLOT - "..Bot[getBot().name:upper()].slot
    
    webhook.embed1.color = math.random(1111111,9999999)
    
    

    webhook.embed1.footer.text = (os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))

    webhook.embed1:addField("<:pickaxe:1011931845065183313> Bot Info", info, false)

    webhook.embed1:addField("<:birth_certificate:1011929949076193291> Bot Name", getBot().name, true)

    webhook.embed1:addField("<:heart_monitor:1012587208902987776> Bot Status", botstatus, true)

    webhook.embed1:addField("<:rogetBot():1037182734067576842> Bot Captcha", getBot().captcha, true)

    webhook.embed1:addField("<:gems:1011931178510602240> Bot Gems", getBot().gem_count, true)
    
    webhook.embed1:addField("<:globe:1011929997679796254> World Name", getBot():getWorld().name, true)

    webhook.embed1:addField("<:growtopia_scroll:1011972982261944444> World Order (]]..loop..[[)", start.."|"..stop, true)

    webhook.embed1:addField("<:fossil_rock:1011972962573881464> World Fossil", fossill, true)

    webhook.embed1:addField("<:shop_sign:1012590603172847648> Pack Name", pack, true)

    webhook.embed1:addField("<:guest_book:1012588503466528869> Bot Profit", profit.." "..pack, true)

    webhook.embed1:addField("<:change_of_address:1012566655995490354> World List", strWaktu, false)

    webhook.embed1:addField("<:growtopia_clock:1011929976628596746> Bot Uptime", math.floor(te/3600).." Days "..math.floor(te%86400/3600).." Hours "..math.floor(te%86400%3600/60).." Minutes", false)

    if messageId ~= "" then
        webhook:edit(messageId)
    else
        webhook:send()
    end
end



function packInfo(link,id,desc)

    webhook = Webhook.new(link)
    webhook.embed1.use = true
    webhook.embed1.thumbnail = "https://komikkamvret.com/wp-content/uploads/2021/04/Pus-Nyangami-Roger-1024x978.png"
    webhook.embed1.footer.text = os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60)
    webhook.embed1:addField("Dropped items", desc, false)

    webhook.embed1.title = "<:exclamation_sign:1011934940096630794> **PACK/SEED INFORMATION**"
    webhook.embed1.color = math.random(111111, 999999)
    
    if id ~= "" then webhook:edit(id) else webhook:send() end 
end



function reconInfo(status)
    statss = translatestatus(getBot().status)
    webhook = Webhook.new(webhookOffline)
    if status then
        webhook.content = getBot().name.."(slot-"..Bot[getBot().name:upper()].slot..") Status is"..statss.." @everyone"
    end
    webhook:send()
end



function reconnect(world,id,x,y)
    recon = false
    if getBot().status ~= 0 then recon = true end
    
    if getBot().status ~= 1 or recon then

        botInfo("Reconnecting")

        sleep(100)

        if not recon then

            reconInfo(true)

            sleep(100)

        end

        while true do

            if getBot().status == 3 or getBot().status == 4 then

                botInfo(getBot().status)

                sleep(100)

                reconInfo(true)

                sleep(100)

                removeBot(getBot().name)

            end

            while getBot().status == 1 and not getBot():isInWorld(world) do

                warps(world:upper())

                sleep(5000)

            end

            if getBot().status == 1 and getBot():isInWorld(world) then

                if id ~= "" then

                    while getBot():getWorld():getTile(getBot().x, getBot().y).fg == 6 do

                        warps(world, id)

                        sleep(1000)

                    end

                end

                if x and y and getBot().status == 1 and getBot().world == world:upper() then

                    while getBot().x ~= x or getBot().y ~= y do

                        getBot():findPath(x,y)

                        sleep(1000)

                    end

                    break

                end

            end

        end

        botInfo("Succesfully Reconnected")

        sleep(100)

        if recon then

            reconInfo(false)

            sleep(100)

        else

            reconInfo(true)

            sleep(100)

        end

        botInfo("Farming")

        sleep(100)

        recon = false

    end

end



function round(n)

    return n % 1 > 0.5 and math.ceil(n) or math.floor(n)

end



function tileDrop1(x,y,num)

    local count = 0

    local stack = 0

    for _,obj in pairs(getBot():getWorld():getObjects()) do

        if round(obj.x) == x and obj.y == y then

            count = count + obj.count

            stack = stack + 1

        end

    end

    if stack < 20 and count <= (4000 - num) then

        return true

    end

    return false

end



function tileDrop2(x,y,num)

    local count = 0

    local stack = 0

    for _,obj in pairs(getBot():getWorld():getObjects()) do

        if round(obj.x) == x and obj.y == y then

            count = count + obj.count

            stack = stack + 1

        end

    end

    if count <= (4000 - num) then

        return true

    end

    return false

end



function storePack()

    getBot().auto_collect = false

    for _,pack in pairs(packList) do

        for _,tile in pairs(getBot():getWorld():getTiles()) do

            if tile.fg == patokanPack or tile.bg == patokanPack then

                if tileDrop1(tile.x,tile.y,getBot():getInventory():findItem(pack)) then

                    while getBot().x ~= tile.x - 1 and getBot().y ~= tile.y do

                        getBot():findPath(tile.x - 1,tile.y)

                        sleep(1000)

                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)

                    end

                    while getBot():getInventory():getItemCount(pack) > 0 and tileDrop1(tile.x,tile.y,getBot():getInventory():findItem(pack)) do

                        getBot():drop(pack, getBot():getInventory():findItem(pack))
                        
                        sleep(1000)

                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)

                    end

                end

            end

            if getBot():getInventory():findItem(pack) == 0 then

                break

            end

        end

    end

end



function itemInfo(ids)

    local result = {name = "null", id = ids, emote = "null"}

    for _,item in pairs(items) do

        if item.id == ids then

            result.name = item.name

            result.emote = item.emote

            return result

        end

    end

    return result

end



function infoPack()

    local store = {}

    for _,obj in pairs(getBot():getWorld():getObjects()) do

        if store[obj.id] then

            store[obj.id].count = store[obj.id].count + obj.count

        else

            store[obj.id] = {id = obj.id, count = obj.count}

        end

    end

    local str = ""

    for _,object in pairs(store) do

        str = str.."\n"..itemInfo(object.id).emote.." "..itemInfo(object.id).name.." : x"..object.count

    end

    return str

end



function join()

    getBot().auto_collect = false

    botInfo("Clearing World Logs")

    sleep(100)

    for _,wurld in pairs(worldToJoin) do

        getBot():warp(wurld,"")

        sleep(joinDelay)

        reconnect(wurld,"")

    end

end



function storeSeed(world)

    getBot().auto_collect = false

    botInfo("Storing Seed")

    sleep(100)

    warps(storageSeed,doorSeed)

    sleep(100)

    for _,tile in pairs(getBot():getWorld():getTiles()) do

        if tile.fg == patokanSeed or tile.bg == patokanSeed then

            if tileDrop2(tile.x,tile.y,100) then

                while getBot().x ~= tile.x - 1 or getBot().y ~= tile.y do

                    getBot():findPath(tile.x - 1,tile.y)

                    sleep(1000)

                    reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)

                end

                while getBot():getInventory():findItem(itmSeed) > 100 and tileDrop2(tile.x,tile.y,100) do

                    getBot():drop(itmSeed, getBot():getInventory():findItem(itmSeed))
                    sleep(1000)

                    reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)

                end

            end

            if getBot():getInventory():findItem(itmSeed) <= 40 then

                break

            end

        end

    end

    packInfo(webhookLinkSeed,messageIdSeed,infoPack())

    sleep(100)

    if joinWorldAfterStore then

        join()

        sleep(100)

    end

    warps(world,doorFarm)

    sleep(100)

    botInfo("Farming")

    sleep(100)

end



function buy()

    botInfo("Buying and Storing Pack")

    sleep(100)

    warps(storagePack,doorPack)

    sleep(100)

    while getBot().gem_count >= packPrice do

        while getBot():getInventory().slotcount < 16 do

            sendPacket("action|buy\nitem|upgrade_backpack",2)

            sleep(500)

        end

        while getBot().gem_count >= minimumGem do

            getBot():buy(packName)

            sleep(1000)

            profit = profit + 1

        end

        storePack()

        sleep(100)

        reconnect(storagePack,doorPack)

    end

    packInfo(webhookLinkPack,messageIdPack,infoPack())

    sleep(100)

    if joinWorldAfterStore then

        join()

        sleep(100)

    end

end



function clear()

    for _,item in pairs(getBot():getInventory()) do

        if not includesNumber(goods, item.id) then

            getBot():trash(item.id, item.count)
            sleep(200)

        end

    end

end



function take(world)

    getBot().auto_collect = true

    botInfo("Taking Seed")

    sleep(100)

    while getBot():getInventory():findItem(itmSeed) == 0 do

        warps(storageSeed,doorSeed)

        sleep(100)

        for _,obj in pairs(getBot():getWorld():getObjects()) do

            if obj.id == itmSeed then

                getBot():findPath(round(obj.x, obj.y))

                sleep(1000)

                getBot().collect_range = 2
                getBot().auto_collect = true

                sleep(1000)

            end

            if getBot():getInventory():findItem(itmSeed) > 0 then

                break

            end

        end

        packInfo(webhookLinkSeed,messageIdSeed,infoPack())

        sleep(100)

        if joinWorldAfterStore then

            join()

            sleep(100)

        end

        warps(world,doorFarm)

        sleep(100)

    end

end



function plant(world)

    getBot().auto_collect = false

    for _,tile in pairs(getBot():getWorld():getTiles()) do

        if getBot():getInventory():findItem(itmSeed) == 0 and not dontPlant then

            take(world)

            sleep(100)

            botInfo("Farming")

            sleep(100)

        end

        if not tile:hasFlag(0) and tile.y ~= 0 and getBot():getWorld():getTile(tile.x,tile.y - 1).fg == 0 then

            if not blacklistTile or check(tile.x,tile.y) then

                getBot():findPath(tile.x,tile.y - 1)

                while getBot():getWorld():getTile(tile.x,tile.y - 1).fg == 0 and getBot():getWorld():getTile(tile.x,tile.y).flags ~= 0 do

                    getBot():place(0,0, itmSeed)

                    sleep(delayPlant)

                    reconnect(world,doorFarm,tile.x,tile.y - 1)

                end

            end

        end

    end

    if getBot():getInventory():findItem(itmSeed) >= 100 then

        storeSeed(world)

        sleep(100)

    end

end



function pnb(world)

    getBot().auto_collect = true

    if getBot():getInventory():findItem(itmId) >= tileNumber then

        if not customTile then

            ex = 1

            ye = getBot().y

            if ye > 40 then

                ye = ye - 10

            elseif ye < 11 then

                ye = ye + 10

            end

            if getBot():getWorld():getTile(ex,ye).fg ~= 0 and getBot():getWorld():getTile(ex,ye).fg ~= itmSeed then

                ye = ye - 1

            end

        else

            ex = customX

            ye = customY

        end

        while getBot().x ~= ex or getBot().y ~= ye do

            getBot():findPath(ex,ye)

            sleep(100)

        end

        if tileNumber > 1 then

            while getBot():getInventory():findItem(itmId) >= tileNumber and getBot():getInventory():findItem(itmSeed) < 190 do

                while tilePlace(ex,ye) do

                    for _,i in pairs(tileBreak) do

                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then

                            getBot():place(-1,i, itmId)

                            sleep(delayPlace)

                            reconnect(world,doorFarm,ex,ye)

                        end

                    end

                end

                while tilePunch(ex,ye) do

                    for _,i in pairs(tileBreak) do

                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then

                            getBot():hit(-1,i)

                            sleep(delayPunch)

                            reconnect(world,doorFarm,ex,ye)

                        end

                    end

                end

                getBot().collect_range = 3

                sleep(30)

            end

        else

            while getBot():getInventory():findItem(itmId) > 0 and getBot():getInventory():findItem(itmSeed) < 190 do

                while getBot():getWorld():getTile(ex - 1,ye).fg == 0 and getBot():getWorld():getTile(ex - 1,ye).bg == 0 do

                    getBot():place(-1,0, itmId)

                    sleep(delayPlace)

                    reconnect(world,doorFarm,ex,ye)

                end

                while getBot():getWorld():getTile(ex - 1,ye).fg ~= 0 or getTile(ex - 1,ye).bg ~= 0 do

                    getBot():hit(-1,0)

                    sleep(delayPunch)

                    reconnect(world,doorFarm,ex,ye)

                end

                getBot().auto_collect = true

                getBot().collect_range = 2

                sleep(30)

            end

        end

        clear()

        sleep(100)

        if buyAfterPNB and getBot().gem_count >= minimumGem then

            buy()

            sleep(100)

            warps(world,doorFarm)

            sleep(100)

            botInfo("Farming")

            sleep(100)

        end

    end

end

function harvest(world)
    
    getBot():auto_collect = true

    botInfo("Farming")

    sleep(100)

    tree[world] = 0

    if dontPlant then

        for _,tile in pairs(getBot():getWorld():getTiles()) do

            if getBot():getWorld():getTile(tile.x,tile.y):canHarvest() then

                if not blacklistTile or check(tile.x,tile.y) and getBot():getWorld():hasAccess(tile.x, tile.y) then

                    tree[world] = tree[world] + 1

                    getBot():findPath(tile.x,tile.y)

                    while getBot():getWorld():getTile(tile.x,tile.y).fg == itmSeed do

                        getBot():hit(0,0)

                        sleep(delayHarvest)

                        reconnect(world,doorFarm,tile.x,tile.y - 1)

                    end

                end

            end

            if getBot():getInventory():findItem(itmId) >= 180 then

                pnb(world)

                sleep(100)

                storeSeed(world)

            end

        end

    elseif not separatePlant then
        
        for _,tile in pairs(getBot():getWorld():getTiles()) do

            if getBot():getWorld():getTile(tile.x,tile.y):canHarvest() and getBot():getWorld():getTile(tile.x,tile.y + 1).fg ~= itmId then
    
                    if (not blacklistTile or check(tile.x,tile.y)) and getBot():getWorld():hasAccess(tile.x, tile.y) then
    
                        tree[world] = tree[world] + 1
    
                        getBot():findPath(tile.x,tile.y)
    
                        while getBot():getWorld():getTile(tile.x,tile.y).fg == itmSeed do
    
                            getBot():hit(0,0)
    
                            sleep(delayHarvest)
    
                            reconnect(world,doorFarm,tile.x,tile.y)
    
                        end
    
                        while getBot():getWorld():getTile(tile.x,tile.y).fg == 0 and getBot():getWorld():getTile(tile.x, tile.y + 1):hasFlag(0) do
    
                            getBot():place(0,0, itmSeed)
    
                            sleep(delayPlant)
    
                            reconnect(world,doorFarm,tile.x,tile.y)
    
                        end
    
                    end
    
                end

            if getBot():getInventory():findItem(itmId) >= 180 then

                pnb(world)

                sleep(100)

                plant(world)

                sleep(100)

            end

        end

    else

        for _,tile in pairs(getBot():getWorld():getTiles()) do

            if getBot():getWorld():getTile(tile.x,tile.y):canHarvest() then

                if (not blacklistTile or check(tile.x,tile.y)) and getBot():getWorld():hasAccess(tile.x, tile.y) then

                    tree[world] = tree[world] + 1

                    getBot():findPath(tile.x,tile.y)

                    while getBot():getWorld():getTile(tile.x,tile.y).fg == itmSeed do

                        getBot():hit(0,0)

                        sleep(delayHarvest)

                        reconnect(world,doorFarm,tile.x,tile.y)

                    end
                    
                end

            end

            if getBot():getInventory():findItem(itmId) >= 180 then

                pnb(world)

                sleep(100)

                plant(world)

                sleep(100)

            end

        end

    end

    pnb(world)

    sleep(100)

    if separatePlant then

        plant(world)

        sleep(100)

    end

    if getBot().gem_count >= minimumGem then

        buy()

        sleep(100)

    end

end

if takePick and getBot():getInventory():findItem(98) == 0 then

    warps(storagePack,doorPack)

    sleep(100)

    while getBot():getInventory():findItem(98) == 0 do

        for _,obj in pairs(getBot():getWorld():getObjects()) do

            if obj.id == 98 then

                getBot():findPath(round(obj.x),math.floor(obj.y))

                sleep(1000)

                getBot().collect_range = 2

                sleep(1000)

            end

            if getBot():getInventory():findItem(98) > 0 then

                break

            end

        end

    end

    getBot():moveLeft(1)

    sleep(100)

    getBot():drop(98, getBot():getInventory():findItem(98) - 1)
    
    sleep(1000)

    getBot():wear(98)

    sleep(500)

end



while true do
    print("v14, enter while true")

    for index,world in pairs(worlds) do

        waktuWorld()

        sleep(100)

        warps(world,doorFarm)

        sleep(100)

        if not nuked then

            if detectFarmable then

                detect()

                sleep(100)

            end

            if getBot():getInventory():findItem(itmSeed) == 0 and not dontPlant then

                take(world)

                sleep(100)

            end

            bl(world)

            sleep(100)

            botInfo("Starting "..world)

            sleep(100)

            tt = os.time()

            harvest(world)

            sleep(100)

            tt = os.time() - tt

            botInfo("Finished "..world)

            sleep(100)

            waktu[world] = math.floor(tt/3600).." Hours "..math.floor(tt%3600/60).." Minutes"

            sleep(100)

            if joinWorldAfterStore then

                join()

                sleep(100)

            end

        else

            waktu[world] = "NUKED"

            tree[world] = "NUKED"

            nuked = false

            sleep(5000)

        end

        if start < stop then

            start = start + 1

        else

            if restartTimer then

                waktu = {}

                tree = {}

            end

            start = 1

            loop = loop + 1

        end

    end

    if not looping then

        waktuWorld()

        sleep(100)

        botInfo("Finished All World, Removing Bot!")

        sleep(100)

        removeBot(getBot().name)

        break

    end

end
