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

local metatable = __classmetatables[Trait.class].__index

local old_getCost = metatable.getCost
---@param self Trait
metatable.getCost = function(self)
    if self:getType() == "house_fire_survivor" then
        return -SandboxVars.MoreTraits.HFSTraitCost
    end
    return old_getCost(self)
end

local old_getRightLabel = metatable.getRightLabel
---@param self Trait
metatable.getRightLabel = function(self)
    if self:getType() == "house_fire_survivor" then
        local cost = -SandboxVars.MoreTraits.HFSTraitCost
        local label = "+"
        if cost > 0 then
            label = "-"
        elseif cost == 0 then
            label = ""
        end

        if cost < 0 then cost = cost * -1 end

        return label..cost
    end
    return old_getRightLabel(self)
end


