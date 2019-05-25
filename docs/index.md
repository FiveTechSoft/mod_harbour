---
layout: default
---

**Harbour for the web is finally here**. It took years to understand what we really need and how to implement it. But the Harbour for the web momentum, the xbase developers web momentum, has **finally arrived**.

mod Harbour is an **extension module** for Apache that provides full support to **execute PRGs and HRBs files from the web**.

If you are a **Windows developer**, you can build the web **from your Windows 10 bash** and then simply **run your PRGs on Edge or Chrome** powered by **Apache on the bash** using the **mod Harbour extension**.

# Windows 10 bash support

The Windows 10 WSL (Windows SubSystem for Linux) lets you use Ubuntu 18.04 (about 200 mb) from your Windows 10 bash and install Apache and MySQL server on it. **Detailed instructions** are provided in the [mod Harbour repo wiki](https://github.com/FiveTechSoft/mod_harbour/wiki).

## OSX support

The mod Harbour is **already available** for the [Macs](https://github.com/FiveTechSoft/mod_harbour/tree/master/osx)
With an **easy to use installer** that sets up everything for you.

### Linux support

**mod Harbour** versions for **Ubuntu** and **CentOS 7** are already available. Use Ubuntu from your Windows 10 bash, code your PRGs from
Windows 10 using for favorite source code editor and run the PRGs from Edge or Chrome. Apache server and MySQL server from Ubuntu give you all you need. The perfect environment for creating web applications using Harbour in records time.

```c
// typicall Harbour PRG running on the web
#xcommand ? <cText> => AP_RPuts( <cText> )

function Main()

   ? "Hello world"
   
return nil   
```

#### DBFs support

Have your DBFs running on the web in record time. Simply copu them to /var/www/test in the Apache server, set the right permissions for the folder and you are ready to go. Please review samples/dbedit.prg and dbrowse.prg.

##### MySQL support

If you prefer to use MySQL then mod Harbour has everything you need for it. Please review samples/mysql.exe for a complete example that you can use as a template.

##### Apache API support functions

mod Harbour provides you easy to use function that deliver all the Apache API power to your apps. Check the user IP, check if the user is doing a GET or a POST. Retrieve the provided parameters from the browsers, and more...

