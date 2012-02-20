//
// call preprocessFile "lib\shared.sqf"

//
// Arguments macro
//

#define arg(x)            (_this select(x))
#define argIf(x)          if(count _this>(x))
#define argIfType(x,t)    if(argIf(x)then{(arg(x)call funcGetVarType)==(t)}else{false})
#define argSafe(x)        argIf(x)then{arg(x)}
#define argSafeType(x,t)  argIfType(x,t)then{arg(x)}
#define argOr(x,v)        (argSafe(x)else{v})

//
// Position macro
//

#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)
#define w(a) ((a) select 2)
#define h(a) ((a) select 3)


/*
    funcList2Collection
    example:
        ["qwe", "qwe", "asd", "qwe", "fre", "qwe", "asd"] call funcList2Collection
    returns:
        [["qwe", 4], ["asd", 2], ["fre", 1]]
*/

funcList2Collection = {
    private ["_col", "_rem"];
    _col = [];
    while { count _this != 0 } do {
        _rem = _this - [arg(0)];
        _col set [
            count _col,
            [arg(0), count _this - count _rem]
        ];
        _this = _rem;
    };
    _col
};

/*
    funcCanonizeCollection
    example:
        (
            (magazines soldier1 call funcList2Collection) +
            (magazines soldier2 call funcList2Collection) +
            (magazines soldier3 call funcList2Collection) +
            (magazines soldier4 call funcList2Collection) +
            (magazines soldier5 call funcList2Collection)
        ) call funcCanonizeCollection
    returns:
        [
            ["AK47",16],
            ["HandGrenade",6],
            ["GrenadeLauncher",3],
            ["9K32Launcher",1],
            ["RPGLauncher",3],
            ["KozliceShell",5],
            ["KozliceBall",5]
        ]
*/

funcCanonizeCollection = {
     private ["_col", "_i"];
     _col = [];
     {
         #define __pair (_col select _i)
         #define __key (__pair select 0)
         #define __value (__pair select 1)
         #define __newKey (_x select 0)
         #define __newValue (_x select 1)
         _i = 0;
         while { __key != __newKey } do { _i = _i + 1 };
         if (_i == count _col) then {
             _col set [_i, _x]
         } else {
             __pair set [1, __value + __newValue]
         };
    } foreach _this;
    _col
};

/*
    funcUnduplicatedArray
    Deletes duplicates from array
    example:
        ["qwe", "qwe", "asd", "qwe", "fre", "qwe", "asd"] call funcUnduplicatedArray
    returns:
        ["fre","asd","qwe"]
*/

funcUnduplicatedArray = {
    private ["_e", "_i"];
    _i = 0;
    while { count _this != _i } do {
        _e = _this select _i;
        _this = [_e] + ( _this - [_e] );
        _i = _i + 1;
    };
    _this
};

/*
    funcGetDistance
    Returns distance between two 2d-point
    example:
        [getpos player, [0,0,0]] call funcGetDistance
    returns:
        5868.99
*/

funcGetDistance = {
    private ["_a", "_b"];
    _a = arg(0);
    _b = arg(1);
    sqrt(((_a select 0) - (_b select 0))^2 + ((_a select 1) - (_b select 1))^2)
};

/*
    funcIsInCircle
    Checks an belonging of a point to a circle
    usage:
        [point_position, circle_position, circle_radius] call funcIsInCircle
    returns true if the point inside
*/

funcIsInCircle = {
    #define __deltaX ((_ppos select 0) - (_cpos select 0))
    #define __deltaY ((_ppos select 1) - (_cpos select 1))
    #define __radius (arg(2))
    private  ["_ppos", "_cpos"];
    _ppos = arg(0);
    _cpos = arg(1);
    (__radius ^ 2) > (__deltaX ^ 2 + __deltaY ^ 2)
};

/*
    funcNearestFromList
    Select from the list nearest object to given position. On failure, objNull is returned.
    usage:
        [position, objects list, max distance (optional)] call funcNearestFromList
    example:
        [getpos player, units player - [player]] call funcNearestFromList
        [getpos player, list trigName, 200] call funcNearestFromList

*/

funcNearestFromList = {
    private ["_nearest", "_mindistq", "_distq", "_pos", "_px", "_py"];
    _mindistq = argIf(2) then { arg(2) ^ 2 } else { 1e+10 };
    _nearest = objNull;
    _px = x(arg(0));
    _py = y(arg(0));
    {
        _pos = getpos _x;
        _distq = (_px - x(_pos)) ^ 2 + (_py - y(_pos)) ^ 2;
        if( _mindistq > _distq ) then {
            _mindistq = _distq;
            _nearest = _x
        }
    } foreach arg(1);
    _nearest
};

/*
    funcGetDirToPos
    usage:
        [fromPosition, toPosition] call funcGetDirToPos
    returns direction
*/

funcGetDirToPos = {
    private ["_p1", "_p2", "_dx", "_dy"];
    _p1 = arg(0);
    _p2 = arg(1);
    _dx = x(_p1) - x(_p2);
    _dy = y(_p1) - y(_p2);
    if ( _dx == 0 && _dy == 0 ) then {
        1e+99 // 1.#INF
    } else {
        (180 + (_dx atan2 _dy)) % 360
    }
};

/*
    funcPos2DRelObj
    usage:
        [object, dist, angle] call funcPos2DRelObj
    returns worldspace position
*/

funcPos2DRelObj = {
    [
        x(getpos arg(0)) + arg(1) * (sin(getdir arg(0) + arg(2))),
        y(getpos arg(0)) + arg(1) * (cos(getdir arg(0) + arg(2)))
    ]
};

private "_emptyDetector";
_emptyDetector = "EmptyDetector" createVehicle [0,0,0];
sideUnknown = side _emptyDetector;
deleteVehicle _emptyDetector;

/*
    funcGetVarType
    usage:
        _anyValue call funcGetVarType
    returns variable type name:
        "array", "bool", "group", "number",
        "object", "side", "string", "unknown"
*/

funcGetVarType = {
    if (_this in [1e+999, -1e+999, 1e+999-1e+999]) then { "number" } else {
        if (!(_this in [_this])) then { "array" } else {
            if (_this in [true, false]) then { "bool" } else {
                if (_this in [east, west, resistance, civilian, friendly, enemy, sideLogic, sideUnknown]) then { "side" } else {
                    if ((("all" countType [_this]) != 0) || (_this in [grpNull, objNull]) || (format["%1", _this] == "NOID empty")) then {
                        if (_this in [group leader _this]) then { "group" } else { "object" }
                    } else {
                        if (format["%1", _this + _this] == format["%1%2", _this, _this]) then { "string" } else {
                            if (format["%1", _this - _this] == "0") then { "number" } else { "unknown" }
                        }
                    }
                }
            }
        }
    }
};

// TRIG_ALL_LOGICS
/*
    funcIsNil
    usage: [anyValueThatMayBeNil] call funcIsNil
*/

funcIsNil = {
    private "_result";
    _result = true;
    (_this select 0) call { _result = false };
    _result
};

"OK"