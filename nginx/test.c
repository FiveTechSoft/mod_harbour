// build it doing: gcc test.c -ldl -otest 

#include <stdio.h>
#include <dlfcn.h>

int main()
{
   dlopen( "./ngx_mod_harbour.so", RTLD_NOW );
   printf( "%s\n", dlerror() );
   
   return 0;
}
