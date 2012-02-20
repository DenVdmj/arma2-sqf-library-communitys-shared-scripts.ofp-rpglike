//
// ������ funcGetTimeInHumanFormat
// ������������� 
//    daytime call preprocessFile "Lib\ru.time.sqf"


private [
    "_numerals", "_numeralsMinuteWO", "_numeralsHourCF", "_numeralsMinute", "_numeralsHour",
    "_nounMinute", "_nounMinuteWO", "_nounHour", "_floor", "_sxd", "_getNoun", "_getNumerals"
];

_numerals = ["����", "����", "���", "���", "������", "����", "�����", "����", "������", "������",
"������", "�����������", "����������", "����������", "������������", "����������", "�����������", "����������", "������������",
"������������", "��������", "��������", "�����", "���������", "����������"];

_numeralsMinuteWO = ["����", "�����", "����", "����", "�������", "����", "�����", "����", "������", "������",
"������", "�����������", "����������", "����������", "������������", "����������", "�����������", "����������", "������������",
"������������", "��������", "��������", "������", "����������", "�����������"];

_numeralsHourCF = ["��������", "�������", "�������", "��������", "����������", "������",
"������", "��������", "��������", "��������", "��������", "�������������", "������������"];

_numeralsMinute = +_numerals;
_numeralsMinute set [1, "����"];
_numeralsMinute set [2, "���"];

_numeralsHour = +_numerals;
_numeralsHour set [1, "���"];
_numeralsHour set [2, "���"];

_nounMinute = ["������", "������", "�����"];
_nounMinuteWO = ["������", "�����", "�����"];
_nounHour = ["���", "����", "�����"];

_floor = { _this - (_this % 1) };
_sxd = { (_this call _floor) % 60 };

_getNoun = {
    private ["_num", "_numd", "_nouns"];
    _num = _this select 0;
    _numd = _num % 10 call _floor;
    _nouns = _this select 1;
    if (_num > 4 && _num < 21) then {
        _nouns select 2
    } else {
        if (_numd == 1) then {
            _nouns select 0
        } else {
            if (_numd > 1 && _numd < 5) then {
                _nouns select 1
            } else {
                _nouns select 2
            }
        }
    }
};

_getNumerals = {
    private ["_num", "_numerals"];
    _num = _this select 0;
    _numerals = _this select 1;
    if (_num <= 20) then {
        _numerals select _num
    } else {
        (_numerals select (18 + (_num/10 call _floor))) + " " +
        (_numerals select (_num%10 call _floor))
    }
};

call {
    private ["_time", "_hour", "_minute", "_timeFormatEq", "_timeFormat1", "_timeFormat2",
        "_timeFormat3", "_timeFormat4", "_timeFormat5"
    ];

    _time = _this;
    _hour = _time call _sxd;
    _minute = _time * 60 call _sxd;

    // 0 .. 24
    _timeFormatEq = {
        private ["_str", "_hourm"];
        _hourm = (((_this + 23) % 12) + 1) call _floor;
        _str = (
            if (_this < 5) then { "����" } else {
                if (_this < 10) then { "����" } else {
                    if (_this < 17) then { "���" } else {
                        if (_this < 24) then { "������" } else { "����" }
                    }
                }
            }
        );
        format [
            ["%1 %2 %3", "%2 %3"] select (_hourm == 1),
            [_hourm, _numeralsHour] call _getNumerals,
            [_hourm, _nounHour] call _getNoun, _str
        ]
    };

    _timeFormat1 = {
        _hour call _timeFormatEq
    };

    _timeFormat2 = {
        _hour+1 call _timeFormatEq
    };

    _timeFormat3 = { // X-���� ����� X-���
        format [
            "%1 %2 %3",
            [_minute, _numeralsMinute] call _getNumerals,
            [_minute, _nounMinute] call _getNoun,
            [(((_hour + 24) % 12) + 1) call _floor, _numeralsHourCF] call _getNumerals
        ]
    };

    _timeFormat4 = {
        format [
            "��� %1 %2 %3",
            [60 - _minute, _numeralsMinuteWO] call _getNumerals,
            [60 - _minute, _nounMinuteWO] call _getNoun,
            [(((_hour + 24) % 12) + 1) call _floor, _numeralsHour] call _getNumerals
        ]
    };

    _timeFormat5 = {
        format ["�������� %1", [(((_hour + 24) % 12) + 1) call _floor, _numeralsHourCF] call _getNumerals]
    };

    if (_minute < 3) then _timeFormat1 else {
        if (_minute < 27) then _timeFormat3 else {
            if (_minute < 33) then _timeFormat5 else {
                if (_minute < 57) then _timeFormat4 else _timeFormat2
            }
        }
    }
}
