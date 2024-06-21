//------------------------------------------------------------------------------
#ifndef MH_EXTERNS_CH_
#define MH_EXTERNS_CH_
//------------------------------------------------------------------------------
// Incluye los simbolos de Harbour

#define __HBEXTERN__HARBOUR__REQUEST
#include "harbour.hbx"

//------------------------------------------------------------------------------
// Incluye simbolos de algunas contrib
//------------------------------------------------------------------------------

#define __HBEXTERN__HBHPDF__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbhpdf/hbhpdf.hbx"
#define __HBEXTERN__XHB__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/xhb/xhb.hbx"
#define __HBEXTERN__HBCT__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbct/hbct.hbx"
#define __HBEXTERN__HBCURL__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbcurl/hbcurl.hbx"
#define __HBEXTERN__HBNETIO__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbnetio/hbnetio.hbx"
#define __HBEXTERN__HBMZIP__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbmzip/hbmzip.hbx"
#define __HBEXTERN__HBZIPARC__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbziparc/hbziparc.hbx"
#define __HBEXTERN__HBSSL__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbssl/hbssl.hbx"
#define __HBEXTERN__HBTIP__REQUEST
#include "u:/desarrollo/comp/xc/hb/contrib/hbtip/hbtip.hbx"

//------------------------------------------------------------------------------
// Incluye simbolos de mod_harbour
//------------------------------------------------------------------------------

// Funciones de iterfaz con Apache
extern AP_RPUTS, AP_RWRITE, AP_ECHO
extern AP_SETSYSENV, AP_DELETESYSENV, AP_GETENV, AP_GETSYSENV, AP_GETFILENAME
extern AP_GETMETHOD, AP_GETBODY, AP_GETHEADERSIN, AP_GETHEADERSOUT
extern AP_GETURI, AP_GETUSERIP, AP_GETHOSTNAME, AP_GETARGS, AP_GETSTATUS 
extern AP_SETHEADEROUT, AP_SETPERSISTENT, AP_GETPERSISTENT, AP_GETSCRIPTPATH
extern AP_COOKIEREADALL, AP_COOKIEWRITE, AP_COOKIEREAD
extern AP_COOKIECHECK, AP_COOKIEREMOVE
extern AP_SETCGIVAR, AP_READPOST, AP_READGET, AP_SETCONTENTTYPE 
extern AP_GETCONTENTTYPE, AP_URLDECODE, AP_URLENCODE, AP_HTMLENCODE, AP_ESCAPEHTML

// Funciones interface de APR LIB
extern APR_LOCK, APR_TRYLOCK, APR_UNLOCK, APR_MUTEXCREATE, APR_MUTEXLOCK
extern APR_MUTEXTRYLOCK, APR_MUTEXUNLOCK, APR_MUTEXDESTROY, APR_FILELOAD
extern APR_READCODE, APR_TIMENOW, APR_HTTIME
extern APR_MSECONEDAY, APR_MSECONEHR, APR_MSECONEMIN, APR_MSECONESEC

// Otras funciones
extern AP_STRFROMPTR, AP_INTFROMPTR

// Funciones de depuracion solo en windows (quitar cuando no sean necesarias)
#ifdef __PLATFORM__WINDOWS
	extern OUTSTR, OUTNUM
#endif

//------------------------------------------------------------------------------
// Incluir aqui los *.hbx que se quieran agregar para usar

//------------------------------------------------------------------------------
#endif 				// Fin de MH_EXTERNS_CH_
//------------------------------------------------------------------------------
