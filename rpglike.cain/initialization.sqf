
DEBUGHINT = { hint format _this };

playerMoney = 1000;

// ����� �������, ����������� ��� ������ ����������� ������ �������
call preprocessFile "Lib\shared.sqf";
call preprocessFile "Lib\hashes.sqf";

// ��������� ������ �������������� ���� NPC �� �����, �������� �� action-����, ��. Lib\NPCInteractionEngine\readme.ru.txt
// TRIG_PlayerCloseZone -- 15 �������� ������� � ���������� �� Any
TRIG_PlayerCloseZone call preprocessFile "lib\NPCInteractionEngine\init.sqf";
// ������ ������� ���������
call preprocessFile "GameItemRegister\init.sqf";
// ������� ������ � ��������
call preprocessFile "Lib\CreateDialog\init.sqf";
// ������������� ������� �������� � ��������
call preprocessFile "NPC\Engine\init.sqf";
// ������������� ��������
call preprocessFile "Trade\init.sqf";

