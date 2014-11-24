@echo off

@set SourceDir=%~dp0
@set TargetDir=%~dp0\..
@set WorkPlace=%~dp0\make\`workplace

@set ToolDir=%~dp0\make
@set ToolMakepbo="%ToolDir%\bin\cpbo.exe" -y -p
@set ToolPerl="%ToolDir%\bin\perl.exe" -I"%~dp0make\lib"
@set ToolOptcpp=%ToolPerl% "%ToolDir%\lib\optconf.pl"
@set ToolSQSPacker=%ToolPerl% "%ToolDir%\lib\sqs.packer.pl" "%ToolDir%\bin"
@set ToolRapify="%ToolDir%\bin\rapify.exe" -o


call:copydir "bin" "%SourceDir%" "%WorkPlace%"
cd "%WorkPlace%\bin"
%ToolOptcpp% "resource.cpp" "resource.opt.cpp" > "log-resource"
%ToolRapify% "resource.opt.cpp" "resource.bin"
xcopy /Y "resource.bin" "%TargetDir%\bin\"

@set addon=addons\vdmj_sqfcalc

call:copydir "%addon%" "%SourceDir%" "%WorkPlace%"

cd "%WorkPlace%\%addon%"

%ToolSQSPacker% "eval.sqf" "eval.sqs"
%ToolRapify% "config.cpp" "config.bin"

del /Q "config.cpp" > nul
mkdir "%TargetDir%\addons" > nul
del /Q "%TargetDir%\%addon%.pbo" > nul
%ToolMakepbo% "%WorkPlace%\%addon%" "%TargetDir%\%addon%.pbo"

goto:eof

:copydir
    if exist "%~3\%~1" (
        del /Q /F "%~3\%~1\*" > nul
    ) else (
        mkdir "%~3\%~1" > nul
    )
    xcopy "%~2\%~1" "%~3\%~1"
goto:eof
