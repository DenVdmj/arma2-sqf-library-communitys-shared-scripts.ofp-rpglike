//---------------------------------------------------------------------------------
// Script: "lib\NPCInteractionEngine\init.sqf
// Require: "lib\shared.sqf"
// Description:
//   Set interaction menu item for all NPC on map
// Usage:
//   Init engine:
//       PlayerCloseZoneTrigger_20m call preprocessFile "lib\NPCInteractionEngine\init.sqf"
//   Add action:
//       _id = ["menu text", "menu text alternative", "sqf function", [params]] call funcAddInteractionMenuItem
//   Delete action (syntax 1):
//       _id call funcDelInteractionMenuItem
//   Delete action (syntax 2):
//       "actionScript.sqf" call funcDelInteractionMenuItem
//-----------------------------------------

#define __interactDistance 2;
#define __interactFocus 1.8;
#define __interactSector 30;

#define __tracer "lib\NPCInteractionEngine\tracer.sqs"
#define __actionexecutor "lib\NPCInteractionEngine\action.sqs"

#define __register var_NPCInteractionEngine_register
#define __sqfscriptlist var_NPCInteractionEngine_TMPSQFScriptList

#define arg(x) (_this select(x))
#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)
#define w(a) ((a) select 2)
#define h(a) ((a) select 3)

__register = [];

funcAddInteractionMenuItem = {
    __register set [count __register, _this];
};

funcDelInteractionMenuItem = {
    private ["_menuItem", "_menuItemID", "_type", "_i"];
    _menuItemID = -1;
    _menuItem = _this;
    _type = _menuItem call funcGetVarType;
    if (_type == "string") then {
        _i = 0;
        while {
            (__register select _i) call {(_this select 1) != _menuItem}
        } do { _i = _i + 1 };
        if (_i < count __register) then {
            _menuItemID = _i;
        };
    };
    if (_type == "number") then {
        _menuItemID = _menuItem;
    };
    if (_menuItemID >= 0) then {
        __register set [_menuItemID, ""];
        __register = __register - [""];
        true
    } else {
        false
    }
};

private "_privateNames";
_privateNames = [
    "_privateNames", "_initFunctionCode",
    "_userActionSensor", "_distance", "_focus", "_sector", "_sleep", "_npc",
    "_getLocalText", "_condition", "_findNpc", "_addActions", "_removeActions"
];

_initFunctionCode = {

    // params
    _userActionSensor = _this;
    _distance = __interactDistance;
    _focus = __interactFocus;
    _sector = __interactSector;
    _sleep = .4;

    // functions
    _getLocalText = {
        private ["_instrFormat", "_npcName", "_text"];
        _instrFormat = localize ("STR:INSTR:" + name _npc);
        if (_instrFormat != "") then { // found instrumental case form ?
            // For russian and other slavic languages, example: format ["поговорить с %1", "местным аборигеном"]
            _npcName = format [_instrFormat, name _npc];
            _text = arg(0);
        } else {
            _npcName = name _npc;
            _text = arg(1);
        };
        _text = localize _text call {if (_this == "") then {_text} else {_this}};
        format [_text, _npcName]
    };

    _condition = {
        if (
            alive _this &&
            _this != player &&
            behaviour player == "SAFE" &&
            _this distance player < _distance &&
            _this == vehicle _this &&
            "man" countType [_this] != 0
        ) then {
            private ["_p1","_p2","_dx","_dy"];
            _p1 = getpos player;
            _p2 = getpos _this;
            _dx = x(_p1) - x(_p2);
            _dy = y(_p1) - y(_p2);
            if (_dx == 0 && _dy == 0) then { false } else {
                abs((180 + (_dx atan2 _dy)) - getdir player) < _sector
            }
        } else {
            false
        }
    };

    _findNpc = {
        private "_list";
        _userActionSensor setpos getpos player;
        _list = [];
        {
            if ( _x call _condition ) then {
                _list set [count _list, _x]
            }
        } foreach list _userActionSensor;
        [[player, _distance, 0] call funcPos2DRelObj, _list, _focus] call funcNearestFromList
    };

    _addActions = {
        private ["_scriptByID", "_idList"];
        _scriptByID = [];
        _idList = [];
        __sqfscriptlist = [_scriptByID, _idList];
        {
            //QWE = format ["%1", [_x select 0, _x select 1, [_x select 0, _x select 1] call _getLocalText, __actionexecutor]];
            _id = _npc addAction [[_x select 0, _x select 1] call _getLocalText, __actionexecutor];
            _scriptByID set [_id, _x];
            _idList set [count _idList, _id];
        } foreach __register;
    };

    _removeActions = {
        private "_idList";
        _idList = __sqfscriptlist select 1;
        {
            _npc removeAction _x;
        } foreach _idList;
        __sqfscriptlist = nil;
    };
};

[_privateNames, _initFunctionCode, _this] exec __tracer;

