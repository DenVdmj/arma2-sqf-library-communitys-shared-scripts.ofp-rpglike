[
    "купить оружие",
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

        ["Хочешь оружие? Тебе сами стволы нужны, или боеприпасы к ним?",
            [
                ["Купить стволы", "купить стволы"],
                ["Купить боеприпасы", "купить боеприпасы"],
                ["Спасибо, не надо (закончить разговор)", "[exit]"]
            ]
        ]
    },
    "купить стволы",
    {
        ["Выбирай",
            [
                ["Tokarev", "купить стволы", true, { "Tokarev" call (["addWeapon"] getVar) }],
                ["Beretta", "купить стволы", true, { "Beretta" call (["addWeapon"] getVar) }],
                ["Revolver", "купить стволы", true, { "Revolver" call (["addWeapon"] getVar) }],
                ["Kozlice", "купить стволы", true, { "Kozlice" call (["addWeapon"] getVar) }],
                ["UZI", "купить стволы", true, { "UZI" call (["addWeapon"] getVar) }],
                ["AK47CZ", "купить стволы", true, { "AK47CZ" call (["addWeapon"] getVar) }],
                ["Готово", "купить оружие"]
            ]
        ]
    },
    "купить боеприпасы",
    {
        ["Выбирай",
            [
                ["TokarevMag", "купить боеприпасы", true, { "TokarevMag" call (["addMagazine"] getVar) }],
                ["BerettaMag", "купить боеприпасы", true, { "BerettaMag" call (["addMagazine"] getVar) }],
                ["Revolver", "купить боеприпасы", true, { "Revolver" call (["addMagazine"] getVar) }],
                ["KozliceBall", "купить боеприпасы", true, { "KozliceBall" call (["addMagazine"] getVar) }],
                ["UZIMag", "купить боеприпасы", true, { "UZIMag" call (["addMagazine"] getVar) }],
                ["AK47", "купить боеприпасы", true, { "AK47" call (["addMagazine"] getVar) }],
                ["Готово", "купить оружие"]
            ]
        ]
    }
]