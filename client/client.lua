local SMDXCore = exports['smdx-core']:GetSMDX()

-- main admin base menu
RegisterNetEvent('smdx-adminmenu:client:openadminmenu', function()

    lib.registerContext({
        id = 'admin_mainmenu',
        title = Lang:t('lang_0'),
        options = {
            {
                title = Lang:t('lang_0'),
                description = Lang:t('lang_1'),
                icon = 'fa-solid fa-user-secret',
                event = 'smdx-adminmenu:client:adminoptions',
                arrow = true
            },
            {
                title = Lang:t('lang_2'),
                description = Lang:t('lang_3'),
                icon = 'fa-solid fa-user',
                event = 'smdx-adminmenu:client:playersoptions',
                arrow = true
            },
            {
                title = Lang:t('lang_88'),
                description = Lang:t('lang_89'),
                icon = 'fa-solid fa-money-bill',
                event = 'smdx-adminmenu:client:playersfinances',
                arrow = true
            },
            {
                title = Lang:t('lang_4'),
                description = Lang:t('lang_5'),
                icon = 'fa-regular fa-face-grin-squint-tears',
                event = 'smdx-adminmenu:client:playerstroll',
                arrow = true
            },
            {
                title = Lang:t('lang_6'),
                description = Lang:t('lang_7'),
                icon = 'fa-solid fa-server',
                event = 'smdx-adminmenu:client:serveroptions',
                arrow = true
            },
            {
                title = Lang:t('lang_8'),
                description = Lang:t('lang_9'),
                icon = 'fa-solid fa-code',
                event = 'smdx-adminmenu:client:devoptions',
                arrow = true
            },
        }
    })
    lib.showContext('admin_mainmenu')

end)

-- admin options menu
RegisterNetEvent('smdx-adminmenu:client:adminoptions', function()

    lib.registerContext({
        id = 'admin_optionsmenu',
        title = Lang:t('lang_10'),
        menu = 'admin_mainmenu',
        onBack = function() end,
        options = {
            {
                title = Lang:t('lang_11'),
                description = Lang:t('lang_12'),
                icon = 'fa-solid fa-up-down-left-right',
                event = 'SMDXCore:Command:GoToMarker',
                arrow = true
            },
            {
                title = Lang:t('lang_13'),
                description = Lang:t('lang_14'),
                icon = 'fa-solid fa-heart-pulse',
                event = 'smdx-medic:client:playerRevive',
                arrow = true
            },
            {
                title = Lang:t('lang_15'),
                description = Lang:t('lang_16'),
                icon = 'fa-solid fa-ghost',
                event = 'smdx-adminmenu:client:goinvisible',
                arrow = true
            },
            {
                title = Lang:t('lang_17'),
                description = Lang:t('lang_18'),
                icon = 'fa-solid fa-book-bible',
                event = 'smdx-adminmenu:client:godmode',
                arrow = true
            },
        }
    })
    lib.showContext('admin_optionsmenu')

end)

-----------------------------------------------------------------------------------
-- player options
-----------------------------------------------------------------------------------

-- players options menu
RegisterNetEvent('smdx-adminmenu:client:playersoptions', function()
    SMDXCore.Functions.TriggerCallback('smdx-adminmenu:server:getplayers', function(players)
        local options = {}
        for k, v in pairs(players) do
            options[#options + 1] = {
                title = Lang:t('lang_19') ..v.id..' | '..v.name,
                description = Lang:t('lang_20'),
                icon = 'fa-solid fa-circle-user',
                event = 'smdx-adminmenu:client:playermenu',
                args = { name = v.name, player = v.id },
                arrow = true,
            }
        end
        lib.registerContext({
            id = 'players_optionssmenu',
            title = Lang:t('lang_21'),
            menu = 'admin_mainmenu',
            onBack = function() end,
            position = 'top-right',
            options = options
        })
        lib.showContext('players_optionssmenu')
    end)
end)

-----------------------------------------------------------------------------------

-- player menu
RegisterNetEvent('smdx-adminmenu:client:playermenu', function(data)

    lib.registerContext({
        id = 'player_menu',
        title = data.name,
        menu = 'players_optionssmenu',
        onBack = function() end,
        options = {
            {
                title = Lang:t('lang_137'),
                description = Lang:t('lang_138'),
                icon = 'fa-solid fa-briefcase-medical',
                event = 'smdx-adminmenu:server:playerinfo',
                args = { id = data.player },
                arrow = true
            },
            {
                title = Lang:t('lang_22'),
                description = Lang:t('lang_23'),
                icon = 'fa-solid fa-briefcase-medical',
                serverEvent = 'smdx-adminmenu:server:playerrevive',
                args = { id = data.player },
                arrow = true
            },
            {
                title = Lang:t('lang_130'),
                description = Lang:t('lang_131'),
                icon = 'fa-solid fa-gift',
                event = 'smdx-adminmenu:client:giveitem',
                args = { id = data.player },
                arrow = true
            },
            {
                title = Lang:t('lang_24'),
                description = Lang:t('lang_25'),
                icon = 'fa-solid fa-box',
                serverEvent = 'smdx-adminmenu:server:openinventory',
                args = { id = data.player },
                arrow = true
            },
            {
                title = Lang:t('lang_26'),
                description = Lang:t('lang_27'),
                icon = 'fa-solid fa-socks',
                event = 'smdx-adminmenu:client:kickplayer',
                args = { id = data.player, name = data.name },
                arrow = true
            },
            {
                title = Lang:t('lang_28'),
                description = Lang:t('lang_29') ,
                icon = 'fa-solid fa-ban',
                event = 'smdx-adminmenu:client:banplayer',
                args = { id = data.player, name = data.name },
                arrow = true
            },
            {
                title = Lang:t('lang_30'),
                description = Lang:t('lang_31'),
                icon = 'fa-solid fa-location-dot',
                serverEvent = 'smdx-adminmenu:server:gotoplayer',
                args = { id = data.player },
                arrow = true
            },
            {
                title = Lang:t('lang_32'),
                description = Lang:t('lang_33'),
                icon = 'fa-solid fa-hand',
                serverEvent = 'smdx-adminmenu:server:bringplayer',
                args = { id = data.player },
                arrow = true
            },
            {
                title = Lang:t('lang_34'),
                description = Lang:t('lang_35'),
                icon = 'fa-solid fa-snowflake',
                serverEvent = 'smdx-adminmenu:server:freezeplayer',
                args = { id = data.player, name = data.name },
                arrow = true
            },
            {
                title = Lang:t('lang_36'),
                description = Lang:t('lang_37'),
                icon = 'fa-solid fa-eye',
                serverEvent = 'smdx-adminmenu:server:spectateplayer',
                args = { id = data.player },
                arrow = true
            },
        }
    })
    lib.showContext('player_menu')

end)

-- server options menu
RegisterNetEvent('smdx-adminmenu:client:serveroptions', function()

    lib.registerContext({
        id = 'server_optionssmenu',
        title = Lang:t('lang_38'),
        menu = 'admin_mainmenu',
        onBack = function() end,
        options = {
            {
                title = Lang:t('lang_39'),
                description = Lang:t('lang_40'),
                icon = 'fa-solid fa-cloud-sun',
                event = 'weathersync:openAdminUi',
                arrow = true
            },
        }
    })
    lib.showContext('server_optionssmenu')

end)

-------------------------------------------------------------------
-- go invisible
-------------------------------------------------------------------
local invisible = false
RegisterNetEvent('smdx-adminmenu:client:goinvisible', function()
    TriggerServerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Admin Options', 'red', GetPlayerName() .. ' toggled > INVISIBLE MODE <')
    if invisible then
        SetEntityVisible(cache.ped, true)
        invisible = false
        lib.notify({ title = Lang:t('lang_42'), description = Lang:t('lang_43'), type = 'inform' })
    else
        SetEntityVisible(cache.ped, false)
        invisible = true
        lib.notify({ title = Lang:t('lang_44'), description = Lang:t('lang_45'), type = 'inform' })
    end
end)

-------------------------------------------------------------------
-- god mode
-------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:client:godmode', function()
    godmode = not godmode
    if godmode == true then
        lib.notify({ title = Lang:t('lang_46'), description = Lang:t('lang_47'), type = 'inform' })
    end
    TriggerServerEvent('smdx-log:server:CreateLog', 'adminmenu', 'Admin Options', 'red', GetPlayerName() .. ' toggled > GODMODE <')
    if godmode then
        while godmode do
            Wait(0)
            SetPlayerInvincible(cache.ped, true)
        end
        SetPlayerInvincible(cache.ped, false)
        lib.notify({ title = Lang:t('lang_48'), description = Lang:t('lang_49'), type = 'inform' })
    end
end)

-------------------------------------------------------------------
-- open player inventory
-------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:client:openinventory', function(targetPed)
    TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", targetPed)
end)

-------------------------------------------------------------------
-- kick player reason
-------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:client:kickplayer', function(data)
    local input = lib.inputDialog(Lang:t('lang_50')..data.name, {
        { 
            label = Lang:t('lang_51'),
            type = 'input',
            required = true,
        },
    })
    if not input then return end

    TriggerServerEvent('smdx-adminmenu:server:kickplayer', data.id, input[1])

end)

-------------------------------------------------------------------
-- ban player reason
-------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:client:banplayer', function(data)
    local input = lib.inputDialog(Lang:t('lang_52')..data.name, {
        { 
            label = Lang:t('lang_53'),
            type = 'select',
                options = {
                    { value = "permanent", label = "Permanent" },
                    { value = "temporary", label = "Temporary" },
                },
            required = true,
        },
        { 
            label = Lang:t('lang_54'),
            type = 'select',
                options = {
                    { value = '3600', label = Lang:t('lang_55') },
                    { value = '21600', label = Lang:t('lang_56') },
                    { value = '43200', label = Lang:t('lang_57') },
                    { value = '86400', label = Lang:t('lang_58') },
                    { value = '259200', label = Lang:t('lang_59') },
                    { value = '604800', label = Lang:t('lang_60') },
                    { value = '2678400', label = Lang:t('lang_61') },
                    { value = '8035200', label = Lang:t('lang_62') },
                    { value = '16070400', label = Lang:t('lang_63') },
                    { value = '32140800', label = Lang:t('lang_64') },
                    { value = '99999999999', label = Lang:t('lang_65') },
                },
            required = true,
        },
        { 
            label = Lang:t('lang_51'),
            type = 'input',
            required = true,
        }
    })

    if not input then return end

    -- permanent ban
    if input[1] == 'permanent' then
        TriggerServerEvent('smdx-adminmenu:server:banplayer', data.id, '99999999999', input[3])
        lib.notify({ title = Lang:t('lang_66'), description = data.name..Lang:t('lang_67'), type = 'inform' })
    end
    -- temporary ban
    if input[1] == 'temporary' then
        TriggerServerEvent('smdx-adminmenu:server:banplayer', data.id, input[2], input[3])
        lib.notify({ title = Lang:t('lang_66'), description = data.name..Lang:t('lang_68'), type = 'inform' })
    end
end)

-------------------------------------------------------------------
-- spectate player
-------------------------------------------------------------------

local lastSpectateCoord = nil
local isSpectating = false

RegisterNetEvent('smdx-adminmenu:server:spectateplayer', function(targetPed)
    local targetplayer = GetPlayerFromServerId(targetPed)
    local target = GetPlayerPed(targetplayer)
    if not isSpectating then
        isSpectating = true
        SetEntityVisible(cache.ped, false) -- Set invisible
        SetEntityCollision(cache.ped, false, false) -- Set collision
        SetEntityInvincible(cache.ped, true) -- Set invincible
        NetworkSetEntityInvisibleToNetwork(cache.ped, true) -- Set invisibility
        lastSpectateCoord = GetEntityCoords(cache.ped) -- save my last coords
        NetworkSetInSpectatorMode(true, target) -- Enter Spectate Mode
    else
        isSpectating = false
        NetworkSetInSpectatorMode(false, target) -- Remove From Spectate Mode
        NetworkSetEntityInvisibleToNetwork(cache.ped, false) -- Set Visible
        SetEntityCollision(cache.ped, true, true) -- Set collision
        SetEntityCoords(cache.ped, lastSpectateCoord) -- Return Me To My Coords
        SetEntityVisible(cache.ped, true) -- Remove invisible
        SetEntityInvincible(cache.ped, false) -- Remove godmode
        lastSpectateCoord = nil -- Reset Last Saved Coords
    end
end)

-------------------------------------------------------------------
-- sort table function
-------------------------------------------------------------------
local function compareNames(a, b)
    return a.value < b.value
end

-------------------------------------------------------------------
-- give item
-------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:client:giveitem', function(data)
    local option = {}

    for k, v in pairs(SMDXCore.Shared.Items) do
        local content = { value = v.name, label = v.label }
        option[#option + 1] = content
    end

    table.sort(option, compareNames)

    local item = lib.inputDialog(Lang:t('lang_132'), {
        { type = 'select', options = option, label = Lang:t('lang_133'), required = true },
        { type = 'number', label = Lang:t('lang_134'), required = true }
    })
    if not item then return end

    TriggerServerEvent('smdx-adminmenu:server:giveitem', data.id, item[1], item[2])

end)

-------------------------------------------------------------------
-- player info
-------------------------------------------------------------------
RegisterNetEvent('smdx-adminmenu:server:playerinfo', function(player)
    SMDXCore.Functions.TriggerCallback('smdx-adminmenu:server:getplayerinfo', function(data)
        lib.registerContext(
            {
                id = 'adminplayer_info',
                title = Lang:t('lang_139'),
                description = '',
                menu = 'players_optionssmenu',
                onBack = function() end,
                position = 'top-right',
                options = {
                    {
                        title = Lang:t('lang_140')..data.firstname..' '..data.lastname,
                        icon = 'user',
                    },
                    {
                        title = Lang:t('lang_141')..data.job,
                        icon = 'user',
                    },
                    {
                        title = Lang:t('lang_142')..tostring(data.grade),
                        icon = 'user',
                    },
                    {
                        title = Lang:t('lang_143')..tostring(data.cash),
                        icon = 'fa-solid fa-money-bill',
                    },
                    {
                        title = Lang:t('lang_144')..tostring(data.bank),
                        icon = 'fa-solid fa-building-columns',
                    },
                    {
                        title = Lang:t('lang_145')..tostring(data.bloodmoney),
                        icon = 'fa-solid fa-money-bill',
                    },
                    {
                        title = 'CitizenID : '..data.citizenid,
                        icon = 'fa-solid fa-id-card',
                    },
                    {
                        title = 'ServerID : '..data.serverid,
                        icon = 'fa-solid fa-server',
                    },
                }
            }
        )
        lib.showContext('adminplayer_info')
    end, player)
end)
