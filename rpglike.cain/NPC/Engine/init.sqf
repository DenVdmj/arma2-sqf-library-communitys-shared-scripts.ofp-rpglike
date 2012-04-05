
#define STR_UA_TalkTo "STR:UA:TalkTo"
#define STR_UA_Talk "STR:UA:Talk"
#define __npcDirectory "NPC\"
#define __thisDirectory "NPC\Engine\"
#define __conversationDirectory "NPC\Conversation\"
#define __currentLanguage (localize "STR:LANGUAGE")
#define __registry varGlobalGameNPCRegistry
#define __isGroup(obj) (obj in [group leader obj])
#define __isTrigger(obj) (typeOf obj == "EmptyDetector")
#define arg(x) (_this select(x))
#define push(a,v) (a)set[count(a),(v)]
#define pushTo(a) call{(a)set[count(a),_this]}

#define __initAnyUnit(u) if (!(u hasWeapon "rls_Inventory")) then { u addWeapon "rls_Inventory" }

call preprocessFile "npc\engine\funcOpenConversationDialog.sqf";

//
// funcGetNpcRecord
// ��������: object NPC
// ���������� "������� ������" �������, ���� �� ���������������, ����� ���������� ������ ������
//
funcGetNpcRecord = {
    __initAnyUnit(_this);
    [__registry, _this, []] call funcStorageGet
};

//
// funcGetOrCreateNpcRecord
// ��������: object NPC
// ���������� "������� ������" �������.
// ���� ������ � ������� ��� ������� ���, ������� � ���������� ��� ������
//
funcGetOrCreateNpcRecord = {
    private "_record";
    _record = _this call funcGetNpcRecord;
    if (count _record == 0) then {
        _record = [
            // ���� � ���������� ����������
            "conversation", __currentLanguage + "\default\conversation.sqf",
            // "#" -- ������ ��� ����, ����� storage
            "#", [] call funcStorageCreate
        ] call funcStorageCreate;
        [__registry, _this, _record] call funcStorageSet;
    };
    _record
};

//
// funcGetNpcConversationFile
// ��������: "������� ������" ������� (�� ����� ��������, ������� ������ ����� funcGetNpcRecord)
// ���������� ����/��� ����� ���������� �������.
//

funcGetNpcConversationFile = {
    __conversationDirectory + ([_this, "conversation", __currentLanguage + "\Default\conversation.sqf"] call funcStorageGet)
};

//
// funcGetNpcMemory
// ��������: "������� ������" ������� (�� ����� ��������, ������� ������ ����� funcGetNpcRecord)
// ���������� ������ �������.
// �������� � ������� ��������� funcStorageSet, funcStorageGet, funcStorageDel (��. "Lib\hashes.sqf")
//

funcGetNpcMemory = {
    [_this, "#", []] call funcStorageGet
};

call {
    private ["_locationSensors", "_registryOtherNPCs"];
    _locationSensors = [];
    __registry = [];
    _registryOtherNPCs = {
        //player sideChat "_registryOtherNPCs";
        private ["_locationRecord", "_conversationFile"];
        _locationRecord = _this call funcGetNpcRecord;
        if (count _locationRecord != 0) then {
            {
                {
                    if (("man" countType [_x]) != 0 && !(_x in units player)) then {
                        if (count (_x call funcGetNpcRecord) == 0) then {
                            // ���������� ������� ����� ������ ������� (� ��� ���� � ����������� � "������ ��� ����")
                            [__registry, _x, +_locationRecord] call funcStorageAdd;
                        };
                    };
                } foreach crew _x;
            } foreach list _this;
        }
    };
    call {
        private ["_medium", "_conversationFile", "_index", "_objectList", "_object", "_record", "_keyValueList"];
        {
            _medium = _x select 0;
            _conversationFile = _x select 1;
            _objectList = if (__isGroup(_medium)) then { units _medium } else { [_medium] };
            {
                _object = _x;
                _record = [
                    // ���� � �����������
                    "conversation", __currentLanguage + "\" + _conversationFile,
                    // "#" -- ������ ��� ����, ����� storage
                    "#", [] call funcStorageCreate
                ] call funcStorageCreate;
                [__registry, _object, _record] call funcStorageAdd;
                if (__isTrigger(_object)) then {
                    push(_locationSensors, _object)
                };
            } foreach _objectList;
        } foreach call ("["+(preprocessFile (__npcDirectory + "registry.sqf"))+"]");
    };

    [
        STR_UA_TalkTo, STR_UA_Talk,
        {arg(0) call funcOpenConversationDialog}, []
    ] call funcAddInteractionMenuItem;

    {
        [_x, _registryOtherNPCs] exec (__thisDirectory + "registryLocation.sqs");
    } foreach _locationSensors;

    {
        private "_magazines";
        _magazines = magazines player;
        showMap ("rls_Map" in _magazines);
        showPad ("rls_Blocknote" in _magazines);
        showGps ("rls_Gps" in _magazines);
        showWatch ("rls_Clock" in _magazines);
        showRadio ("rls_WalkieTalkie" in _magazines);
        showCompass ("rls_Compass" in _magazines);
    } exec (__thisDirectory + "trace.player.sqs");

    __initAnyUnit(player);

};



