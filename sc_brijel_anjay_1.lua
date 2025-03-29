start = 1
Bot = {}

Bot["BIJASU"] = {

    slot = 1, -- Bot slot info in webhook

    password = "hrtmain1140", -- Bot Password

    proxyIp = "92.119.183.180:61110:jevanshop123:jevanshop123", -- Proxy ip | ip:port:user:pass

    webhookLink = "https://discord.com/api/webhooks/1114483839444729936/yQzzCt22cCIF3Wz9XdhGMSmD78yCx3UxyzZNGThl01kbmM34Z2ern42Sy3slDjPI3xto", -- Bot webhook link

    messageId = "1355497648756625408",-- Webhook message id

    worldList = {"XYJMWXNMLTJC", "YQMKDWQWGWYR"}, -- World list

    doorFarm = "0858ptvvl", -- Rotation world door id

    webhookLinkPack = "https://discord.com/api/webhooks/1114483559114215476/HO4ARS2PrtmvRPO1_T2pvKAdJocqcx9u_K_4ZNMl4nR-H6a5Tl_yIdfk8TGcV6TOR0C3", -- Pack info webhook link

    messageIdPack = "1355498106300399768!", -- Pack info message id

    webhookLinkSeed = "https://discord.com/api/webhooks/1114483792632107039/EddcAS6GrI354fx_4n1YPq9l7YBBIeSiINGjK0S_zsCPkK6eU7rJLp3_wwtixbHoNdF4", -- Seed info webhook link

    messageIdSeed = "1155120530635108452", -- Seed info message id

    storagePack = "HEARTPTVPA0", -- Storage world

    doorPack = "0858PTVVL", -- Storage world door

    storageSeed = "HEARTPTVSE0", -- Storage world

    doorSeed = "0858PTVVL" -- Storage world door

}




webhookOffline = "https://discord.com/api/webhooks/1114483391446913024/fxbR3p8-UzNNj2uTPykEZefq7iibKSoKazREgod2rDgo5c2Q95X4fSAHehy2fugh1W9s" -- Bot On/Off with tag webhook link

patokanSeed, patokanPack = 4584, 4584 -- Patokan Seed and Pack



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

separatePlant = true -- Set true if separate harvest and plant

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

    for _,tile in pairs(bots:getWorld():getTiles()) do

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

    for _,tile in pairs(bots:getWorld():getTiles()) do

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



function warp(world,id)

    cok = 0

    while bots:getWorld().name ~= world:upper() and not nuked do

        while getBot().status ~= "online" do

            connect()

            sleep(5000)

        end

        bots:warp(world, id)

        sleep(5000)

        if cok == 10 then

            nuked = true

        else

            cok = cok + 1

        end

    end

    if id ~= "" and not nuked then

        while bots:getWorld():getTile(math.floor(getBot().x / 32),math.floor(getBot().y / 32)).fg == 6 and not nuked do

            while getBot().status ~= "online" do

                getBot():connect()

                sleep(5000)

            end

            bots:warp(world, id)

            sleep(1000)

        end

    end

end



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



function botInfo(info)

    te = os.time() - t

    fossill = fossil[getBot():getWorld().name] or 0

    local text = [[

        $webHookUrl = "]]..webhookLink..[[/messages/]]..messageId..[["

        $thumbnailObject = @{

            url = "https://komikkamvret.com/wp-content/uploads/2021/04/Pus-Nyangami-Roger-1024x978.png"

        }

        $footerObject = @{

            text = "]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[["

        }

        $fieldArray = @(

            @{

                name = "<:pickaxe:1011931845065183313> Bot Info"

                value = "]]..info..[["

                inline = "false"

            }

            @{

                name = "<:birth_certificate:1011929949076193291> Bot Name"

                value = "]]..getBot().name..[["

                inline = "true"

            }

            @{

                name = "<:heart_monitor:1012587208902987776> Bot Status"

                value = "]]..getBot().status..[["

                inline = "true"

            }

            @{

                name = "<:robots:1037182734067576842> Bot Captcha"

                value = "]]..getBot().captcha..[["

                inline = "true"

            }

            @{

                name = "<:gems:1011931178510602240> Bot Gems"

                value = "]]..getBot().gem_count..[["

                inline = "true"

            }

            @{

                name = "<:globe:1011929997679796254> World Name"

                value = "]]..getBot():getWorld().name..[["

                inline = "true"

            }

            @{

                name = "<:growtopia_scroll:1011972982261944444> World Order (]]..loop..[[)"

                value = "]]..start..[[ / ]]..stop..[["

                inline = "true"

            }

            @{

                name = "<:fossil_rock:1011972962573881464> World Fossil"

                value = "]]..fossill..[["

                inline = "true"

            }

            @{

                name = "<:shop_sign:1012590603172847648> Pack Name"

                value = "]]..pack..[["

                inline = "true"

            }

            @{

                name = "<:guest_book:1012588503466528869> Bot Profit"

                value = "]]..profit..[[ ]]..pack..[["

                inline = "true"

            }

            @{

                name = "<:change_of_address:1012566655995490354> World List"

                value = "]]..strWaktu..[["

                inline = "false"

            }

            @{

                name = "<:growtopia_clock:1011929976628596746> Bot Uptime"

                value = "]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"

                inline = "false"

            }

        )

        $embedObject = @{

            title = "<:exclamation_sign:1011934940096630794> **BOT INFORMATION** | SLOT - ]]..Bot[getBot().name:upper()].slot..[["

            color = "]]..math.random(1111111,9999999)..[["

            thumbnail = $thumbnailObject

            footer = $footerObject

            fields = $fieldArray

        }

        $embedArray = @($embedObject)

        $payload = @{

            embeds = $embedArray

        }

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'

    ]]

    local file = io.popen("powershell -command -", "w")

    file:write(text)

    file:close()

end



function packInfo(link,id,desc)

    local text = [[

        $webHookUrl = "]]..link..[[/messages/]]..id..[["

        $thumbnailObject = @{

            url = "https://komikkamvret.com/wp-content/uploads/2021/04/Pus-Nyangami-Roger-1024x978.png"

        }

        $footerObject = @{

            text = "]]..(os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60))..[["

        }

        $fieldArray = @(

            @{

                name = "Dropped Items"

                value = "]]..desc..[["

                inline = "false"

            }

        )

        $embedObject = @{

            title = "<:exclamation_sign:1011934940096630794> **PACK/SEED INFORMATION**"

            color = "]]..math.random(111111,999999)..[["

            thumbnail = $thumbnailObject

            footer = $footerObject

            fields = $fieldArray

        }

        $embedArray = @($embedObject)

        $payload = @{

            embeds = $embedArray

        }

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Patch -ContentType 'application/json'

    ]]

    local file = io.popen("powershell -command -", "w")

    file:write(text)

    file:close()

end



function reconInfo(status)

    if status then

        text = [[

            $webHookUrl = "]]..webhookOffline..[["

            $payload = @{

                content = "]]..getBot().name..[[ (slot-]]..Bot[getBot().name:upper()].slot..[[) status is ]]..getBot().status..[[ @everyone"

            }

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'

        ]]

    else

        text = [[

            $webHookUrl = "]]..webhookOffline..[["

            $payload = @{

                content = "]]..getBot().name..[[ (slot-]]..Bot[getBot().name:upper()].slot..[[) captcha is ]]..getBot().captcha..[[ @everyone"

            }

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 4) -Method Post -ContentType 'application/json'

        ]]

    end

    local file = io.popen("powershell -command -", "w")

    file:write(text)

    file:close()

end



function reconnect(world,id,x,y)

    while getBot().captcha:find("wrong") or getBot().captcha:find("failed") or getBot().captcha:find("no_access") or getBot().captcha:find("invalid_key") or getBot().captcha:find("invalid_token") do

        namez = getBot().name

        removeBot(getBot().name)

        sleep(10000)

        if proxy then

            addBot(namez, password)

            sleep(2000)

        else

            addBot(namez, password)

            sleep(2000)

        end

        recon = true

    end

    if getBot().status ~= "online" or recon then

        botInfo("Reconnecting")

        sleep(100)

        if not recon then

            reconInfo(true)

            sleep(100)

        end

        while true do

            if getBot().status == "account_banned" or getBot().status == "error_connecting" then

                botInfo(getBot().status)

                sleep(100)

                reconInfo(true)

                sleep(100)

                removeBot(getBot().name)

            end

            while getBot().status == "online" and not getBot():isInWorld(world) do

                getBot():warp(world:upper())

                sleep(5000)

            end

            if getBot().status == "online" and getBot():isInWorld(world) then

                if id ~= "" then

                    while getBot():getWorld():getTile(getBot().x, getBot()).fg == 6 do

                        getBot():warp(world, id)

                        sleep(1000)

                    end

                end

                if x and y and getBot().status == "online" and getBot().world == world:upper() then

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

    for _,obj in pairs(bots:getWorld():getObjects()) do

        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then

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

    for _,obj in pairs(bots:getWorld():getObjects()) do

        if round(obj.x / 32) == x and math.floor(obj.y / 32) == y then

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

    for _,pack in pairs(packList) do

        for _,tile in pairs(bots:getWorld():getTiles()) do

            if tile.fg == patokanPack or tile.bg == patokanPack then

                if tileDrop1(tile.x,tile.y,getBot():getInventory():findItem(pack)) then

                    while getBot().x ~= tile.x - 1 and getBot().y ~= tile.y do

                        bots:findPath(tile.x - 1,tile.y)

                        sleep(1000)

                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)

                    end

                    while bots:getInventory():findItem(pack) > 0 and tileDrop1(tile.x,tile.y,findItem(pack)) do

                        bots:drop(pack, bots:getInventory():findItem(pack))
                        
                        sleep(1000)

                        reconnect(storagePack,doorPack,tile.x - 1,tile.y)

                    end

                end

            end

            if bots:getInventory():findItem(pack) == 0 then

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

    for _,obj in pairs(bots:getWorld():getObjects()) do

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

    botInfo("Clearing World Logs")

    sleep(100)

    for _,wurld in pairs(worldToJoin) do

        bots:warp(wurld,"")

        sleep(joinDelay)

        reconnect(wurld,"")

    end

end



function storeSeed(world)

    botInfo("Storing Seed")

    sleep(100)

    bots:warp(storageSeed,doorSeed)

    sleep(100)

    for _,tile in pairs(bots:getWorld():getTiles()) do

        if tile.fg == patokanSeed or tile.bg == patokanSeed then

            if tileDrop2(tile.x,tile.y,100) then

                while getBot().x ~= tile.x - 1 or getBot().y ~= tile.y do

                    bots:findPath(tile.x - 1,tile.y)

                    sleep(1000)

                    reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)

                end

                while getBot():getInventory():findItem(itmSeed) > 100 and tileDrop2(tile.x,tile.y,100) do

                    getBot():drop(itmSeed, getBot():getInventory():findItem(itmSeed))
                    sleep(1000)

                    reconnect(storageSeed,doorSeed,tile.x - 1,tile.y)

                end

            end

            if findItem(itmSeed) <= 40 then

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

    getBot():warp(world,doorFarm)

    sleep(100)

    botInfo("Farming")

    sleep(100)

end



function buy()

    botInfo("Buying and Storing Pack")

    sleep(100)

    getBot():warp(storagePack,doorPack)

    sleep(100)

    while getBot().gem_count >= packPrice do

        while getBot():getInventory().slotcount < 16 do

            sendPacket("action|buy\nitem|upgrade_backpack",2)

            sleep(500)

        end

        for i = 1, packLimit do

            if getBot():gem_count > packPrice then

                sendPacket("action|buy\nitem|"..packName",2)

                sleep(500)

                profit = profit + 1

            else

                break

            end

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

            getBot():trash(item.id, item.count
            sleep(200)

        end

    end

end



function take(world)

    botInfo("Taking Seed")

    sleep(100)

    while getBot():getInventory():findItem(itmSeed) == 0 do

        getBot():warp(storageSeed,doorSeed)

        sleep(100)

        for _,obj in pairs(getBot():getWorld():getObjects()) do

            if obj.id == itmSeed then

                bots:findPath(round(obj.x, obj.y)

                sleep(1000)

                bots.collect_range = 2
                bots.auto_collect = true

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

        bots:warp(world,doorFarm)

        sleep(100)

    end

end



function plant(world)

    for _,tile in pairs(getBot():getWorld():getTiles()) do

        if bots:getInventory():findItem(itmSeed) == 0 and not dontPlant then

            take(world)

            sleep(100)

            botInfo("Farming")

            sleep(100)

        end

        if not tile:hasFlags(0) and tile.y ~= 0 and bots:getWorld():getTile(tile.x,tile.y - 1).fg == 0 then

            if not blacklistTile or check(tile.x,tile.y) then

                bots:findPath(tile.x,tile.y - 1)

                while bots:getWorld():getTile(tile.x,tile.y - 1).fg == 0 and bots:getWorld():getTile(tile.x,tile.y).flags ~= 0 do

                    bots:place(0,0, itmSeed)

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

    if bots:getInventory():findItem(itmId) >= tileNumber then

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

            bots:findPath(ex,ye)

            sleep(100)

        end

        if tileNumber > 1 then

            while getBot()getInventory():findItem(itmId) >= tileNumber and findItem(itmSeed) < 190 do

                while tilePlace(ex,ye) do

                    for _,i in pairs(tileBreak) do

                        if getTile(ex - 1,ye + i).fg == 0 and getTile(ex - 1,ye + i).bg == 0 then

                            bots:place(-1,i, itmId)

                            sleep(delayPlace)

                            reconnect(world,doorFarm,ex,ye)

                        end

                    end

                end

                while tilePunch(ex,ye) do

                    for _,i in pairs(tileBreak) do

                        if getTile(ex - 1,ye + i).fg ~= 0 or getTile(ex - 1,ye + i).bg ~= 0 then

                            bots:hit(-1,i)

                            sleep(delayPunch)

                            reconnect(world,doorFarm,ex,ye)

                        end

                    end

                end

                bots.collect_range = 3

                sleep(30)

            end

        else

            while getBot():getInventory():findItem(itmId) > 0 and bots:getInventory():findItem(itmSeed) < 190 do

                while bots:getWorld():getTile(ex - 1,ye).fg == 0 and bots:getWorld():getTile(ex - 1,ye).bg == 0 do

                    bots:place(-1,0, itmId)

                    sleep(delayPlace)

                    reconnect(world,doorFarm,ex,ye)

                end

                while bots:getWorld():getTile(ex - 1,ye).fg ~= 0 or getTile(ex - 1,ye).bg ~= 0 do

                    bots:hit(-1,0)

                    sleep(delayPunch)

                    reconnect(world,doorFarm,ex,ye)

                end

                bots.collect_range(2)

                sleep(30)

            end

        end

        clear()

        sleep(100)

        if buyAfterPNB and getBot().gem_count >= minimumGem then

            buy()

            sleep(100)

            bots:warp(world,doorFarm)

            sleep(100)

            botInfo("Farming")

            sleep(100)

        end

    end

end



function harvest(world)

    botInfo("Farming")

    sleep(100)

    tree[world] = 0

    if dontPlant then

        for _,tile in pairs(getBot():getWorld():getTiles()) do

            if getBot():getInventory():findItem(itmSeed) == 0 and not dontPlant then

                take(world)

                sleep(100)

                botInfo("Farming")

                sleep(100)

            end

            if getBot():getWorld():getTile(tile.x,tile.y - 1):canHarvest() then

                if not blacklistTile or check(tile.x,tile.y) then

                    tree[world] = tree[world] + 1

                    bots():findPath(tile.x,tile.y - 1)

                    while bots:getWorld():getTile(tile.x,tile.y - 1).fg == itmSeed do

                        bots:hit(0,0)

                        sleep(delayHarvest)

                        reconnect(world,doorFarm,tile.x,tile.y - 1)

                    end

                    if root then

                        while bots:getWorld():getTile(tile.x, tile.y).fg == (itmId + 4) and bots:getWorld():getTile(tile.x, tile.y).flags ~= 0 do

                            bots:hit(0, 1)

                            sleep(delayHarvest)

                            reconnect(world,doorFarm,tile.x,tile.y - 1)

                        end

                        clear()

                        sleep(100)

                    end

                    bots:collect_range = 2

                    sleep(30)

                end

            end

            if bots:getInventory():findItem(itmId) >= 180 then

                pnb(world)

                sleep(100)

                if getBot():getInventory():findItem(itmSeed) >= 180 then

                    storeSeed(world)

                    sleep(100)

                end

            end

        end

    elseif not separatePlant then

        for _,tile in pairs(getBot():getWorld():getTiles()) do

            if getBot():getInventory():findItem(itmSeed) == 0 and not dontPlant then

                take(world)

                sleep(100)

                botInfo("Farming")

                sleep(100)

            end

            if bots:getWorld():getTile(tile.x,tile.y - 1):canHarvest() or (tile.flags ~= 0 and tile.y ~= 0 and bots:getWorld():getTile(tile.x,tile.y - 1).fg == 0) then

                if not blacklistTile or check(tile.x,tile.y) then

                    tree[world] = tree[world] + 1

                    bots:findPath(tile.x,tile.y - 1)

                    while bots:getWorld():getTile(tile.x,tile.y - 1).fg == itmSeed do

                        bots:hit(0,0)

                        sleep(delayHarvest)

                        reconnect(world,doorFarm,tile.x,tile.y - 1)

                    end

                    if root then

                        while bots:getWorld():getTile(tile.x, tile.y).fg == (itmId + 4) and bots:getWorld():getTile(tile.x, tile.y).flags ~= 0 do

                            bots:hit(0, 1)

                            sleep(delayHarvest)

                            reconnect(world,doorFarm,tile.x,tile.y - 1)

                        end

                        clear()

                        sleep(100)

                    end

                    bots:collect_range = 2

                    sleep(30)

                    while bots:getWorld():getTile(tile.x,tile.y - 1).fg == 0 and bots:getWorld():getTile(tile.x,tile.y).flags ~= 0 do

                        bots:place(0,0, itmSeed)

                        sleep(delayPlant)

                        reconnect(world,doorFarm,tile.x,tile.y - 1)

                    end

                end

            end

            if getBot():getInventory():findItem(itmId) >= 180 then

                pnb(world)

                sleep(100)

                if bots:getInventory():findItem(itmSeed) >= 190 then

                    storeSeed(world)

                    sleep(100)

                end

            end

        end

    else

        for _,tile in pairs(bots:getWorld():getTiles()) do

            if bots:getInventory():findItem(itmSeed) == 0 and not dontPlant then

                take(world)

                sleep(100)

                botInfo("Farming")

                sleep(100)

            end

            if bots:getWorld():getTile(tile.x,tile.y - 1):canHarvest() then

                if not blacklistTile or check(tile.x,tile.y) then

                    tree[world] = tree[world] + 1

                    bots:findPath(tile.x,tile.y - 1)

                    while bots:getWorld()getTile(tile.x,tile.y - 1).fg == itmSeed do

                        bots:hit(0,0)

                        sleep(delayHarvest)

                        reconnect(world,doorFarm,tile.x,tile.y - 1)

                    end

                    if root then

                        while bots:getWorld():getTile(tile.x, tile.y).fg == (itmId + 4) and bots:getWorld():getTile(tile.x, tile.y).flags ~= 0 do

                            bots:hit(0, 1)

                            sleep(delayHarvest)

                            reconnect(world,doorFarm,tile.x,tile.y - 1)

                        end

                        clear()

                        sleep(100)

                    end

                    bots.collect_range = 2

                    sleep(30)

                end

            end

            if bots:getInventory():findItem(itmId) >= 180 then

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

if takePick and bots:getInventory():findItem(98) == 0 then

    bots:warp(storagePack,doorPack)

    sleep(100)

    while bots:getInventory():findItem(98) == 0 do

        for _,obj in pairs(getBot():getWorld():getObjects()) do

            if obj.id == 98 then

                bots:findPath(round(obj.x / 32),math.floor(obj.y / 32))

                sleep(1000)

                bots.collect_range = 2

                sleep(1000)

            end

            if bots:getInventory():findItem(98) > 0 then

                break

            end

        end

    end

    move(-1,0)

    sleep(100)

    bots:drop(98, bots:getInventory():findItem(98) - 1)
    
    sleep(1000)

    bots:wear(98)

    sleep(500)

end



while true do

    for index,world in pairs(worlds) do

        waktuWorld()

        sleep(100)

        warp(world,doorFarm)

        sleep(100)

        if not nuked then

            if detectFarmable then

                detect()

                sleep(100)

            end

            if bots:getInventory():findItem(itmSeed) == 0 and not dontPlant then

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
