[
    "������ ������",
    {
        //------------------------------------------------------------------------------
        if ([["WeaponHolder"] getVar] call funcIsNil) then {
            _holder = "WeaponHolder" createVehicle getpos _npc;
            _holder setpos getpos _npc;
            ["WeaponHolder", _holder] setVar;
        };
        ["addWeapon",   {(["WeaponHolder"] getVar) addWeaponCargo   [_this, 1]}] setVar;
        ["addMagazine", {(["WeaponHolder"] getVar) addMagazineCargo [_this, 1]}] setVar;
        //------------------------------------------------------------------------------

        ["������ ������? ���� ���� ������ �����, ��� ���������� � ���?",
            [
                ["������ ������", "������ ������"],
                ["������ ����������", "������ ����������"],
                ["�������, �� ���� (��������� ��������)", "[exit]"]
            ]
        ]
    },
    "������ ������",
    {
        ["�������",
            [
                ["Tokarev", "������ ������", true, { "Tokarev" call (["addWeapon"] getVar) }],
                ["Beretta", "������ ������", true, { "Beretta" call (["addWeapon"] getVar) }],
                ["Revolver", "������ ������", true, { "Revolver" call (["addWeapon"] getVar) }],
                ["Kozlice", "������ ������", true, { "Kozlice" call (["addWeapon"] getVar) }],
                ["UZI", "������ ������", true, { "UZI" call (["addWeapon"] getVar) }],
                ["AK47CZ", "������ ������", true, { "AK47CZ" call (["addWeapon"] getVar) }],
                ["������", "������ ������"]
            ]
        ]
    },
    "������ ����������",
    {
        ["�������",
            [
                ["TokarevMag", "������ ����������", true, { "TokarevMag" call (["addMagazine"] getVar) }],
                ["BerettaMag", "������ ����������", true, { "BerettaMag" call (["addMagazine"] getVar) }],
                ["Revolver", "������ ����������", true, { "Revolver" call (["addMagazine"] getVar) }],
                ["KozliceBall", "������ ����������", true, { "KozliceBall" call (["addMagazine"] getVar) }],
                ["UZIMag", "������ ����������", true, { "UZIMag" call (["addMagazine"] getVar) }],
                ["AK47", "������ ����������", true, { "AK47" call (["addMagazine"] getVar) }],
                ["������", "������ ������"]
            ]
        ]
    }
]