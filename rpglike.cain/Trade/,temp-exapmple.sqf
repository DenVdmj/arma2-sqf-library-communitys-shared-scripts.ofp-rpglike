_manager = [
    funcGetGameItemPrice,
    200, 201,
    [
        ["WEAPON", // ��������� ����
            [["Bizon", 3], ["AK47", 5], ["Binocular", 1]], // � ����� ������
            [["M16", 6], ["HK", 2]] // � ������ ������
        ],
        ["MAGAZINE", // ��������� ����
            [["BizonMag", 30], ["AK47", 62]], // � ����� ������
            [["M16", 54], ["HK", 20], ["HandGrenade", 4], ["SmokeShell", 2]] // � ������ ������
        ],
        ["CAR", // ��������� ����
            [["Uaz", 2], ["Ural", 3]], // � ����� ������
            [["Hammer", 1], ["Truck5t", 4]] // � ������ ������
        ]
    ]
] call funcCreateTradeManager;
