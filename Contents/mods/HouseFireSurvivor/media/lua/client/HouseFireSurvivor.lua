local function initHouseFireSurvivorTrait()
    local trait_cost
    if SandboxVars.MoreTraits.HFSTraitCost then
        trait_cost = SandboxVars.MoreTraits.HFSTraitCost * -1
    else
        trait_cost = -18
    end	
    TraitFactory.addTrait("house_fire_survivor", getText("UI_trait_house_fire_survivor"), trait_cost, getText("UI_trait_house_fire_survivor_desc"), false, false);
end
local function applyHouseFireSurvivorBurns(_player)
    local player = _player
    local damage = 20;
    local bandage_strength = 5
    --body part index starts at 0 so we have to subtract one from the list size
    local total_body_parts = player:getBodyDamage():getBodyParts():size() - 1
    if player:HasTrait("house_fire_survivor") then
        for i = 0, total_body_parts , 1 do
            local body_part = player:getBodyDamage():getBodyParts():get(i)
            body_part:setBurned()
            body_part:setBurnTime(ZombRand(10, 100) + damage);
            body_part:setNeedBurnWash(false)
            body_part:setBandaged(true, ZombRand(1, 10) + bandage_strength, true, "Base.AlcoholBandage")
        end
    end
end

Events.OnGameBoot.Add(initHouseFireSurvivorTrait);
Events.OnNewGame.Add(applyHouseFireSurvivorBurns);


