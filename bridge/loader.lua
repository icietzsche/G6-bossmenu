Bridge = Bridge or {}
Bridge.Framework = Bridge.Framework or {}
Bridge.TextUI = Bridge.TextUI or {}
Bridge.Target = Bridge.Target or {}
Bridge.Notify = Bridge.Notify or {}
Bridge.Banking = Bridge.Banking or {}

function _U(str, ...)
    local lang = (Config and Config.Locale) or 'en'
    if not Locales or not Locales[lang] then lang = 'en' end
    local text = Locales[lang] and Locales[lang][str] or str
    if ... then
        return string.format(text, ...)
    end
    return text
end
Locale = _U

local frameworkAliases = {
    ['qbox'] = 'qbox',
    ['qbx'] = 'qbox',
    ['qbx_core'] = 'qbox',
    ['qb'] = 'qb',
    ['qbcore'] = 'qb',
    ['qb-core'] = 'qb',
    ['esx'] = 'esx',
    ['es_extended'] = 'esx'
}

local bankingAliases = {
    ['okok'] = 'okokBanking',
    ['okokbanking'] = 'okokBanking',
    ['okokBanking'] = 'okokBanking',
    ['qb'] = 'qb-banking',
    ['qbbanking'] = 'qb-banking',
    ['qb-banking'] = 'qb-banking',
    ['qb-management'] = 'qb-banking',
    ['ox'] = 'ox_banking',
    ['oxbanking'] = 'ox_banking',
    ['ox_banking'] = 'ox_banking',
    ['renewed'] = 'renewed',
    ['renewed-banking'] = 'renewed',
    ['Renewed-Banking'] = 'renewed'
}

function Bridge.GetFramework()
    local rawName = Config and Config.Framework or 'qb'
    local cleanName = string.lower(tostring(rawName))
    local mapped = frameworkAliases[cleanName] or cleanName
    local fw = Bridge.Framework[mapped]

    if not fw then
        print(string.format('^1[G6-bossmenu] Framework "%s" not found! Fallback to qb.^7', tostring(rawName)))
        return Bridge.Framework['qb']
    end
    return fw
end

function Bridge.GetBanking()
    local rawName = Config and Config.Banking or 'qb-banking'
    local cleanName = tostring(rawName)
    local mapped = bankingAliases[cleanName] or bankingAliases[string.lower(cleanName)] or cleanName
    local b = Bridge.Banking[mapped]

    if not b then
        print(string.format('^1[G6-bossmenu] Banking "%s" not found! Fallback to qb-banking.^7', tostring(rawName)))
        return Bridge.Banking['qb-banking']
    end
    return b
end

function Bridge.GetTextUI()
    local tName = Config and Config.TextUI or 'ox_lib'
    local cleanName = string.lower(tostring(tName))
    if cleanName == 'oxlib' then cleanName = 'ox_lib' end
    if cleanName == 'qbcore' then cleanName = 'qb-core' end
    if cleanName == 'esx' then cleanName = 'esx_textui' end
    return Bridge.TextUI[cleanName] or Bridge.TextUI['ox_lib']
end

function Bridge.GetTarget()
    local targetName = Config and Config.Target or 'ox_target'
    local cleanName = string.lower(tostring(targetName))
    if cleanName == 'oxtarget' then cleanName = 'ox_target' end
    if cleanName == 'qbtarget' then cleanName = 'qb-target' end
    return Bridge.Target[cleanName]
end

function Bridge.GetNotify()
    local nName = Config and Config.Notify or 'ox_lib'
    local cleanName = string.lower(tostring(nName))
    if cleanName == 'oxlib' then cleanName = 'ox_lib' end
    if cleanName == 'qbcore' then cleanName = 'qb-core' end
    return Bridge.Notify[cleanName] or Bridge.Notify['ox_lib']
end
