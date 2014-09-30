_manager = [
    funcGetGameItemPrice,
    200, 201,
    [
        ["WEAPON", // категория вещи
            [["Bizon", 3], ["AK47", 5], ["Binocular", 1]], // в левой панели
            [["M16", 6], ["HK", 2]] // в правой панели
        ],
        ["MAGAZINE", // категория вещи
            [["BizonMag", 30], ["AK47", 62]], // в левой панели
            [["M16", 54], ["HK", 20], ["HandGrenade", 4], ["SmokeShell", 2]] // в правой панели
        ],
        ["CAR", // категория вещи
            [["Uaz", 2], ["Ural", 3]], // в левой панели
            [["Hammer", 1], ["Truck5t", 4]] // в правой панели
        ]
    ]
] call funcCreateTradeManager;
