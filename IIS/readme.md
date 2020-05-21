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

Create this symlink: (run cmd as administrator)

mklink /j modharbour_samples c:\mod_harbour\samples

enable Directories features from IIS panel

go to localhost/modharbour_samples

or

Create a hello.prg
Create a test.html

**4. From the web browser go to localhost/hello.prg**

Also go to localhost/test.html

***

In case that you experience any errors, please review the IIS log files at:

%SystemDrive%\inetpub\logs\LogFiles by default.

***

https://www.w3schools.com/asp/coll_servervariables.asp
