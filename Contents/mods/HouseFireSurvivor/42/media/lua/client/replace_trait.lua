--[[This program is borrowed with permission from Albion's mod Zombie Contagion 
    which can be found here. https://steamcommunity.com/sharedfiles/filedetails/?id=2868937948

    This program is free software: you can redistribute it and/or modify
    it under the terms of Version 3 of the GNU Affero General Public License as published
    by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

    For any questions, contact Albion through steam or on Discord - albion#0123
]]

local previousPrice = 0

-- TODO: it shows in the wrong list if you change the price and then go back to a preset difficulty (who cares, low prio)
-- TODO: we don't really need to remove the trait from the selection if it now grants more points
-- also consider not removing it the player can still afford it in general
local function updateTraitPrice()
    local trait = TraitFactory.getTrait("house_fire_survivor")
    local newCost = trait:getCost()

    --only remove traits if the price has actually changed
    if previousPrice == newCost then return end

    local ccp = MainScreen.instance.charCreationProfession
    local label = trait:getLabel()

    --determine if trait is purchased before clearing ccp.listboxTraitSelected
    local traitIsPurchased = false
    local selectedItems = ccp.listboxTraitSelected.items
    for i=1, #selectedItems do
        if selectedItems[i].item == trait then
            traitIsPurchased = true
            break
        end
    end

    local oldItem = ccp.listboxTrait:removeItem(label)
            or ccp.listboxBadTrait:removeItem(label)
            or traitIsPurchased and ccp.listboxTraitSelected:removeItem(label)
    if not oldItem then return end

    -- readd it
    local newItem
    if newCost > 0 then
        newItem = ccp.listboxTrait:addItem(label, trait)
    else
        newItem = ccp.listboxBadTrait:addItem(label, trait)
    end
    newItem.tooltip = trait:getDescription()

    --adjust available points only if traitIsPurchased
    if traitIsPurchased then
        ccp.pointToSpend = ccp.pointToSpend + previousPrice
    end

    CharacterCreationMain.sort(ccp.listboxTrait.items)
    CharacterCreationMain.invertSort(ccp.listboxBadTrait.items)
    CharacterCreationMain.sort(ccp.listboxTraitSelected.items)
    previousPrice = newCost
end

local old_setSandboxVars = SandboxOptionsScreen.setSandboxVars
---@param self SandboxOptionsScreen
SandboxOptionsScreen.setSandboxVars = function(self)
    old_setSandboxVars(self)
    updateTraitPrice()
end

Events.OnConnected.Add(updateTraitPrice)


