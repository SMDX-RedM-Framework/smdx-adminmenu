local SMDXCore = exports['smdx-core']:GetSMDX()

-- finances players menu
RegisterNetEvent('smdx-adminmenu:client:playersfinances', function()
    SMDXCore.Functions.TriggerCallback('smdx-adminmenu:server:getplayers', function(players)
        local options = {}
        for k, v in pairs(players) do
            options[#options + 1] = {
                title = Lang:t('lang_19')..v.id..' | '..v.name,
                description = Lang:t('lang_20'),
                icon = 'fa-solid fa-circle-user',
                event = 'smdx-adminmenu:client:financesoptions',
                args = { name = v.name, player = v.id },
                arrow = true,
            }
        end
        lib.registerContext({
            id = 'finances_menu',
            title = Lang:t('lang_88'),
            menu = 'admin_mainmenu',
            onBack = function() end,
            position = 'top-right',
            options = options
        })
        lib.showContext('finances_menu')
    end)
end)

-- finances options menu
RegisterNetEvent('smdx-adminmenu:client:financesoptions', function(data)
    SMDXCore.Functions.TriggerCallback('smdx-adminmenu:server:getPlayerData', function(result)
        lib.registerContext({
            id = 'finances_optionsmenu',
            title = Lang:t('lang_90'),
            menu = 'finances_menu',
            onBack = function() end,
            options = {
            {
                title = Lang:t('lang_122')..result.bank,
                description = Lang:t('lang_119'),
                readOnly = true
            },
            {
                title = Lang:t('lang_123')..result.cash,
                description = Lang:t('lang_120'),
                readOnly = true
            },
            {
                title = Lang:t('lang_124')..result.bloodmoney,
                description = Lang:t('lang_121'),
                readOnly = true
            },
            {
                title = Lang:t('lang_91'),
                description = Lang:t('lang_92'),
                icon = 'fa-solid fa-user-plus',
                iconColor = 'green',
                event = 'smdx-adminmenu:client:givemoney',
                args = { id = data.player, name = data.name },
                arrow = true
            },
            {
                title = Lang:t('lang_93'),
                description = Lang:t('lang_94'),
                icon = 'fa-solid fa-user-minus',
                iconColor = 'red',
                event = 'smdx-adminmenu:client:removemoney',
                args = { id = data.player, name = data.name },
                arrow = true
            },
            }
        })
        lib.showContext('finances_optionsmenu')
    end, data.player)
end)

-- give money to player (bank, cash, bloodmoney)
RegisterNetEvent('smdx-adminmenu:client:givemoney', function(data)

    local input = lib.inputDialog(data.name, {
        {
            label = Lang:t('lang_95'),
            description = Lang:t('lang_96'),
            type = 'select',
            options = {
                {
                    label = 'Bank', value = 'bank'
                },
                {
                    label = 'Cash', value = 'cash'
                },
                {
                    label = 'Blood Money', value = 'bloodmoney'
                },
            },
            required = true,
        },
        { 
            label = Lang:t('lang_97'),
            description = Lang:t('lang_98'),
            type = 'number',
            required = true,
        },
    })
    
    if not input then
        return
    end

    TriggerServerEvent('smdx-adminmenu:server:financeadd', data.id, input[1], input[2])

end)

-- remove money from player (bank, cash, bloodmoney)
RegisterNetEvent('smdx-adminmenu:client:removemoney', function(data)

    local input = lib.inputDialog(data.name, {
        {
            label = Lang:t('lang_95'),
            description = Lang:t('lang_99'),
            type = 'select',
            options = {
                {
                    label = 'Bank', value = 'bank'
                },
                {
                    label = 'Cash', value = 'cash'
                },
                {
                    label = 'Blood Money', value = 'bloodmoney'
                },
            },
            required = true,
        },
        { 
            label = Lang:t('lang_97'),
            description = Lang:t('lang_115'),
            type = 'number',
            required = true,
        },
    })
    
    if not input then
        return
    end

    TriggerServerEvent('smdx-adminmenu:server:financeremove', data.id, input[1], input[2])

end)
