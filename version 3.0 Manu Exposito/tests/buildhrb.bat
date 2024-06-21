@echo off
@cls
@set path=c:\harbour\bin
@set include=c:\harbour\include

del %1.hrb


@echo ============
@echo Building HRB
@echo ============

harbour %1.prg /n /w /gh

pause






