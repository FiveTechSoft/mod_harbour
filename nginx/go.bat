@set oldpath=%path%
@set oldinclude=%include%
@set oldlib=%lib%
@set oldlibpath=%libpath%
@set current_dir=%cd%

@if exist "%ProgramFiles%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" (
     call "%ProgramFiles%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
) else (
     call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
)

@cd %current_dir%
c:\harbour\bin\win\bcc\hbmk2 mod.hbp -comp=msvc -Ic:\harbour\src\3rd\pcre -Ic:\nginx\src\core -Ic:\nginx\src\os\win32 -I. -Ic:\nginx\src\http -Ic:\nginx\src\event -Ic:\nginx\src\event\modules -Ic:\nginx\src\stream -Ic:\nginx\src\http\modules

@set path=%oldpath%
@set include=%oldinclude%
@set lib=%oldlib%
@set libpath=%oldlibpath%
@set oldpath=""
@set oldinclude=""
@set oldlib=""
@set oldlibpath=""
