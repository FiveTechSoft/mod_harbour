To build hbcurl.a on Debian:

hbcurl.hbm
```
/home/user/harbour/contrib/hbcurl/hbcurl.hbm                                                  
-inc

-o${hb_targetname}
-workdir=${hb_work}/${hb_plat}/${hb_comp}/${hb_targetname}

-w3 -es2

#-depkeyhead=curl:curl/curl.h
-depkeyhead=curl:/usr/include/x86_64-linux-gnu/curl/curl.h
-depcontrol=curl:no{HB_BUILD_3RDEXT='no'}
-depcontrol=curl:${HB_WITH_CURL}
#-depincpath=curl:/usr/include
-depincpath=curl:/usr/include/x86_64-linux-gnu/curl

hbcurl.hbx

core.c
```
