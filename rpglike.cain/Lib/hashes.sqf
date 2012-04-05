// call preprocessFile "lib\hash.sqf"
#define arg(x) (_this select(x))

// ������� funcStorageError
// ���������� ��� ������� ���� �� ���������� � �������
// funcStorageError = {};

//
//  ������� funcStorageCreate
//  ������� ����� ���
//  ��������: ������ ������ � �� �������� ����� �������
// ������:
//     ["key1", "value1", "key2", "value2", "key3", "value3", "key4", "value4"] call funcStorageCreate
// ����������� ��� �������, ��� ��� ���������� ����� ����� ���������
//
funcStorageCreate = { _this };

//
// ������� funcStorageSet
// ���������:
//      [���, ����, ��������] call funcStorageSet
// ������������� �������� ��� �����, ������� ����� ������ ���� ���� �� ������������
//

funcStorageSet = {
    private ["_storage", "_key", "_value", "_i"];
    _storage = arg(0);
    _key = arg(1);
    _value = arg(2);
    if (!([_key] call funcIsNil)) then {
        _i = 0;
        while { !((_storage select _i) in [_key]) } do { _i = _i + 2 };
        if (_i < count _storage) then {
            _storage set [_i+1, _value];
        } else {
            _storage set [count _storage, _key];
            _storage set [count _storage, _value];
        };
        true
    } else {
        "Error in funcStorageSet: key is nil" call funcStorageError;
        false
    }
};

//
// ������� funcStorageAdd
// ���������:
//      [���, ����, ��������] call funcStorageAdd
// ��������� ������ ���� ���� ��� ��� ����. ��� ������� ������� ��� funcStorageSet,
// ������ ������������ �� ����� ������ ���� �� ���������� ������� � ���, ��� ������
// ��� ���, ��������, ��� ��������� ���������� ����
//

funcStorageAdd = {
    private ["_storage", "_key", "_value", "_i"];
    _storage = arg(0);
    _key = arg(1);
    _value = arg(2);
    if (!([_key] call funcIsNil)) then {
        _storage set [count _storage, _key];
        _storage set [count _storage, _value];
        true
    } else {
        "Error in funcStorageSet: key is nil" call funcStorageError;
        false
    }
};

//
// ������� funcStorageGet
// ���������:
//      [���, ����, �������� �� ���������] call funcStorageGet
// ���������� ������ �� �����
// ���� ������ �� �������, ������ nil, ��� �������� �� ��������� ���� ��� �������
//

funcStorageGet = {
    private ["_storage", "_key", "_i"];
    _storage = arg(0);
    _key = arg(1);
    _i = 0;
    while { !((_storage select _i) in [_key]) } do { _i = _i + 2 };
    if (_i < count _storage) then {
        _storage select (_i+1)
    } else {
        "Error in funcStorageGet" call funcStorageError;
        arg(2) // default value, nil is not :)
    }
};

//
// ������� funcStorageDel
// ���������:
//      [���, [������ ������]] call funcStorageDel
// ������� �� ���� ������ � ���������� �������
//

funcStorageDel = {
    private ["_storage", "_key", "_i", "_offset", "_currentKey"];
    _storage = arg(0);
    _keys = arg(1);
    _i = 0;
    _offset = 0;
    while {
        _currentKey = _storage select _i;
        !(_currentKey in [_key])
    } do {
        if (_offset > 0) then {
            _storage set [_i - _offset, _currentKey];
            _storage set [_i - _offset + 1, _storage select (_i+1)];
        };
        if (_currentKey in _keys) then {
            _offset = _offset + 2;
        };
        _i = _i + 2;
    };
    _storage resize ((count _storage) - _offset);
};

//
// ������� funcStorageForEach
// ���������:
//      [���, { /* ������� ������� */ }] call funcStorageForEach
// ��������� ������� ������� ��� ������ ���� ����/�������� ����
// ������� ������� �������� ���� ����/�������� � _this, ����� �������� ���������� _key, _value
//


funcStorageForEach = {
    private ["_private_", "_key", "_value"];
    _private_ = ["_private_", "_storage_", "_callback_", "_i_"];
    private _private_;
    _storage_ = arg(0);
    _callback_ = arg(1);
    _i_ = 0;
    while {
        _key = _storage_ select _i_;
        _key call { // not call if _key is nil
            _value = _storage_ select (_i_+1);
            _callback_ call {
                // prevent corruption our _privates_ variable
                private _private_;
                // call user code
                [_key, _value] call _this;
            };
            true
        }
    } do { _i_ = _i_ + 2 };
};

//
// �����
// testlist = []; [varGlobalGameNPCRegistry, { testlist set [count testlist, _key] }] call funcStorageForEach; testlist
//
// p = ["k1",123, "k2",654, "k3",4234, "key123", player]; p
// [p, ["k2"]] call funcStorageDel; p
// p = ["k1",123, "k2",654, "k3",4234, "keyPlayer", player]; [p, ["k2", "k1"]] call funcStorageDel; p
// p = ["k1",123, "k2",654, "k3",4234, "key123", player]; p
// [p, "key123", "poi"] call funcStorageSet; p
//

