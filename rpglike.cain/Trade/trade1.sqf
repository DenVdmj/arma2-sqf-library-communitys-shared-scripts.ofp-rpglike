
// hint format ["%1", _this];

_seller = _this select 0;
_player = _this select 1;

[
    [
        ["W", (weapons _player - ["rls_Inventory"]) call funcList2Collection, (weapons _seller - ["rls_Inventory"]) call funcList2Collection],
        ["M", magazines _player call funcList2Collection, magazines _seller call funcList2Collection]
    ]
] call funcOpenTradeDialog;

