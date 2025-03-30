function botInfo(info)
    colour = 0 
    bstatus = ""
    stats = ""
    fossill = fossil[getBot():getWorld().name] or 0
    if getBot().status == 1 then
        colour = 65280
        stats = "<a:Online1:1355754776955977788>"
        bstatus = "Online"
    else
        colour = 16711680
        stats = "<a:offline:1355765716267171850>"
        bstatus = "Offline"
    end
    webhook = Webhook.new(webhookLink)
    
    webhook.embed1.use = true
    webhook.embed1.color = colour
    webhook.embed1.title = "<:pickaxe:1011931845065183313> ROTATION BOT STATUS: "..info
    webhook.embed1:addField(":robot: ] Bot's name: ", "||"..getBot().name.."("..getBot().level..")||")
    webhook.embed1:addField(stats.." ] Bot's status: ", bstatus.."("..getBot().status..")", true)
    webhook.embed1:addField("<:ruby:1355776434219651243> ] Bot's gems:", getBot().gem_count, true)
    webhook.embed1:addField("<:Earth_Minecraft:1355777709443121212> ] Bot's world: ", "||"..getBot():getWorld().name.."||", true)
    webhook.embed1:addField("<:fossil_rock:1011972962573881464> ] Fossil: ")
    webhook.embed1.footer.text = "]]"..os.date("!%a %b %d, %Y at %I:%M %p", os.time() + 7 * 60 * 60).."[["
    if messageId ~= "" then
        webhook:edit(messageId)
    else
        webhook:send()
    end
end
botInfo(info)
