export HRB_DIR="/Developer/harbour"
export HRB_INC="$HRB_DIR/include"
export HRB_LIB="$HRB_DIR/lib/darwin/gcc"

export APACHE="/usr/local/mac-dev-env/apache-2.4.39"

$HRB_DIR/bin/darwin/gcc/harbour -n ../main.prg

apxs -c -i -e -I$HRB_INC -L$HRB_LIB -Wl,--start-group -lhbvm -lhbrtl -lhbcplr -lhbpp -lhbcommon -lhbrdd -lrddntx -lrddfpt -lhbmacro -lhbsix -lgttrm -lm -Wl,--end-group ../mod_harbour.c ./main.c

$APACHE/bin/httpd -k restart

rm -rf .libs
rm *.c
rm *.o
rm *.lo
rm *.slo