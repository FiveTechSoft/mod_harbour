@set oldinclude=%INCLUDE%
call "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
c:\harbour\bin\win\msvc64\hbmk2 modharbour.hbp -comp=msvc64
@set Path=""
@set INCLUDE=%oldinclude%
