// SQF

//
// Controls IDC & display mode control
//

#define IDCDisplayText   102
#define IDCDisplayList   103
#define IDCDisplayEdit   104
#define IDCDisplayFrame  105
#define IDCEvalButton    106
#define IDCAsArrayButton 107

#define arg(i) (_this select (i))

//
// save local names scope
//

private "_ourContext";

_ourContext = [
    // self variable
    "_ourContext",
    // functions
    "_fSetDisplayMode", "_fGetVarType", "_fIsNil", "_fParseTree",
    // varialbes
    "_typesTable", "_evalResult", "_isShowTypesModeOn", "_emptyDetector", "_sideUnknown"
];

private _ourContext;

_fSetDisplayMode = {
    { ctrlShow [_x, _x == _this] } foreach [IDCDisplayText, IDCDisplayList, IDCDisplayEdit]; // disable all excepting inquired
    ctrlShow [IDCDisplayFrame, IDCDisplayText == _this]; // frame for multiline display
};

//
// Native data types
//

#define ARRAY_TYPE   0
#define GROUP_TYPE   1
#define OBJECT_TYPE  2
#define SIDE_TYPE    3
#define BOOL_TYPE    4
#define STRING_TYPE  5
#define NUMBER_TYPE  6
#define UNKNOWN_TYPE 7
#define UNDEFINED_TYPE 8

#define TYPE_FORMAT(t) (_typesTable select (t)*3+2)
#define TYPE_IMAGE(t) (_typesTable select (t)*3+1)
#define TYPE_NAME(t) (_typesTable select (t)*3)

_typesTable = [
//  type,     img, format
    "array",  "", "%1",
    "group",  "", "group: %1",
    "object", "", "object: %1",
    "side",   "", "side: %1",
    "bool",   "", "bool: %1",
    "string", "", "string: ""%1""",
    "number", "", "number: %1",
    "unknown", "", "unknown: %1",
    "undefined", "", "undefined: %1"
];

_emptyDetector = "EmptyDetector" createVehicle [0,0,0];
_sideUnknown = side _emptyDetector;
deleteVehicle _emptyDetector;

_fGetVarType = {
    if (_this in [1e+999, -1e+999, 1e+999-1e+999]) then { NUMBER_TYPE } else {
        if (!(_this in [_this])) then { ARRAY_TYPE } else {
            if (_this in [true, false]) then { BOOL_TYPE } else {
                if (_this in [east, west, resistance, civilian, sideFriendly, sideEnemy, sideLogic, _sideUnknown]) then { SIDE_TYPE } else {
                    if (_this in [""]) then { STRING_TYPE } else {
                        ctrlSetText [98743, ""];
                        ctrlSetText [98743, _this];
                        if (ctrlText 98743 != "") then { STRING_TYPE } else {
                            if ((("all" countType [_this]) != 0) || (_this in [grpNull, objNull]) || (format["%1", _this] in ["NOID empty", "NOID camera"])) then {
                                if (_this in [group leader _this]) then { GROUP_TYPE } else { OBJECT_TYPE }
                            } else {
                                if (_this - _this == 0) then { NUMBER_TYPE } else { UNKNOWN_TYPE }
                            }
                        }
                    }
                }
            }
        }
    }
};


_fIsNil = {
    private "_result";
    _result = true;
    (_this select 0) call { _result = false };
    _result
};

_fParseTree = {
    // Arguments:
    // [ value or values tree, base text indent, callback functions for : event Scalar, event ArrayOpen, event ArrayClose ],
    // functions context space: _value, _depth, _comma, _indent, _type (comment: current value, current depth, needs comma, current indent, type of current value)
    private ["_input", "_baseInput", "_ehScalar", "_ehArrayOpen", "_ehArrayClose", "_fWalkTree"];

    _fWalkTree = {
        // arguments: current value, current depth, current indent, needs comma
        private ["_value", "_depth", "_indent", "_comma", "_type", "_i"];
        _value  = arg(0);
        _depth  = arg(1);
        _indent = arg(2);
        _comma  = arg(3);
        if ([_value] call _fIsNil) then {
            _type = UNDEFINED_TYPE;
            call _ehScalar;
        };

        _type = _value call _fGetVarType;

        if (_type == ARRAY_TYPE) then {
            _i = count _value;
            call _ehArrayOpen;
            {
                _i = _i-1;
                [_x, _depth+1, _indent+_baseInput, ["", ","] select (_i != 0)] call _fWalkTree
            } foreach _value;
            call _ehArrayClose;
        } else {
            call _ehScalar
        };
    };

    _input = arg(0);
    _baseInput = arg(1);
    _ehScalar = arg(2);
    _ehArrayOpen = arg(3);
    _ehArrayClose = arg(4);

    [_input, 0, "", ""] call _fWalkTree;
};

//////////////////////////////////////////////////////////////
// eval user input, with protection our context
_evalResult = call { private _ourContext; call ctrlText 100 };

lbClear IDCDisplayList;
IDCDisplayList call _fSetDisplayMode;

ctrlSetText [IDCDisplayEdit, format ["%1", _evalResult]];

_isShowTypesModeOn = ctrlText 108 == localize "STR_SQFCALC_ShowTypesModeOn";

[
    _evalResult, "    ",
    // context space: _value, _depth, _comma, _indent, _type
    {
        lbAdd [IDCDisplayList, _indent + format [["%1", TYPE_FORMAT(_type)] select _isShowTypesModeOn, _value] + _comma]
    },
    {
        lbAdd [IDCDisplayList, _indent + "[" ]
    },
    {
        lbAdd [IDCDisplayList, _indent + "]" + _comma]
    }
] call _fParseTree;


