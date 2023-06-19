for i,v in pairs(TraitFactory) do 
    for k,w in pairs(v) do
        print(w)
    end
end

--this returns a list of traits like "Axeman=zombie.characters.traits.TraitFactory$Trait@7fd27ae5,"
for k,v in pairs(TraitFactory) do print(v) end

--returns a function, class zombie.characters.traits.TraitFactory$Trait and then one more function
for k,v in pairs(Trait) do print(v) end


for i,v in pairs(TraitFactory) do for k,w in pairs(v) do print(v.Trait) end end







-----------------------------------------------------
--traitcode.lua
-----------------------------------------------------
local previousPrice = 0

local old_setSandboxVars = SandboxOptionsScreen.setSandboxVars
SandboxOptionsScreen.setSandboxVars = function(self)
    old_setSandboxVars(self)
    local trait = TraitFactory.getTrait("Carrier")
    local ccp = MainScreen.instance.charCreationProfession

    --cleanup old trait
    local label = trait:getLabel()
    local olditem = ccp.listboxTrait:removeItem(label)
            or ccp.listboxBadTrait:removeItem(label)
            or ccp.listboxTraitSelected:removeItem(label)

    if olditem then -- readd it
        local newItem
        if trait:getCost() > 0 then
            newItem = ccp.listboxTrait:addItem(label, trait)
        else
            newItem = ccp.listboxBadTrait:addItem(label, trait)
        end
        newItem.tooltip = trait:getDescription()
        ccp.pointToSpend = ccp.pointToSpend + previousPrice

        CharacterCreationMain.sort(ccp.listboxTrait.items)
        CharacterCreationMain.invertSort(ccp.listboxBadTrait.items)
        CharacterCreationMain.sort(ccp.listboxTraitSelected.items)
    end
    previousPrice = trait:getCost()
end

-----------------------------------------------------
--traits.lua
-----------------------------------------------------
--?allow Trait.class to inherit from metatable?
--?or is it the other way around and metatable inherits from Trait.class?
local metatable = __classmetatables[Trait.class].__index

--?old_getCost is another way to call the function metatable.getCost
--local old_getCost = metatable.getCost
metatable.getCost = function(self)
    if self:getType() == "Carrier" then
        return -SandboxVars.ZContagion.CarrierCost
    end
    --return old_getCost(self)
    return metatable.getCost(self)
end

local old_getRightLabel = metatable.getRightLabel
metatable.getRightLabel = function(self)
    if self:getType() == "Carrier" then
        local cost = -SandboxVars.ZContagion.CarrierCost
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