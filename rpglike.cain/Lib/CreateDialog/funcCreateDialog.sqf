// sqf vdmj@yandex.ru
/*
    Function funcCreateDialog
    Usage:
    [
        [dialog arglist],
        [dialog private names],
        [
            [idc1, { event handler 1 }],
            [idc2, { event handler 1 }],
            [idc3, { event handler 1 }],
            [idc4, { event handler 1 }],
            [idc5, { event handler 1 }]
        ],
        { // initialization code
            _dlgrsc = "DlgExample"; // create DlgExample dialog
            _constructor = {}; // optional
            _destructor = {};  // optional
        }
    ] call funcCreateDialog
*/

#define DIALOGTRACER "lib\CreateDialog\funcCreateDialog.tracer.sqs"
#define RESERVEDIDCUID   1000
#define RESERVEDIDCINDEX 1001
#define XOR(a,b) (!(a && b) && (a || b))

funcCreateDialog = {
    ([
        {
            if (!createDialog _dlgrsc) then { exit };               // create dialog
            _0_DLG_DLGUID = format ["DIALOGUID:%1", random 1e+20];  // create unique identifier, and store this in special control
            ctrlSetText[RESERVEDIDCUID, _0_DLG_DLGUID];             // set up dialog identifier
            _0_DLG_HNDLRS = _this;                                  // handlers array
            _0_DLG_CNTRLS = [];                                     // contrlos array
        },
        {
            private ["_setEH", "_buttonAction", "_idc", "_tmp", "_index"];

            //
            // "event generator" for buttons
            //
            _0_DLG_CNTRLS set [count _0_DLG_CNTRLS,
                [0, 0, 0, {
                    if (ctrlText RESERVEDIDCINDEX != "") then {
                        (
                            (
                                (_0_DLG_HNDLRS select (call (ctrlText RESERVEDIDCINDEX))) select 0
                            ) call (
                                (_0_DLG_HNDLRS select (call (ctrlText RESERVEDIDCINDEX))) select 1
                            )
                        );
                        ctrlSetText[RESERVEDIDCINDEX, ""]
                    }
                }]
            ];

            //
            // "event generator" for other controls. function template
            //
            //  %1 -- ctrlGet   (for read value)
            //  %2 -- ctrlSet   (for write value)
            //  %3 -- test value
            //  %4 -- event handler index (in _0_DLG_HNDLRS array)
            //  %5 -- idc
            //
            _setEH = {
                _tmp = %1 %5;           // save start value
                %2 [%5, %3];            // lets try to change it
                if (%1 %5 == %3) then { // if successfully
                    %2 [%5, _tmp];          // restore value
                    _x set [2, _tmp];       // previous value
                    _x set [3, {if (%1(_x select 0) != (_x select 2)) then {%5 call (_x select 1); _x set[2, %1(_x select 0)]}}]; // "event generator" function
                    _0_DLG_CNTRLS set [count _0_DLG_CNTRLS, _x]; // bind control on _0_DLG_CNTRLS
                    true
                } else {
                    false
                }
            };
            _index = 0;
            { // for each event handlers
                _idc = _x select 0;
                // create "button action"
                _buttonAction = format [{ctrlSetText[%1, "%2"]}, RESERVEDIDCINDEX, _index];
                // set it action
                buttonSetAction [_idc, _buttonAction];
                // failing? for other controls:
                if (buttonAction _idc != _buttonAction) then {
                    if (!call format [_setEH, "sliderPosition", "sliderSetPosition", 1, _index, _idc]) then {
                        if (!call format [_setEH, "ctrlText", "ctrlSetText", format ["""%1""", random 1e+20], _index, _idc]) then {
                            call format [_setEH, "lbCurSel", "lbSetCurSel", 0, _index, _idc];
                        }
                    }
                };
                _index = _index + 1;
            } foreach _0_DLG_HNDLRS;
        },
        {
            private "_isActive";
            _isActive = ctrlText RESERVEDIDCUID == _0_DLG_DLGUID;
            if (_isActive) then {
                { call (_x select 3) } foreach _0_DLG_CNTRLS;
                if (_0_DLG_STARTTIME + _dlgCallPeriod < _time) then {
                    call _dlgCall;
                    _0_DLG_STARTTIME = _time
                }
            };
            if (_isActive) then { false } else { XOR(!_0_DLG_PREVDIALOG,dialog) }
        }
    ] + _this ) exec DIALOGTRACER;
};
