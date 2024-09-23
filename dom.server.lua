function randomItemWithWeight(choices)
    local totalWeight = 0
    for _, choice in pairs(choices) do
        totalWeight = totalWeight + choice.weight
    end

    local randomWeight = math.random() * totalWeight
    local cumulativeWeight = 0

    for i, choice in pairs(choices) do
        cumulativeWeight = cumulativeWeight + choice.weight
        if randomWeight < cumulativeWeight then
            return i, choice
        end
    end
end

-- higher numbers are the rarest ones
-- you will want to use rarity 2-10
function randomRare(max, rarity)
    local rand = math.random()
    return math.floor((1 - rand) ^ (rarity or 2) * max) + 1
end

function setRandomGiftForAccount(account)
	local hability, score = randomItemWithWeight(HABILITIES), 25 + randomRare(75, 3)

	setAccountData(account, "engine.hability", hability)
	setAccountData(account, "engine.hability.score", score)

	print(space(getAccountName(account), "is now a", hability, score))
end

addEventHandler("onAccountCreate", root, setRandomGiftForAccount)

addCommandHandler("dom", function(player)
	local account = getPlayerAccount(player)
	setRandomGiftForAccount(account)
end)