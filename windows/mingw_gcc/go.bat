set HB_USER_PRGFLAGS=-I-
set PATH=c:\gcc81w64\bin\;%PATH%
gcc -Ic:\Apache24\include\ -shared mod_harbour.c c:\Apache24\lib\libhttpd.lib c:\Apache24\lib\libapr-1.lib c:\Apache24\lib\libaprutil-1.lib -omod_harbour.so
