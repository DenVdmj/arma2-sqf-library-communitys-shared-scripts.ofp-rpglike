// sqf

#define STR_TRADE_ACCOUNT_FORMAT "STR:TRADE:ACCOUNT_FORMAT"
#define STR_TRADE_INFO_FORMAT "STR:TRADE:INFO_FORMAT"
#define STR_TRADE_ROW_FORMAT "STR:TRADE:ROW_FORMAT"

#define arg(i) (_this select (i))
#define ifExistArg(i) if (count _this > (i))
#define argIfExist(i) ifExistArg(i) then { arg(i) }
#define argOr(i,v) (argIfExist(i) else {v})

// export macro
#define manager_draw(o)                 ([(o)]call((o)select 1))
#define manager_move(o,n)               ([(o),(n)]call((o)select 2))
#define manager_moveToRight(o,n)        ([(o),(n)]call((o)select 3))
#define manager_moveToLeft(o,n)         ([(o),(n)]call((o)select 4))
#define manager_getCurrentString(o,n)   ([(o),(n)]call((o)select 5))
#define manager_getCurrentSelected(o,n) ([(o),(n)]call((o)select 6))
#define manager_getCurrentNum(o,n)      ([(o),(n)]call((o)select 7))
#define manager_getResult(o)            ([(o)]call((o)select 8))
// end export

#define __leftListBox 200
#define __rightListBox 201
#define __moveToRightButton 202
#define __moveToLeftButton 203
#define __buttonOk 301
#define __buttonCancel 302

#define __category(item) ((item)select 0)
#define __name(item)     ((item)select 1)
#define __price(item)    ((item)select 2)


funcOpenTradeDialog = {
    [
        _this,
        [
            "_manager",
            "_seller",
            "_buyer",
            "_afterAction",
            "_afterActionArgs",
            "_converTwoPaneTable",
            "_funcRowFormat",
            "_funcInfoFormat",
            "_funcItemToString",
            "_funcGetPicture",
            "_getTotalNumber",
            "_initTransferFunction",
            "_transfer",
            "_removeMagazine",
            "_removeWeapon",
            "_removeVehicle",
            "_addMagazine",
            "_addWeapon",
            "_addVehicle"
        ],
        [ // Ctrl Event Handlers
            [__leftListBox, {
                ctrlSetText [104,""];
                ctrlSetText [103, manager_getCurrentSelected(_manager, "left") call _funcInfoFormat];
            }],
            [__rightListBox, {
                ctrlSetText [103,""];
                ctrlSetText [104, manager_getCurrentSelected(_manager, "right") call _funcInfoFormat];
            }],
            [__moveToRightButton, {
                manager_moveToRight(_manager,1);
                ctrlSetText [104, ""];
                ctrlSetText [103, manager_getCurrentSelected(_manager, "left") call _funcInfoFormat];
                ctrlSetText [101, format [localize STR_TRADE_ACCOUNT_FORMAT, name player, playerMoney, (manager_getResult(_manager) call _getTotalNumber)]];
                //hint format ["%1", manager_getResult(_manager)];

            }],
            [__moveToLeftButton, {
                manager_moveToLeft(_manager,1);
                ctrlSetText [103,""];
                ctrlSetText [104, manager_getCurrentSelected(_manager, "right") call _funcInfoFormat];
                ctrlSetText [101, format [localize STR_TRADE_ACCOUNT_FORMAT, name player, playerMoney, (manager_getResult(_manager) call _getTotalNumber)]];
                //hint format ["%1", manager_getResult(_manager)];
            }],
            [__buttonOk, {
                private "_result";
                _result = manager_getResult(_manager);
                _result call _transfer;
                [_afterActionArgs] call _afterAction;
                closeDialog 1;
            }],
            [__buttonCancel, {
                closeDialog 1;
            }]
        ],
        { // анонимный конструктор
            _DLGRSC = "DlgTradeMenu"; // имя класса ресурса диалога
            _seller = arg(1);
            _buyer = arg(2);
            _constructor = {
                private ["_leftWeapons", "_leftMagazines", "_rightWeapons", "_rightMagazines"];
                // повесить часы на 102 контрол
                [localize "STR:TIME", {ctrlSetText [102, _this]; dialog}] exec "lib\processes\watch.sqs";
                ctrlSetText [101, format [localize STR_TRADE_ACCOUNT_FORMAT, name player, playerMoney, 0]];

                argOr(3,[]) call _initTransferFunction;

                _data = arg(0);

                _manager = [
                    __leftListBox, __rightListBox,
                    _data call _converTwoPaneTable,
                    _funcRowFormat,
                    _funcGetPicture
                ] call funcCreateTwoPaneManager;

                manager_draw(_manager);
            };

            _destructor = {

            };

            _converTwoPaneTable = {
                private ["_category", "_twoPaneTable", "_row", "_item", "_price"];
                _twoPaneTable = [];
                {
                    #define __leftCollection  (_x select 1)
                    #define __rightCollection (_x select 2)
                    _category = _x select 0;
                    _row = [__leftCollection, __rightCollection] call funcCreateTwoPaneTable;
                    {
                        _item = _x select 0;
                        _price = [_category, _item] call funcGetGameItemPrice;
                        // элемент будет отображен только если есть запись в реестре игровых предметов
                        // добавляем только если есть запись в реестре игровых предметов
                        if (!([_price] call funcIsNil)) then {
                            _x set [0, [_category, _item, _price]];
                            _twoPaneTable set [count _twoPaneTable, _x];
                        };
                    } foreach _row;
                    //_twoPaneTable = _twoPaneTable + _row;
                } foreach _this;
                _twoPaneTable
            };

            _funcRowFormat = {
                [_this, STR_TRADE_ROW_FORMAT] call _funcItemToString
            };

            _funcInfoFormat = {
                [_this, STR_TRADE_INFO_FORMAT] call _funcItemToString
            };

            #define __category(item) (item select 0)
            #define __name(item)     (item select 1)
            #define __price(item)    (item select 2)

            // простой вывод для отладки
            // _funcItemToString = { format ["%1", _this select 0] };
            _funcItemToString = {
                // аргументы:  [[категория, наименование, цена], количество]
                private ["_item", "_count", "_price"];
                _data = _this select 0;
                if (count _data > 1) then {
                    _format = _this select 1;
                    _item  = _data select 0;
                    _count = _data select 1;
                    format [localize _format,
                        // название товара, количество, цена за штуку, общая цена
                        localize format ["STR:@%1:%2",
                        __category(_item),
                        __name(_item)],
                        _count,
                        __price(_item),
                        __price(_item) * _count
                    ]
                } else {
                    ""
                }
            };

            _funcGetPicture = {
                private "_item";
                if (count _this > 0) then {
                    _item = _this select 0;
                    // ["W", "AK47CZ"] call funcGetGameItemIco
                    [__category(_item), __name(_item)] call funcGetGameItemIco
                }
            };

            _getTotalNumber = {
                private ["_count", "_price", "_totalNumber"];
                _totalNumber = 0;
                {
                    _count = _x select 1;
                    _price = _x select 0 select 2;
                    _totalNumber = _totalNumber - (_price * _count);
                } foreach _this;
                _totalNumber
            };

            _initTransferFunction = {
                private ["_rm", "_rw", "_rv", "_am", "_aw", "_av"];
                _rm = { _unit removeMagazine _name };
                _am = {
                    private ["_count", "_getCount"];
                    _getCount = {
                        {_x == _name} count magazines _unit
                    };
                    _count = call _getCount;
                    _unit addMagazine _name;
                    if (call _getCount == _count) then {
                        _holder addMagazineCargo [_name, 1];
                    };
                };
                _rw = { _unit removeWeapon _name };
                _aw = {
                    private ["_count", "_getCount"];
                    _getCount = {
                        {_x == _name} count weapons _unit
                    };
                    _count = call _getCount;
                    _unit addWeapon _name;
                    if (call _getCount == _count) then {
                        _holder addWeaponCargo [_name, 1];
                    };
                };
                _rv = {};
                _av = {};
                _removeMagazine = argOr(0,_rm);
                _removeWeapon = argOr(1,_rw);
                _removeVehicle = argOr(2,_rv);
                _addMagazine = argOr(3,_am);
                _addWeapon = argOr(4,_aw);
                _addVehicle = argOr(5,_av);
            };
            _transfer = {
                private ["_result", "_holder", "_foreach", "_money"];
                _result = _this;
                _holder = "WeaponHolder" createVehicle getpos _buyer;
                _holder setpos getpos _buyer;
                _foreach = {
                    private ["_record", "_category", "_count", "_name", "_price", "_counter"];
                    {
                        _record = _x select 0;
                        _category = _record select 0;
                        _count = _x select 1;
                        _name = _record select 1;
                        _price = _record select 2;
                        _counter = abs(_count);
                        while {_counter > 0} do { _counter = _counter-1; call _this; };
                    } foreach _result;
                };
                _money = playerMoney + (_result call _getTotalNumber);
                if (_money >= 0) then {
                    playerMoney = _money;
                    {
                        if (_category == "M") then {
                            if (_count < 0) then { _unit = _buyer; call _removeMagazine; };
                            if (_count > 0) then { _unit = _seller; call _removeMagazine; };
                        };
                        if (_category == "W") then {
                            if (_count < 0) then { _unit = _buyer; call _removeWeapon; };
                            if (_count > 0) then { _unit = _seller; call _removeWeapon; };
                        };
                    } call _foreach;
                    {
                        if (_category == "M") then {
                            if (_count < 0) then { _unit = _seller; call _addMagazine; };
                            if (_count > 0) then { _unit = _buyer; call _addMagazine; };
                        };
                        if (_category == "W") then {
                            if (_count < 0) then { _unit = _seller; call _addWeapon; };
                            if (_count > 0) then { _unit = _buyer; call _addWeapon; };
                        };
                        if (_count < 0) then {
                            //player sideChat "delete excess ammo";
                            deleteVehicle _holder;
                        };
                    } call _foreach;
                } else {
                    hint "У вас нехватает денег";
                };
            };
        }
    ] call funcCreateDialog;
};
