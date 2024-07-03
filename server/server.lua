local SMDXCore = exports['smdx-core']:GetSMDX()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^1['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------

local permissions = {
    ["adminmenu"] = "admin",
    ["revive"] = "admin",
    ["inventory"] = "admin",
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["goto"] = "admin",
    ["bring"] = "admin",
    ["freeze"] = "admin",
    ["spectate"] = "admin",
    ["wildattack"] = "admin",
    ["setonfire"] = "admin",
    ["giveitem"] = "admin",
    ["playerinfo"] = "admin",
}

-----------------------------------------------------------------------
-- get players function
-----------------------------------------------------------------------
SMDXCore.Functions.CreateCallback('smdx-adminmenu:server:getplayers', function(source, cb)
    local src = source
    local players = {}
    for k,v in pairs(SMDXCore.Functions.GetPlayers()) do
        local target = GetPlayerPed(v)
        local ped = SMDXCore.Functions.GetPlayer(v)
        players[#players + 1] = {
        name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname .. ' | (' .. GetPlayerName(v) .. ')',
        id = v,
        coords = GetEntityCoords(target),
        citizenid = ped.PlayerData.citizenid,
        sources = GetPlayerPed(ped.PlayerData.source),
        sourceplayer = ped.PlayerData.source
        }
    end

    table.sort(players, function(a, b)
        return a.id < b.id
    end)

    cb(players)
end)

-----------------------------------------------------------------------
-- ban player function
----------------------------------------------------------------------
local function BanPlayer(src)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        SMDXCore.Functions.GetIdentifier(src, 'license'),
        SMDXCore.Functions.GetIdentifier(src, 'discord'),
        SMDXCore.Functions.GetIdentifier(src, 'ip'),
        "system banned you",
        2524608000,
        'smdx-adminmenu'
    })
    TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(src), 'smdx-adminmenu', "system banned you for inappropriate use"), true)
    DropPlayer(src, Lang:t('lang_105'))
end

-----------------------------------------------------------------------
-- admin menu command
-----------------------------------------------------------------------
SMDXCore.Commands.Add('adminmenu', Lang:t('lang_100'), {}, false, function(source)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['adminmenu']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerClientEvent('smdx-adminmenu:client:openadminmenu', src)
    else
        --BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised use of Admin Menu', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' attempted to use the admin menu', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- revive player
-----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:playerrevive', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['revive']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerClientEvent('smdx-medic:client:adminRevive', player.id)
    else
        BanPlayer(src)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using admin revive', true)
    end
end)

-----------------------------------------------------------------------
-- open players inventory
-----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:openinventory', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['inventory']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('smdx-adminmenu:client:openinventory', src, player.id)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using open inventory', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- kick player
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:kickplayer', function(player, reason)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['kick']) or IsPlayerAceAllowed(src, 'command')  then
        TriggerEvent('smdx-log:server:CreateLog', 'bans', 'Player Kicked', 'red', string.format('%s was kicked by %s for %s', GetPlayerName(player), GetPlayerName(src), reason), true)
        DropPlayer(player, Lang:t('lang_103') .. ':\n' .. reason .. '\n\n' .. Lang:t('lang_104') .. SMDXCore.Config.Server.Discord)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using kick player', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

RegisterNetEvent('smdx-adminmenu:server:banplayer', function(player, time, reason)
    local src = source
    if SMDXCore.Functions.HasPermission(src, permissions['ban']) or IsPlayerAceAllowed(src, 'command') then
        time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2524608000 then
            banTime = 2524608000
        end
        local timeTable = os.date('*t', banTime)
        MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            GetPlayerName(player),
            SMDXCore.Functions.GetIdentifier(player, 'license'),
            SMDXCore.Functions.GetIdentifier(player, 'discord'),
            SMDXCore.Functions.GetIdentifier(player, 'ip'),
            reason,
            banTime,
            GetPlayerName(src)
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = "<div class=chat-message server'><strong>ANNOUNCEMENT | {0} has been banned:</strong> {1}</div>",
            args = {GetPlayerName(player), reason}
        })
        TriggerEvent('smdx-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(player), GetPlayerName(src), reason), true)
        if banTime >= 2524608000 then
            DropPlayer(player, Lang:t('lang_106') .. '\n' .. reason .. '\n\n'..Lang:t('lang_107')..'\n'..Lang:t('lang_108') .. SMDXCore.Config.Server.Discord)
        else
            DropPlayer(player, Lang:t('lang_106') .. '\n' .. reason .. '\n\n'..Lang:t('lang_109') .. timeTable['day'] .. '/' .. timeTable['month'] .. '/' .. timeTable['year'] .. ' ' .. timeTable['hour'] .. ':' .. timeTable['min'] .. '\n' ..('lang_110') .. SMDXCore.Config.Server.Discord)
        end
    else
        BanPlayer(src)
    end
end)

-----------------------------------------------------------------------
-- goto player
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:gotoplayer', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['goto']) or IsPlayerAceAllowed(src, 'command') then
        local admin = GetPlayerPed(src)
        local coords = GetEntityCoords(GetPlayerPed(player.id))
        SetEntityCoords(admin, coords)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using go to player', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- bring player
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:bringplayer', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['bring']) or IsPlayerAceAllowed(src, 'command') then
        local admin = GetPlayerPed(src)
        local coords = GetEntityCoords(admin)
        local target = GetPlayerPed(player.id)
        SetEntityCoords(target, coords)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using bring player', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- freeze player
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:freezeplayer', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['freeze']) or IsPlayerAceAllowed(src, 'command') then
        local target = GetPlayerPed(player.id)
        if not frozen then
            frozen = true
            FreezeEntityPosition(target, true)
            TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_111'), description = Lang:t('lang_112')..player.name, type = 'inform' })
        else
            frozen = false
            FreezeEntityPosition(target, false)
            TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_113'), description = Lang:t('lang_114')..player.name, type = 'inform' })
        end
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using freeze player', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- spectate player
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:spectateplayer', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['spectate']) or IsPlayerAceAllowed(src, 'command') then
        local targetped = GetPlayerPed(player.id)
        local coords = GetEntityCoords(targetped)
        TriggerClientEvent('smdx-adminmenu:client:spectateplayer', src, player.id, coords)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using spectate player', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- wild attack
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:wildattack', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['wildattack']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('smdx-adminmenu:client:wildattack', src, player.id)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using wild attack', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- set player on fire
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:playerfire', function(player)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['setonfire']) or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('smdx-adminmenu:client:playerfire', src, player.id)
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using set on fire', true)
        TriggerClientEvent('ox_lib:notify', source, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- give item
----------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:giveitem', function(player, item, amount)
    local src = source
    local Player = SMDXCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local citizenid = Player.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['giveitem']) or IsPlayerAceAllowed(src, 'command') then
        local id = player
        local Player = SMDXCore.Functions.GetPlayer(id)
        local amount = amount
        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('lang_135'), description = Lang:t('lang_136'), type = 'inform' })
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', firstname..' '..lastname..' with citizen id of '..citizenid..' banned for using give item', true)
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------
-- player info
----------------------------------------------------------------------
SMDXCore.Functions.CreateCallback('smdx-adminmenu:server:getplayerinfo', function(source, cb, player)
    local src = source
    local adminPlayer = SMDXCore.Functions.GetPlayer(src)
    local adminfirstname = adminPlayer.PlayerData.charinfo.firstname
    local adminlastname = adminPlayer.PlayerData.charinfo.lastname
    local admincitizenid = adminPlayer.PlayerData.citizenid

    if SMDXCore.Functions.HasPermission(src, permissions['playerinfo']) or IsPlayerAceAllowed(src, 'command') then
        
        local id = player.id
        local targetPlayer     = SMDXCore.Functions.GetPlayer(id)
        local targetfirstname  = targetPlayer.PlayerData.charinfo.firstname
        local targetlastname   = targetPlayer.PlayerData.charinfo.lastname
        local targetjob        = targetPlayer.PlayerData.job.label
        local targetgrade      = targetPlayer.PlayerData.job.grade.level
        local targetcash       = targetPlayer.PlayerData.money["cash"]
        local targetbank       = targetPlayer.PlayerData.money["bank"]
        local targetbloodmoney = targetPlayer.PlayerData.money["bloodmoney"]
        local targetcitizenid  = targetPlayer.PlayerData.citizenid
        local targetserverid   = id

        
        cb({
            firstname  = targetfirstname,
            lastname   = targetlastname,
            job        = targetjob, 
            grade      = targetgrade,
            cash       = targetcash,
            bank       = targetbank,
            bloodmoney = targetbloodmoney,
            citizenid  = targetcitizenid,
            serverid   = targetserverid,
        })
    else
        BanPlayer(src)
        TriggerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Unuthorised Use', 'red', adminfirstname..' '..adminlastname..' with citizen id of '..admincitizenid..' banned for using get player info', true)
        TriggerClientEvent('ox_lib:notify', src, {title = Lang:t('lang_101'), description = Lang:t('lang_102'), type = 'inform' })
    end
end)

-----------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
