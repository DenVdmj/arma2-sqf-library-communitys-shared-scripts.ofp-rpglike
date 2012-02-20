// добавить всем персонажам в меню, не время отладки
[
    "STR:UA:TradeWith", "STR:UA:Trade",
    { _this call preprocessFile "Trade\trade1.sqf" }, []
] call funcAddInteractionMenuItem;
