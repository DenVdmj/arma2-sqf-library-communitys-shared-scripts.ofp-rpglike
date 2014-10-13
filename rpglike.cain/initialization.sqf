
DEBUGHINT = { hint format _this };

playerMoney = 1000;

// Общие функции, необходимые для работы большинства других функций
call preprocessFile "Lib\init.sqf";

// Позволяет делать интерактивными всех NPC на крате, добавляя им action-меню, см. Lib\NPCInteractionEngine\readme.ru.txt
// TRIG_PlayerCloseZone -- 15 метровый триггер с активацией на Any
TRIG_PlayerCloseZone call preprocessFile "lib\NPCInteractionEngine\init.sqf";
// реестр игровых предметов
call preprocessFile "GameItemRegistry\init.sqf";
// функции работы с дисплеем
call preprocessFile "Lib\CreateDialog\init.sqf";
// инициализация системы диалогов с неписями
call preprocessFile "NPC\Engine\init.sqf";
// инициализация торговли
call preprocessFile "Trade\init.sqf";

