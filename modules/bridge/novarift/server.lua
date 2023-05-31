local playerDropped = ...
local Inventory, Items
local Novarift

CreateThread(function ()
    Inventory = require 'modules.inventory.server'
    Items = require 'modules.items.server'
end)

local function mapOrganizationsIntoGroups(organizations)

    local groups = {}

    for code, info in pairs(organizations or {}) do
        groups[code] = info.grade
    end

    return groups

end

local function loadPlayerInventory(source)

    local player = Novarift.Player.Get(source)
    if (not player) then return end

    local character = player.Character
    if (not character) then return end

    character.source = player.source
    character.sex = character.gender
    character.groups = mapOrganizationsIntoGroups(character.organizations)
    character.dateofbirth = character.birth_date
    character.identifier = character.citizen_id

    server.setPlayerInventory(character, character.inventory)

end

SetTimeout(500, function ()

    Novarift = exports['novarift-core']:GetCoreObject()
    
    server.GetPlayerFromId = function (source)
        local player = Novarift.Player.Get(source)
        return player and player.Character
    end

    for _, player in pairs(Novarift.Players.Get()) do
        loadPlayerInventory(player.source)
    end

end)

function server.setPlayerData(character)
    return {
        source = character.source,
        name = character.name,
        sex = character.gender,
        groups = mapOrganizationsIntoGroups(character.organizations),
        dateofbirth = character.birth_date,
    }
end

function server.hasLicense(inv, license)
    
    local character = server.GetPlayerFromId(inv.id)
    if (not character) then return end

    -- Check for license

    return false

end

function server.buyLicense(inv, license)
    
    if (server.hasLicense(inv, license)) then return false, 'already_have' end
    -- if (Inventory.GetItem(inv, 'money', false, true) < license.price) then return false, 'can_not_afford' end

    -- Inventory.RemoveItem(inv, 'money', license.price)
    -- Create Licenses

    return true, 'have_purchased'

end

AddEventHandler('novarift-core:server:player:loaded', loadPlayerInventory)
AddEventHandler('novarift-core:server:player:unloaded', playerDropped)

AddEventHandler('novarift-core:server:player:organizations:updated', function (source, organizations)

    local inventory = Inventory(source)
    if (not inventory) then return end

    inventory.player.groups = mapOrganizationsIntoGroups(organizations)

end)
