
#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)

nil call {
    // добавить всем персонажам в меню, на время отладки
    [
        "STR:UA:TradeWith", "STR:UA:Trade",
        { _this call preprocessFile "Trade\trade1.sqf" }, []
    ] call funcAddInteractionMenuItem;
};

nil call {
    // добавить игроку предметы, на время отладки
    { 
        player addMagazine _x 
    } foreach [
        "rls_Map", 
        "rls_WalkieTalkie", 
        "rls_Clock", 
        "rls_Compass", 
        "rls_Gps", 
        "rls_Blocknote"
    ];
};

call {
    // раскидать вокруг игрока предметы, на время отладки
    [
        //"rls_WalkieTalkie"
        //,"rls_Clock"
        //,"rls_Compass"
        //,"rls_Gps"
        //,"rls_Blocknote"
        //,"rls_Notebook"
        //,"rls_Book"
        //,"rls_Radio"
        //,"rls_Radio2"
        //,"rls_MineTM62m"
        //,"rls_Stonny"
        //,"rls_Cartridge"
         "rls_DeadHead"
        ,"rls_BottleSeagram"
        ,"rls_BottleWhiskey"
        ,"rls_BottleNapoleon"
        ,"rls_BottleMartini"
        ,"rls_BottleJack"
        ,"rls_BottleBarbero"
        ,"rls_BottleBaileys"
    ] call {
        private ["_dir", "_pos", "_px", "_py", "_dx", "_dy", "_holder"];
        _dir = getdir player;
        _pos = getpos player;
        _px = x(_pos);
        _py = y(_pos);
        {
            _dx = sin(_dir) * 2;
            _dy = cos(_dir) * 2;
            _holder = "WeaponHolder" createVehicle [_px + _dx, _py + _dy];
            _holder addMagazineCargo [_x, 1];
            _holder setpos [_px + _dx, _py + _dy];
            _dir = _dir + 35;
        } foreach _this;
    };
};
