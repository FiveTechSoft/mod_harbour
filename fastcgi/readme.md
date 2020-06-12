mod_harbour + fastCGI offer the fastest mod_harbour performance

mod_harbour acts as a server, always running, interacting with fastCGI

requests per seconds reach values around 95 or even higher. You can test it this way from Windows:

c:\Apache24\bin\ab.exe -n 100 -c 20 localhost/modharbour_samples/test.prg
