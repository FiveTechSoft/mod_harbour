@set oldpath=%Path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
msbuild msvc\mod_harbour.sln /p:Configuration=Release
c:\harbour\bin\win\msvc64\hbmk2 modharbour.hbp -comp=msvc64 -Lc:\Apache24\lib
@set Path=%oldpath%
@set INCLUDE=%oldinclude%