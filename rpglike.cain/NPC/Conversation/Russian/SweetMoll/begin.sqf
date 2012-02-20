// SQF: NPC Conversation
#include "rls\macro"
[
    "����", {
        if (count magazines _npc == 0) then {
            {
                _r = random 20; while {_r > 1} do { _npc addMagazine _x; _r = _r-1 };
            } foreach [
                "rls_Map", "rls_WalkieTalkie", "rls_Clock", "rls_Compass", "rls_Gps", "rls_Blocknote", "rls_Notebook", "rls_Book",
                "rls_Radio", "rls_Radio2", "rls_MineTM62m", "rls_Stonny", "rls_Cartridge", "rls_DeadHead", "rls_BottleSeagram",
                "rls_BottleWhiskey", "rls_BottleNapoleon", "rls_BottleMartini", "rls_BottleJack", "rls_BottleBarbero", "rls_BottleBaileys",
                "rls_Vibrator", "rls_Dildo", "rls_LatexBandaging"
            ];
        };
        [
            "������, ��������! ������ ������ ����� �� �����?",
            [
                ["� ����� �� � �����?!", "������� ����������"],
                ["������ ��� ���� �������!", "[trade]"],
                ["�����-�� ��������, ��� � ���� ��� �����!", "��� ����"],
                ["����", "[exit]"]
            ]
        ]
    },
    "��� ����",
    {
        [
            "������� ������ ��� ���� ������!",
            [
                ["������ ����, �����!", "�����"],
                ["�� �����, ������ ������ ��� ���� ������!", "[trade]"],
                ["��-�� ���� �� ���! (�����)", "[exit]"]
            ]
        ]
    },
    "�����",
    {
        [
            "���-��! ������ ����! ����� ���� �����!",
            [
                ["[���������, ��� � ����� ��� �����]", "[trade]"],
                ["[�����]", "[exit]"]
            ]
        ]
    },
    "������� ����������",
    {
        [
            "�� ��������, ����� ������ � ���� �����, ����, GPS-���������, ��������� ������. ��� ���� ��������� ���� ����� ����� �����.",
            "��� ��������, ������� �� ���������, ��� ���� ������, ���� ��������, ����...",
            "���� �������� (�����, GPS, � ������, ��� � ������), ������� �� ����� ���� ��������, �� ���� ���, ��� ������� ����� � ��������� ����� � ��� ���������. ��� ��������-��������, ��� ������� �������� � ������ rls_Inventory, ��������� ��� � ������� ������ rls (""rls\config.cpp""), ���������� �� ������� ��������� ���, ��� ��� �� �������� ������ (magazineType = 0), � ������ rls_Inventory ������ ������������ (weaponType = 65536). ����� �� ��� ����� ����� ���������� ������������, ��� ���� �� ������ ���� ������ ������ rls_Inventory (� ������ ������: ����, "+name player+", �� ������, � ���� ��� ��� ������ ������� � �����)",
            "�� ������ ����� �������� ���� ��������, ������ ���� �����, ������� �������� ������� �� ������� ��������� stringtable.csv:\n�����������-���� ��� �������� ������ ��������� ��� ������ ""STR:@M:�����������������""\n�����������-���� ����������� � displayNameMagazine � shortNameMagazine ������ ��������� ��� ������ ""STR:@M:ACT:�����������������""",
            "��� ���� ��� ��������� ��������, ��� �e�����\n" +
            "���� �� �������� �������� ������ � ������� �� �����, �� ������� �����, ���:\n"+
            "������ ������������� � ����� ������� ""GameItemRegister\register.sqf"" � ��������� W, � ��� ����������� ������� ""STR:@W:""\n" +
            "������� ������������� � ����� ������� ""GameItemRegister\register.sqf"" � ��������� V, � �� ����������� ������� ""STR:@V:""",
            "����� ������ ������������� ���� �� ������, ������ � stringtable.csv ������ ��� ������ ��� ������, ���������, " +
            "��������� � ����� � ������� ������ ""GameItemRegister\genItemRegisterBasedOnStringtable�svData.pl"" (��� ����� ����������� ������������� perl).",
            "������ ������ ����������� � ������������ ������� ������ ��������� � ���� ""GameItemRegister\register.sqf"" � ��������������� ���������.",
            "��� ������ � ������� ��������� ""GameItemRegister\register.sqf"" ������� ������� � ���� �������������� �� �����",
            [
                ["�-�-�! ���-��!! � ������ ������ ��� ���� �����!", "[trade]"],
                ["����", "[exit]"]
            ]
        ]
    }
]
