
DEBUGHINT = { hint format _this };

playerMoney = 1000;

// ����� �������, ����������� ��� ������ ����������� ������ �������
call preprocessFile "Lib\init.sqf";

// ��������� ������ �������������� ���� NPC �� �����, �������� �� action-����, ��. Lib\NPCInteractionEngine\readme.ru.txt
// TRIG_PlayerCloseZone -- 15 �������� ������� � ���������� �� Any
TRIG_PlayerCloseZone call preprocessFile "lib\NPCInteractionEngine\init.sqf";
// ������ ������� ���������
call preprocessFile "GameItemRegistry\init.sqf";
// ������� ������ � ��������
call preprocessFile "Lib\CreateDialog\init.sqf";
// ������������� ������� �������� � ��������
call preprocessFile "NPC\Engine\init.sqf";
// ������������� ��������
call preprocessFile "Trade\init.sqf";

