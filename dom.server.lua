function random_item_with_weight(choices)
    local totalWeight = 0
    for _, choice in pairs(choices) do
        totalWeight = totalWeight + choice.weight
    end

    local randomWeight = math.random() * totalWeight
    local cumulativeWeight = 0

    for item, choice in pairs(choices) do
        cumulativeWeight = cumulativeWeight + choice.weight
        if randomWeight < cumulativeWeight then
            return item, choice
        end
    end
end

local function generate_hability()
	return random_item_with_weight(HABILITIES), 50 + math.random(50)
end

function reroll_account_hability(account)
	local hability, score = generate_hability()
	setAccountData(account, "engine.hability", hability)
	setAccountData(account, "engine.hability.score", score)

	print(space(getAccountName(account), "is now a", hability, score))
end

addEventHandler("onAccountCreate", root, reroll_account_hability)

addCommandHandler("dom", function(player)
	local account = getPlayerAccount(player)
	reroll_account_hability(account)
end)