@set oldpath=%Path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
c:\harbour\bin\win\msvc\hbmk2 modharbour.hbp -comp=msvc -hbx=modharbour.hbx
@set Path=%oldpath%
@set INCLUDE=%oldinclude%