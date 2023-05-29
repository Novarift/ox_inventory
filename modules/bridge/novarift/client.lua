local onLogout, Weapon = ...
local Inventory = require 'modules.inventory.client'
local Novarift = exports['novarift-core']:GetCoreObject()

local function updateCharacterCondition()

    local character = Novarift.Player.GetCharacter()
    if (not character) then return end

    PlayerData.dead = character.condition ~= 'alive'
    OnPlayerData('dead', PlayerData.dead)

end

RegisterNetEvent('novarift-core:client:player:unloaded', onLogout)

RegisterNetEvent('novarift-core:client:player:groups:updated', function (groups)
    PlayerData.groups = groups
    OnPlayerData('groups', groups)
end)

RegisterNetEvent('novarift-core:client:player:loaded', updateCharacterCondition)
RegisterNetEvent('novarift-core:client:player:condition:updated', updateCharacterCondition)

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
