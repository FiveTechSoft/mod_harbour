#include <http_protocol.h>
#include <hbapi.h>

request_rec * GetRequestRec( void );

HB_FUNC( AP_RWRITE )
{
   hb_retni( ap_rwrite( ( void * ) hb_parc( 1 ), ( int ) hb_parclen( 1 ), GetRequestRec() ) );
}