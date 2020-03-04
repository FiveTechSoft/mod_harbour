**0. Download and install Microsoft Visual C++ Redistributable for VSC2019**

https://github.com/FiveTechSoft/mod_harbour/blob/master/IIS/bin/VC_redist.x64.exe

**1. Enabling IIS and required IIS components on Windows**

Open Control Panel and click Programs and Features > Turn Windows features on or off.

Enable Internet Information Services.

Expand the Internet Information Services feature and verify that the web server components listed below are enabled.

Click OK

**2. Installing mod_harbour**

Open IIS administrator

Click on modules

On the right side click on configure native modules

Click on register

Select mod_harbour.dll

**3. Create some test files**

Go to c:\inetpub\wwwroot\ 

Create a hello.prg

Create a test.html

**4. From the web browser go to localhost/hello.prg**

Also go to localhost/test.html

**5. libharbour.dll, libcurl.dll, libcrypto-1_1-x64.dll, libssl-1_1-x64.dll have to be copied here:**

c:\Windows\System32\inetsrv\

and give it proper permissions: read and execute 

***

https://www.w3schools.com/asp/coll_servervariables.asp
