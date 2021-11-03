@set oldpath=%Path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
set HB_BUILD_DEBUG=yes
set HB_TR_LEVEL=HB_TR_DEBUG
set HB_HOST_BIN=c:\harbour\bin\win\bcc
c:\harbour\bin\win\bcc\hbmk2 modharbour.hbp -comp=msvc64 -Lc:\Apache24\lib -hbx=modharbour.hbx
@set Path=%oldpath%
@set INCLUDE=%oldinclude%