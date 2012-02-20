// sqf

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

// properties & method defines
#define arg(n)      (_this select (n))
#define selfRef     (_this select 0)
#define properties  (selfRef select 0)

#define listBoxLeft  (properties select 0)
#define listBoxRight (properties select 1)
#define table        (properties select 2)
#define callbackGetItemText (properties select 3)
#define callbackGetPicture  (properties select 4)

// Элементы таблицы
#define getItem(r)          (r select 0)
#define getCountLeft(r)     (r select 1)
#define getCountRight(r)    (r select 2)
#define getDifference(r)    (r select 3)
#define getLBLIndex(r)      (r select 4)
#define getLBRIndex(r)      (r select 5)
#define setCountLeft(r,v)   (r set [1,v])
#define setCountRight(r,v)  (r set [2,v])
#define setDifference(r,v)  (r set [3,v])
#define setLBLIndex(r,v)    (r set [4,v])
#define setLBRIndex(r,v)    (r set [5,v])

/*
    Функция funcCreateTwoPaneManager, описание смотри в funcCreateTwoPaneManager.txt
*/

funcCreateTwoPaneManager = {
    private [
        "_draw",
        "_move",
        "_moveToRight",
        "_moveToLeft",
        "_getCurrentSelected",
        "_getCurrentString",
        "_getCurrentNum"
    ];
    _draw = {
        private ["_index", "_table", "_lbIndex"];
        _table = table;
        _index = 0;
        lbClear listBoxLeft;
        lbClear listBoxRight;
        {
            setLBLIndex(_x, -1);
            setLBRIndex(_x, -1);
            if (getCountLeft(_x) != 0) then {
                _lbIndex = lbAdd [listBoxLeft, [getItem(_x), getCountLeft(_x)] call callbackGetItemText];
                lbSetPicture [listBoxLeft, _lbIndex, [getItem(_x), getCountLeft(_x)] call callbackGetPicture];
                lbSetValue [listBoxLeft, _lbIndex, _index];
                setLBLIndex(_x, _lbIndex);
            };
            if (getCountRight(_x) != 0) then {
                _lbIndex = lbAdd [listBoxRight, [getItem(_x), getCountRight(_x)] call callbackGetItemText];
                lbSetPicture [listBoxRight, _lbIndex, [getItem(_x), getCountRight(_x)] call callbackGetPicture];
                lbSetValue [listBoxRight, _lbIndex, _index];
                setLBRIndex(_x, _lbIndex);
            };
            _index = _index + 1;
        } foreach table;
    };

    _move = {
        private ["_curSel", "_number", "_lbActive", "_lbPassive", "_lbPassiveIndex", "_row", "_c1", "_c2"];
        _number = arg(1);
        _lbActive = [listBoxLeft, listBoxRight] select (_number > 0);
        _lbPassive = [listBoxRight, listBoxLeft] select (_number > 0);
        _curSel = lbCurSel _lbActive;
        if (_curSel != -1 && lbSize _lbActive > 0) then {
            _row = table select (lbValue [_lbActive, _curSel]);
            _c1 = getCountLeft(_row) + _number;
            _c2 = getCountRight(_row) - _number;
            if (_c1 >= 0 && _c2 >= 0) then {
                setCountLeft(_row, _c1);
                setCountRight(_row, _c2);
                setDifference(_row, getDifference(_row) + _number);
                manager_draw(selfRef);
                if (lbCurSel _lbActive >= lbSize _lbActive) then {
                    if (_curSel < lbSize _lbActive) then {
                        lbSetCurSel [_lbActive, _curSel];
                    } else {
                        lbSetCurSel [_lbActive, _curSel-1];
                    };
                };
                _lbPassiveIndex = [getLBRIndex(_row), getLBLIndex(_row)] select (_number > 0);
                lbSetCurSel [_lbPassive, _lbPassiveIndex];
            };
        };
    };

    _moveToRight = { manager_move(selfRef, -abs(arg(1))) };
    _moveToLeft  = { manager_move(selfRef, +abs(arg(1))) };

    // аргументы [менеджер, "left" or "right"]
    // возвращет массив [ хранимый_злемент, количество_в_указанной_панели ]
    _getCurrentSelected = {
        private ["_curSel", "_row", "_lb"];
        _lb = [listBoxLeft, listBoxRight] select (arg(1) != "left");
        _curSel = lbCurSel _lb;
        if (_curSel >= 0 && lbSize _lb > 0) then {
            _row = table select (lbValue [_lb, _curSel]);
            [getItem(_row), [getCountLeft(_row), getCountRight(_row)] select (arg(1) != "left")]
        } else {
            []
        }
    };

    _getCurrentString = {
        private "_curSelData";
        _curSelData = manager_getCurrentSelected(selfRef, arg(1));
        if (count _curSelData != 0) then { _curSelData call callbackGetItemText } else { "" }
    };

    _getCurrentNum = {
        private "_curSelData";
        _curSelData = manager_getCurrentSelected(selfRef, arg(1));
        if (count _curSelData != 0) then { _curSelData select 1 } else { 0 }
    };

    _getResult = {
        private ["_result", "_difference"];
        _result = [];
        {
            _difference = getDifference(_x);
            if (_difference != 0) then {
                _result set [count _result, [getItem(_x), _difference]]
            };
        } foreach table;
        _result
    };

    // return object:
    [
        // properties
        _this,
        // methods
        _draw,
        _move,
        _moveToRight,
        _moveToLeft,
        _getCurrentString,
        _getCurrentSelected,
        _getCurrentNum,
        _getResult
    ]
};

funcCreateTwoPaneTable = {
    private ["_list", "_offset", "_value", "_i"];
    _list = [];
    _offset = 1;
    {
        {
            #define __item (_list select _i)
            #define __key (__item select 0)
            #define __value (__item select _offset)
            #define __newKey (_x select 0)
            #define __newValue (_x select 1)
            _i = 0;
            while { __key != __newKey } do { _i = _i + 1 };
            if (_i == count _list) then {
                _item = [__newKey, 0, 0, 0];
                _item set [_offset, __newValue];
                _list set [_i, _item]
            } else {
                __item set [_offset, __value + __newValue];
            };
        } foreach _x;
        _offset = _offset + 1;
    } foreach _this;
    _list
};
