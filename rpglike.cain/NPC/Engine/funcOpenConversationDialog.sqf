#define __conversationDirectory "NPC\Conversation\"
#define __currentLanguage (localize "STR:LANGUAGE")
// Arguments macro
#define arg(x) (_this select(x))
#define argIf(x) if(count _this>(x))
#define argIfType(x,t) if(argIf(x)then{(arg(x)call funcGetVarType)==(t)}else{false})
#define argSafe(x) argIf(x)then{arg(x)}
#define argSafeType(x,t) argIfType(x,t)then{arg(x)}
#define argOr(x,v) (argSafe(x)else{v})
// Position macro
#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)
#define w(a) ((a) select 2)
#define h(a) ((a) select 3)
// Control idc macro
#define __idcAnswer0 200
#define __idcAnswer1 201
#define __idcAnswer2 202
#define __idcAnswer3 203
#define __idcAnswer4 204
#define __idcAnswer5 205
#define __idcAnswer6 206
#define __idcAnswer7 207
#define __idcAnswersList [__idcAnswer0, __idcAnswer1, __idcAnswer2, __idcAnswer3, __idcAnswer4, __idcAnswer5, __idcAnswer6, __idcAnswer7]
#define __continueText "STR:DIALOG:BUTTON:CONTINUE"

funcOpenConversationDialog = {
    [
        _this,
        [   // dialog local variables
            "_npcObject",
            "_npcRecord",
            "_conversationFile",
            "_conversationFrames",
            "_currentFrameName",
            "_currentFrame",
            "_currentPageIndex",
            "_answers",
            "_answersIndexes",
            "_idcAnswersList",
            // dialog local functions
            "_init",
            "_selectAnswer",
            "_drawDisplay",
            "_getFrameByName",
            "_callUserCodeIntoNPCScope",
            "_openTradeDialog",
            "_onSelectAnswerEHs"
        ],
        [
            [__idcAnswer0, { 0 call _selectAnswer }],
            [__idcAnswer1, { 1 call _selectAnswer }],
            [__idcAnswer2, { 2 call _selectAnswer }],
            [__idcAnswer3, { 3 call _selectAnswer }],
            [__idcAnswer4, { 4 call _selectAnswer }],
            [__idcAnswer5, { 5 call _selectAnswer }],
            [__idcAnswer6, { 6 call _selectAnswer }],
            [__idcAnswer7, { 7 call _selectAnswer }]
        ],
        {
            _npcObject = _this;
            _DLGRSC = "DlgNPCDialog";
            _idcAnswersList = __idcAnswersList;
            //_npcRecord = _npcObject call funcGetNpcRecord;
            _npcRecord = _npcObject call funcGetOrCreateNpcRecord;

            //if (([_npcObject] call funcIsNil) || (count _npcRecord == 0)) then {
            if ([_npcObject] call funcIsNil) then {
                closeDialog 1; exit;
            } else {
                _conversationFile = _npcRecord call funcGetNpcConversationFile;
                _conversationFrames = call preprocessFile _conversationFile;
                _npcObject exec "NPC\Engine\scene.sqs";
            };

            _constructor = {
                // find entrypoint to dialogue
                _currentFrameName = ([_npcRecord, "entryPointToConversation", ""] call funcStorageGet) call {
                    if (_this == "") then {_conversationFrames select 0} else {_this}
                };
                _currentFrame = _currentFrameName call _getFrameByName;
                _currentPageIndex = 0;
                call _drawDisplay;
            };

            _destructor = {
                //hint format ["%1",  _npcRecord];
                _npcObject doWatch objNull;
                private "_byeCode";
                _byeCode = [_npcRecord, "byeCode", {}] call funcStorageGet;
                [_npcRecord, ["byeCode"]] call funcStorageDel;
                [_byeCode, _npcObject, _npcRecord] call _callUserCodeIntoNPCScope;
            };

            _onSelectAnswerEHs = [];
            _selectAnswer = {
                if (_this < count _onSelectAnswerEHs) then {
                    [_onSelectAnswerEHs select _this, _npcObject, _npcRecord] call _callUserCodeIntoNPCScope;
                };
                _onSelectAnswerEHs = [];
                // One frame of dialogue with NPC (Frame) can consist more than of one page (Page) (that got on the screen),
                // whether we will check up all pages are already displayed
                if (count _currentFrame - 1 != _currentPageIndex) then {
                    call _drawDisplay;
                } else {
                    _currentFrameName = (_answers select (_answersIndexes select _this)) select 1;
                    if (_currentFrameName == "[exit]") then {
                        closeDialog 1;
                        false
                    } else {
                        if (_currentFrameName == "[trade]") then {
                            private "_tradeFunction";
                            _tradeFunction = [_npcRecord, "tradeFunction", _openTradeDialog] call funcStorageGet;
                            [_tradeFunction, _npcObject, _npcRecord] call _callUserCodeIntoNPCScope;
                            false
                        } else {
                            _currentFrame = _currentFrameName call _getFrameByName;
                            _currentPageIndex = 0;
                            call _drawDisplay;
                        };
                    };
                };
            };

            _drawDisplay = {
                // last item of a frame - variants of answers
                _answers = _currentFrame select (count _currentFrame - 1);
                ctrlEnable [100, false];
                ctrlEnable [101, false];
                // to display the said text
                ctrlSetText [100, format [_currentFrame select _currentPageIndex, name player, name _npcObject]];
                // hide any buttons
                {
                    ctrlEnable [_x, false];
                    ctrlShow [_x, false];
                } foreach _idcAnswersList;

                // if all pages are not displayed yet
                if (count _currentFrame - 2 != _currentPageIndex) then {
                    ctrlSetText [_idcAnswersList select 0, localize __continueText];
                    ctrlEnable [_idcAnswersList select 0, true];
                    ctrlShow [_idcAnswersList select 0, true];
                } else {
                    private ["_i", "_j"];
                    _i = 0;
                    _j = 0;
                    _answersIndexes = [];
                    {
                        if (
                            if (count _x > 2) then {
                                if ((_x select 2) in [true, false]) then { _x select 2 } else { call (_x select 2) }
                            } else {
                                true
                            }
                        ) then {
                            if (count _x > 3) then {
                                _onSelectAnswerEHs set [_i, _x select 3];
                            };
                            ctrlSetText [_idcAnswersList select _i, format [_x select 0, name player, name _npcObject]];
                            ctrlEnable [_idcAnswersList select _i, true];
                            ctrlShow [_idcAnswersList select _i, true];
                            _answersIndexes set [count _answersIndexes, _j];
                            _i = _i + 1
                        };
                        _j = _j + 1;
                    } foreach _answers;
                };
                _currentPageIndex = _currentPageIndex + 1
            };

            // Search "Frame" with the specified name in a file of pairs "FrameName, Frame" (_conversationFrames).
            _getFrameByName = {
                private "_find";
                _find = {
                    private ["_i", "_count"];
                    _i = 0;
                    _count = count _conversationFrames;
                    if (_count % 2 != 0) then {
                        ["Error: funcOpenConversationDialog.sqf, uncorrect file format '%1')", _conversationFile] call DEBUGHINT;
                        closeDialog 1;
                        exit;
                    };
                    while { _conversationFrames select _i != _this } do { _i = _i + 2 };
                    if (_i < _count) then {
                        _conversationFrames select (_i+1)
                    } else {
                        ["Error: funcOpenConversationDialog.sqf, frame name '%1' not found in file '%2')", _this, _conversationFile] call DEBUGHINT;
                        closeDialog 1;
                        exit;
                    }
                };
                private "_frame";
                _frame = _this call _find;
                [_frame, _npcObject, _npcRecord] call _callUserCodeIntoNPCScope
            };

            // аргументы: conversation frame, _npcObject, _npcRecord
            _callUserCodeIntoNPCScope = {
                // защитим все наши переменные (включая внутренние переменные диалоговой системы),
                // чтобы пользовательский код их не попортил
                private _0_DLG_PRIVATE_DEFENCE;
                // переменные в этом контексте
                private [
                    "_npc", "_npcRecord", "_npcUserScope",
                    "_setAve", "_setAveFile", "_setTrade", "_setBye",
                    "_addFlag", "_delFlag", "_isFlag", "_setVar", "_getVar", "_delVar", "_thisPath"
                ];
                // сам непись
                _npc = arg(1);
                // его область данных
                _npcRecord = arg(2);
                // его "память", то есть область данных, которой пользуется писатель диалогов
                _npcUserScope = [_npcRecord, "#"] call funcStorageGet;

                // функи для писателя диалогов
                // устанавливает другой начальный фрэйм
                _setAve = { [_npcRecord, "entryPointToConversation", _this] call funcStorageSet };
                // устанавливает другой файл разговоров
                _setAveFile = { [_npcRecord, "conversation", (localize "STR:LANGUAGE") + "\" + _this] call funcStorageSet };
                // устанавливает собственную функцию торговли, см. как написан _openTradeDialog
                _setTrade = { [_npcRecord, "tradeFunction", _this] call funcStorageSet };
                // устанавливает код который будет выполнен при закрытии диалога,
                _setBye = { [_npcRecord, "byeCode", _this] call funcStorageSet };

                // записывает переменную в память непися
                _setVar = { [_npcUserScope, arg(0), arg(1)] call funcStorageSet };
                // читает переменную из памяти непися
                _getVar = { [_npcUserScope, arg(0), arg(1)] call funcStorageGet };
                // удаляет переменные из памяти непися
                _delVar = { [_npcUserScope, _this] call funcStorageDel };

                // устанавливает метку-флаг в память непися, например ("непись обиделся" call _addFlag)
                _addFlag = { [_npcUserScope, _this, true] call funcStorageSet };
                // удаляет метку-флаг из памяти непися, например ("непись обиделся" call _delFlag)
                _delFlag = { [_npcUserScope, [_this]] call funcStorageDel };
                // проверяет наличие метки-флага в памяти непися, например ("непись обиделся" call _isFlag)
                _isFlag = { [_npcUserScope, _this, false] call funcStorageGet };

                _thisPath = {
                    __conversationDirectory + __currentLanguage + "\" + _this
                };

                // теперь вызываем фрэйм
                call arg(0)
            };

            _openTradeDialog = {
                [
                    [
                        ["W", weapons player call funcList2Collection, weapons _npc call funcList2Collection],
                        ["M", magazines player call funcList2Collection, magazines _npc call funcList2Collection]
                    ], _npc, player
                ] call funcOpenTradeDialog;
            };
        }
    ] call funcCreateDialog;
};
