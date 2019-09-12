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

**5. libharbour.dll has to be copied here:**

c:\Windows\SysWOW64\inetsrv\

and give it proper permissions: read and execute 
