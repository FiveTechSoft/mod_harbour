@cls
@call "c:/program files/microsoft visual studio/2022/community/vc/auxiliary/build/vcvars64.bat"
@u:\desarrollo\comp\xc\hb\bin\hbmk2 -comp=msvc64 .\hbp\mod_harbour.hbp
@if errorlevel 1 goto error
@goto exit

:error
@echo *** Error compile ***

:exit
