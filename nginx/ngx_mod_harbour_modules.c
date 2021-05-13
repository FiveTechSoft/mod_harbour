
#include <ngx_config.h>
#include <ngx_core.h>

extern ngx_module_t  ngx_mod_harbour;

ngx_module_t *ngx_modules[] = {
    &ngx_mod_harbour,
    NULL
};

char *ngx_module_names[] = {
    "ngx_mod_harbour",
    NULL
};

char *ngx_module_order[] = {
    NULL
};

