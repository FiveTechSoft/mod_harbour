//------------------------------------------------------------------------------
// Mod_harbour
//------------------------------------------------------------------------------

#ifndef MOD_APACHE_CH_
#define MOD_APACHE_CH_

//------------------------------------------------------------------------------

#include "hbhrb.ch"
#include 'hbclass.ch'
#include "hbthread.ch"
#include "fileio.ch"
#include "error.ch"

#define _MODNAME    'Mod_HarbourPlus'
#define _MODVERSION '1.00'
#define _MODVERDATE _MODNAME + " v." + _MODVERSION + "." +  __DATE__ 

#define CRLF        '<br>'
#define REQUESTVAR  THREAD STATIC

#xcommand ? [<explist,...>] => ap_echo( [<explist>,] '<br>' )
#xcommand ?? [<explist,...>] => ap_echo( [<explist>,] "" )

#xcommand BLOCKS TO <b> [ PARAMS [<v1>] [,<vn>] ] [ TAGS <t1>,<t2> ];
=> #pragma __cstream | <b>+=mh_replaceBlocks( %s, "{{", "}}" [,<(v1)>][+","+<(vn)>] [, @<v1>][, @<vn>] )

#xcommand DEFAULT <v1> TO <x1> [, <vn> TO <xn> ] ;
=> IF <v1> == NIL ; <v1> := <x1> ; END [; IF <vn> == NIL ; <vn> := <xn> ; END ]

#xcommand DEFAULT <v1> := <x1> [, <vn> TO <xn> ] ;
=> IF <v1> == NIL ; <v1> := <x1> ; END [; IF <vn> == NIL ; <vn> := <xn> ; END ]

#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS

//------------------------------------------------------------------------------

#endif 				// MOD_APACHE_CH_

//------------------------------------------------------------------------------
