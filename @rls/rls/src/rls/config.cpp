
class CfgPatches {
    class rls_things {
        units[] = {};
        weapons[] = {rls_Inventory};
        requiredVersion = 1.75;
        requiredAddons[] = {"BIS_Resistance"};
    };
};

class CfgAmmo {
    class default {};
};

class CfgWeapons {
    class Throw {};
    class rls_Inventory: Throw {
        count = 1;
        ammo = "default";
        displayName = "$STR:RLS:DN:INVENTORY";
        displayNameMagazine = "$STR:RLS:DM:THINGS";
        shortNameMagazine = "$STR:RLS:DM:THINGS";
        magazineType = 0;
        canDrop = 0;
        magazines[] = {
            "rls_Map",
            "rls_WalkieTalkie",
            "rls_Clock",
            "rls_Compass",
            "rls_Gps",
            "rls_Blocknote",
            "rls_Notebook",
            "rls_Book",
            "rls_Radio",
            "rls_Radio2",
            "rls_MineTM62m",
            "rls_Stonny",
            "rls_Cartridge",
            "rls_DeadHead",
            "rls_BottleSeagram",
            "rls_BottleWhiskey",
            "rls_BottleNapoleon",
            "rls_BottleMartini",
            "rls_BottleJack",
            "rls_BottleBarbero",
            "rls_BottleBaileys"
        };
    };

    class rls_ThingBase: rls_Inventory {
        canDrop = 1;
        scopeWeapon = 0;
        scopeMagazine = 1;
    };

    #define THING(classname,model) \
    class rls_##classname: rls_ThingBase {\
        modelMagazine = model;\
        displayNameMagazine = $STR:@M:ACT:rls_##classname;\
        shortNameMagazine = $STR:@M:ACT:rls_##classname;\
    };

    THING(WalkieTalkie,vysilacka)
    THING(Clock,kosei)
    THING(Compass,kompas)
    THING(Gps,gps)
    THING(Blocknote,blok_selmis2)
    THING(Notebook,notebook)
    THING(Book,kniha6)
    THING(Radio,radio)
    THING(Radio2,\O\misc\radio2)
    THING(MineTM62m,tm_62m)
    THING(Stonny,sutr3)
    THING(Cartridge,nabojnice)
    // Мертвая голова Эдди Тиффани )) Кармен будет рад ))
    THING(DeadHead,hlavaW)
    // Спиртное
    THING(BottleSeagram,seagram)
    THING(BottleWhiskey,whiskey)
    THING(BottleNapoleon,napoleon)
    THING(BottleMartini,martini)
    THING(BottleJack,kentucky jack)
    THING(BottleBarbero,barbero)
    THING(BottleBaileys,baileys)

    THING(Map,\misc\mag_univ.p3d)
    THING(Vibrator,\misc\mag_univ.p3d)
    THING(Dildo,\misc\mag_univ.p3d)
    THING(LatexBandaging,\misc\mag_univ.p3d)

};
