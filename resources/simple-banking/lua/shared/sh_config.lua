SimpleBanking = SimpleBanking or {} 
SimpleBanking.Config = SimpleBanking.Config or {}


SimpleBanking.Config["Days_Transaction_History"] = 7 -- How many days should the transaction history go back in the bank?

SimpleBanking.Config["business_ranks"] = { -- what ranks can see the society accounts in the menu, and deposit/withdraw/transfer from them?
    ["owner"] = true,
    ["coowner"] = true,
    ["boss"] = true,
    ["chief"] = true,
    ["emt supervisor"] = true,
    ["manager"] = true,
    ["server owner"] = true, -- Add additionals like I have here, don't forget the comma. Job rank must be lowercase!
}


SimpleBanking.Config["business_ranks_overrides"] = {
    ["cardealer"] = { -- If you want a certain company to use custom job ranks, add them like below. otherwise, it defaults back to business_ranks
        ["boss"] = true,
        ["coowner"] = true,
        ["manager"] = true,
    },
}
SimpleBanking.Config["business_ranks_overrides"] = {
    ["police"] = { -- If you want a certain company to use custom job ranks, add them like below. otherwise, it defaults back to business_ranks
        ["chief"] = true,
         ["coowner"] = true,
        ["manager"] = true,
    },
}
SimpleBanking.Config["business_ranks_overrides"] = {
    ["crips"] = { -- If you want a certain company to use custom job ranks, add them like below. otherwise, it defaults back to business_ranks
        ["server owner"] = true,
         ["coowner"] = true,
        ["manager"] = true,
    },
}
SimpleBanking.Config["business_ranks_overrides"] = {
    ["mechanic"] = { -- If you want a certain company to use custom job ranks, add them like below. otherwise, it defaults back to business_ranks
        ["boss"] = true,
         ["coowner"] = true,
        ["manager"] = true,
    },
}
SimpleBanking.Config["business_ranks_overrides"] = {
    ["burgershot"] = { -- If you want a certain company to use custom job ranks, add them like below. otherwise, it defaults back to business_ranks
        ["boss"] = true,
        ["chief_doctor"] = true,
        ["manager"] = true,
    },
}

