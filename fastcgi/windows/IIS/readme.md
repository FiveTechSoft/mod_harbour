https://docs.microsoft.com/en-us/iis/configuration/system.webserver/fastcgi/application/

Launch IIS manager from "Control Pannel, Administrative tools."

Click on the main IIS server, (same name as the server or computer itself)
From the IIS section (the last one), look for "Handler Mapping icon" and double-click it.

On the right side pannel, look for "ADD an handler mapping"

Request Path : *.prg, *.hrb
Modules : Select FastCgi
Executable : c:\modharbour\modharbour.exe
Name : Mod_Harbour_FCGI (for exemple)

Now click on the button (request restriction) and uncheck the main box then OK

Click now on OK. Restart your IIS server. Samples should be installed as already described in mod_harbour IIS

Don't forget to give the user IIS_IUSRS the right to the samples folder.

many thanks to JF. Lefebvre for his help with this guide :-)
