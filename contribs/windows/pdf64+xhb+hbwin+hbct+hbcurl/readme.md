en src/rtl/apache.prg tienes que añadir estas líneas:

#define __HBEXTERN__HBFIMAGE__REQUEST

#include "..\..\..\..\..\contrib\hbfimage\hbfimage.hbx

eso hace que todos los símbolos de la libreria hbfimage sean declarados extern por apache.prg y asi se enlacen

cuando ejecutes make, no llegará a construirse pues faltan esos símbolos

y entonces ejecutas go.bat desde mod_harbour/contribs/windows/pdf64%2Bxhb%2Bhbwin%2Bhbct%2Bhbcurl
para que se construya libharbour.dll

tendrás que añadir el nombre hbfimage.lib al fichero libs.txt

y si faltase alguna lib de Windows, añades el nombre de la lib a windows.txt
