local onLogout, Weapon = ...
local Inventory = require 'modules.inventory.client'
local Novarift = exports['novarift-core']:GetCoreObject()

local function updateCharacterCondition()

    local character = Novarift.Player.GetCharacter()
    if (not character) then return end

    PlayerData.dead = character.condition ~= 'alive'
    OnPlayerData('dead', PlayerData.dead)

end

local function updateCharacterGroups()

    local character = Novarift.Player.GetCharacter()
    if (not character) then return end

    local organizations = character.organizations
    local groups = {}

    for code, info in pairs(organizations or {}) do
        groups[code] = info.grade
    end

    PlayerData.groups = groups
    OnPlayerData('groups', groups)

end

local function loadPlayer()
    updateCharacterCondition()
    updateCharacterGroups()
end

SetTimeout(500, loadPlayer)


RegisterNetEvent('novarift-core:client:player:organizations:updated', updateCharacterGroups)
RegisterNetEvent('novarift-core:client:player:condition:updated', updateCharacterCondition)
RegisterNetEvent('novarift-core:client:player:loaded', loadPlayer)
RegisterNetEvent('novarift-core:client:player:unloaded', onLogout)

function client.setPlayerStatus(values)

    local event

    for name, value in pairs(values) do

		-- compatibility for ESX style values
		if value > 100 or value < -100 then
			value = value * 0.0001
		end

        event = value > 0 and 'add' or 'subtract'

        TriggerServerEvent(('novarift-core:server:player:needs:%s'):format(event), name, math.abs(value))

    end

end
