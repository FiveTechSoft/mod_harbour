export HRB_DIR="/Developer/harbour-apache"
export HRB_INC="$HRB_DIR/include"
export HRB_LIB="$HRB_DIR/lib/darwin/gcc"

export APACHE="/Users/lailton/Developer/harbour-apache/apache/apache-2.4.39"

$APACHE/bin/apxs -c -i -e -I$HRB_INC -L$HRB_LIB -Wl,--start-group -lhbvm -lhbrtl -lhbcplr -lhbpp -lhbcommon -lhbrdd -lrddntx -lrddfpt -lhbmacro -lhbsix -lgttrm -lm -Wl,--end-group mod_harbour.c

$APACHE/bin/httpd -k restart

rm -rf .libs
rm *.o
rm *.la
rm *.lo
rm *.slo
