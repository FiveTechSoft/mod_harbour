<?php
   $result = shell_exec( "./modharbour modpro.prg" );
   print( substr( $result, strpos( $result, chr( 10 ).chr( 10 ) ) + 1 ) );
?>
